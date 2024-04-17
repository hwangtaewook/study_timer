import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Timer? _studyTimer;
  Timer? _breakTimer;

  int _studyTime = 0;
  int _breakTime = 0;
  bool _isRunning = false;

  final List<String> _lapTimes = [];
  final List<String> _lapBreakTimes = [];
  final List<String> _all = [];

  void _clickButton() {
    _isRunning = !_isRunning;
    if (_isRunning) {
      _studyStart();
      _breakPause();
    } else {
      _studyPause();
      _breakStart();
    }
  }

  void _studyStart() {
    _studyTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _studyTime++;
      });
    });
  }

  void _studyPause() {
    _studyTimer?.cancel();
  }

  void _breakStart() {
    _breakTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _breakTime++;
      });
    });
  }

  void _breakPause() {
    _breakTimer?.cancel();
  }

  void _reset() {
    setState(() {
      _isRunning = false;
      _studyTimer?.cancel();
      _breakTimer?.cancel();
      _lapTimes.clear();
      _lapBreakTimes.clear();
      _all.clear();
      _studyTime = 0;
      _breakTime = 0;
    });
  }

  void _recodeLapTime(String time) {
    _lapTimes.insert(0, '${_lapTimes.length + 1} $time');
  }

  void _recodeBreakLapTime(String time) {
    _lapBreakTimes.insert(0, '${_lapBreakTimes.length + 1} $time');
  }

  void _allTime(String time) {
    (_all.insert(0, time));
  }

  @override
  void dispose() {
    _studyTimer?.cancel();
    _breakTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int seconds = _studyTime ~/ 100;
    String sec = '${seconds % 60}'.padLeft(2, '0');
    String min = '${(seconds ~/ 60) % 60}'.padLeft(2, '0');
    String hour = '${seconds ~/ 3600}'.padLeft(2, '0');
    String hundredth = '${_studyTime % 100}'.padLeft(2, '0');

    int breakSeconds = _breakTime ~/ 100;
    String breakSec = '${breakSeconds % 60}'.padLeft(2, '0');
    String breakMin = '${(breakSeconds ~/ 60) % 60}'.padLeft(2, '0');
    String breakHour = '${breakSeconds ~/ 3600}'.padLeft(2, '0');
    String breakHundredth = '${_breakTime % 100}'.padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('순공시간')),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$hour시 $min분 $sec초',
                style: const TextStyle(fontSize: 50),
              ),
              // Text(
              //   hundredth,
              // ),
            ],
          ),
          SizedBox(
            width: 200,
            height: 100,
            child: ListView(
              children: _lapTimes.map((e) => Center(child: Text(e))).toList(),
            ),
          ),
          Text(
            '$breakHour시 $breakMin분 $breakSec초',
            style: const TextStyle(fontSize: 50),
          ),
          SizedBox(
            width: 200,
            height: 100,
            child: ListView(
              children:
                  _lapBreakTimes.map((e) => Center(child: Text(e))).toList(),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 200,
            height: 100,
            child: ListView(
              children:
                  _all.map((e) => Center(child: Text(e))).take(1).toList(),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  _reset();
                },
                child: const Icon(Icons.refresh),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _clickButton();
                    if (_isRunning == false) {
                      _recodeLapTime('$hour시 $min분 $sec초');
                    }
                    if (_isRunning == true && int.parse(breakHundredth) > 0) {
                      _recodeBreakLapTime('$breakHour시 $breakMin분 $breakSec초');
                    }
                  });
                },
                child: _isRunning
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
              ),
              FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () {
                  setState(() {
                    _allTime('''공부시간
$hour시 $min분 $sec초 
쉰시간
$breakHour시 $breakMin분 $breakSec초''');
                    _studyPause();
                    _breakPause();
                  });
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
