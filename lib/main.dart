import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: (MediaQuery.of(context).size.width > 500)
          ? const NavigationBar()
          : null,
      drawer: (MediaQuery.of(context).size.width <= 500)
          ? const NavigationBar()
          : null,
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      print(constraints);
      return SizedBox(
        width: constraints.maxWidth / 3,
        child: NavigationRail(
            extended: true,
            selectedIndex: selectedIndex,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text("Home")),
              NavigationRailDestination(
                  icon: Icon(Icons.alarm), label: Text("Alarm"))
            ]),
      );
    });
  }
}

class ConnectivityStatus {
  static final ConnectivityStatus _obj =
      ConnectivityStatus._(StreamController<bool>.broadcast(), Connectivity());
  ConnectivityStatus._(this.connectionController, this.connectivity);
  factory ConnectivityStatus() => _obj;

  void ensureInitialized() {}
  final StreamController<bool> connectionController;
  final Connectivity connectivity;
  Stream<bool> get isConnected => connectionController.stream;

  StreamSubscription<bool>? subscription;

  Future<bool> getConnection() async {
    bool isConnected;
    final List<InternetAddress> result =
        await InternetAddress.lookup("google.com");
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isConnected = true;
    } else {
      isConnected = false;
    }
    connectionController.sink.add(isConnected);
    return isConnected;
  }
}
