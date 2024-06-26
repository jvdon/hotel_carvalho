import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_carvalho/pages/quartos_page.dart';
import 'package:hotel_carvalho/pages/reservas_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  databaseFactory = databaseFactoryFfi;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List pages = [
    ReservasPage(),
    QuartosPage(),
  ];
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: pages[selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedPage,
          items: const [
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_2_fill), label: "Reservas"),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.bed_double_fill), label: "Quartos"),
          ],
          onTap: (value) {
            setState(() {
              selectedPage = value;
            });
          },
        ),
      ),
    );
  }
}
