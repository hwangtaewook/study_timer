import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

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
  bool _isFront = true;

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
    _lapTimes.insert(0, '${_lapTimes.length + 1}. $time');
  }

  void _recodeBreakLapTime(String time) {
    _lapBreakTimes.insert(0, '${_lapBreakTimes.length + 1}. $time');
  }

  void exChange(_allTime) {
    Text(_allTime);
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
    FlipCardController _controller = FlipCardController();

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
        title: const Center(child: Text('')),
      ),
      body: Column(
        children: [
          SizedBox(height: 60),
          FlipCard(
            flipOnTouch: false,
            controller: _controller,
            front: Stack(
              children: [
                Transform.scale(
                  scale: 2,
                  child: Lottie.asset(
                    'assets/lottie/book.json',
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        '$hour : $min : $sec ',
                        style: const TextStyle(fontSize: 50, ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 100,
                        child: ListView(
                          children: _lapTimes
                              .map((e) => Center(child: Text(e)))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            back: Stack(
              children: [
                Transform.scale(
                  scale: 2,
                  child: Lottie.asset(
                    'assets/lottie/coffee.json',
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        '$breakHour : $breakMin : $breakSec ',
                        style: const TextStyle(fontSize: 50, fontFamily: 'KCC-Hanbit'),
                      ),
                      SizedBox(
                        width: 200,
                        height: 100,
                        child: ListView(
                          children: _lapBreakTimes
                              .map((e) => Center(child: Text(e)))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 200,
            height: 100,
            child: ListView(
              children: _all
                  .map((e) => Center(
                          child: Text(
                        e,
                        textAlign: TextAlign.center,
                      )))
                  .take(1)
                  .toList(),
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
                  if (_controller.state?.isFront == false) {
                    _controller.toggleCard();
                  }
                },
                child: const Icon(Icons.refresh),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _clickButton();
                    if (_isRunning == false) {
                      _recodeLapTime('$hour : $min : $sec');
                    }
                    if (_isRunning == true && int.parse(breakHundredth) > 0) {
                      _recodeBreakLapTime('$breakHour : $breakMin : $breakSec');
                    }
                    if (int.parse(hundredth) > 0) {
                      _controller.toggleCard();
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
                    _allTime(
                        '공부시간\n$hour : $min : $sec\n휴식시간\n$breakHour : $breakMin : $breakSec');
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
