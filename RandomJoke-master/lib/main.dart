import 'package:flutter/material.dart';
import 'package:randomjoke/screens/favorite_jokes_screen.dart';
import 'services/api_services.dart';
import 'screens/joke_list_screen.dart';
import 'screens/random_joke_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'services/notifications_service.dart';




void testNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'test_channel_id',
    'Test Channel',
    channelDescription: 'This is a test notification channel',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await localNotificationsPlugin.show(
    0,
    'Test Notification',
    'This is a test notification body.',
    platformChannelSpecifics,
  );
}




Future<void> scheduleNotification() async {
  await localNotificationsPlugin.zonedSchedule(
    0,
    'Daily Joke',
    'Check out the joke of the day!',
    tz.TZDateTime.now(tz.local).add(const Duration(hours: 24)),
    const NotificationDetails(
      android: AndroidNotificationDetails('daily_joke_channel', 'Daily Joke'),
    ),
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime, androidScheduleMode: AndroidScheduleMode.exact,
  );
}


void setupFirebaseMessaging() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received message: ${message.notification?.title}');
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  await initializeNotifications();
  scheduleNotification();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Joke Types'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<String>> _jokeTypes;

  @override
  void initState() {
    super.initState();
    _jokeTypes = ApiService.fetchJokeTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
            ElevatedButton(
            onPressed: testNotification,
            child: const Text('Show Test Notification'),
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RandomJokeScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteJokesScreen()),
              );
            },
          ),

        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _jokeTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No joke types found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final type = snapshot.data![index];
                return ListTile(
                  title: Text(type),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JokeListScreen(jokeType: type),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
