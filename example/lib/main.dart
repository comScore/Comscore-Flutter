import 'package:comscore_analytics_flutter/comscore.dart';
import 'package:comscore_analytics_flutter_example/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initComscore();
  }

  Future<void> initComscore() async {
    PublisherConfiguration? publisher = await PublisherConfiguration.build(
        publisherId: "publisher_1",
        persistentLabels: {"publisher_1_1": "value_publisher1", "publisher_1_2": "value_publisher1"},
        startLabels: {"publisher_start_1": "value_publisher1"});

    Analytics.configuration.addClient(publisher);
    Analytics.configuration.enableImplementationValidationMode();
    Analytics.start();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
