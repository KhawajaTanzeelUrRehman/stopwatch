import 'dart:async';
import 'package:flutter/material.dart';

class StopWatch extends StatefulWidget {
  @override
  State createState() => StopWatchState();
}

class StopWatchState extends State<StopWatch> {
  int? seconds = 0;
  Timer? timer;
  bool isTicking = true;
  @override
  

  void _onTick(Timer time) {
    setState(() {
      seconds = seconds! + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Tanzeel Ur Rehman - Stopwatch',
          style: TextStyle(
            color: Colors.blue,
          ),
        )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$seconds ${_secondsText()}',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: Text('Start'),
                onPressed: isTicking ? null : _startTimer,
              ),
              SizedBox(width: 20),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: Text('Stop'),
                onPressed: isTicking ? _stopTimer : null,
              ),
            ],
          )
        ],
      ),
    );
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), _onTick);
    setState(() {
      seconds = 0;
      isTicking = true;
    });
  }

  void _stopTimer() {
    timer?.cancel();
    setState(() {
      isTicking = false;
    });
  }

  String _secondsText() => seconds == 1 ? 'second' : 'seconds';
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
