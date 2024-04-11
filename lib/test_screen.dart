import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // Set initial and maximum draggable sheet sizes
  final double _initialHeight = 0.5;
  final double _minHeight = 0.25;
  final double _maxHeight = 1.0;
  // Keep track of the last known size to decide on release
  double _lastExtent = 0.3;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Custom Bottom Sheet')),
        body: Stack(
          children: [
            Positioned.fill(child: Center(child: Text('Main content here'))),
            DraggableScrollableSheet(
              initialChildSize: _initialHeight,
              minChildSize: _minHeight,
              maxChildSize: _maxHeight,
              builder: (BuildContext context, ScrollController scrollController) {
                // Listen to the controller to decide when to expand or collapse

                return Scaffold(
                  body: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {

                          });
                        },
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: 30,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ListTile(title: Text('Item $index'));
                                    },
                                  ),
                              ),
                            ),
                          ],
                        ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              // Toggle between the initial and last extent for the demo
              _lastExtent = _lastExtent == _minHeight ? _maxHeight : _minHeight;
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
