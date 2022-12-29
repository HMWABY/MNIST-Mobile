import 'package:flutter/material.dart';
import 'package:mnist_mobile/pages/image.dart';
import 'package:mnist_mobile/pages/real_time.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MNIST Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MNIST Handwritten Digits'),
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
  int _currentIndex = 0;
  final List<Widget> _pageList = [
    const RealTimePage(),
    const ImagePage(),
  ];
  final List<BottomNavigationBarItem> _barItem = [
    const BottomNavigationBarItem(icon: Icon(Icons.create), label: 'Real-Time'),
    const BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Image'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _pageList[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: _barItem,
          iconSize: 25,
          selectedFontSize: 16,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
        ));
  }
}
