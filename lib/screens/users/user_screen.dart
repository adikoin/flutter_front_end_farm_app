import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart' as tg;
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart';
import 'package:flutter_money/flutter_money.dart';
import 'package:vulpes/models/user.dart';
import 'package:vulpes/util/user_operations.dart';

final WebAppInitData webAppInitData = tg.initDataUnsafe;
final HttpService httpService = HttpService();

enum FarmState { initial, farming, claimingReward }

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _isLoading = false,
      isClaimAvailable = false,
      _error = false,
      _isButtonLoading = false,
      success = true;
  FarmState _currentState = FarmState.initial;
  // int id = 0;
  // String username = '@username';
  int id = webAppInitData.user?.id as int;
  final username = webAppInitData.user?.username as String;
  FlutterMoney fmf = FlutterMoney(amount: 0);
  DateTime? lastFarmStartTime;
  Timer? _timer;
  Duration timeLeft = Duration.zero;
  User? user;

  @override
  void initState() {
    super.initState();
    tg.expand();
    fetchUser();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (lastFarmStartTime != null) {
        final now = DateTime.now();
        final endTime = lastFarmStartTime!.add(const Duration(hours: 8));
        setState(() {
          timeLeft = endTime.difference(now);
          if (timeLeft.isNegative) {
            timeLeft = Duration.zero;
            _timer?.cancel();
            _currentState = FarmState.claimingReward;
          }
        });
      }
    });
  }

  Future<void> fetchUser() async {
    setState(() {
      _isLoading = true;
    });

    // Replace with actual user ID
    // const id = 784937345;

    final fetchedUser = await httpService.getUser(id);

    if (fetchedUser != null) {
      setState(() {
        user = fetchedUser;
        fmf.amount = user!.balance as double;
        lastFarmStartTime = user!.lastFarmStartTime;
        String dateString =
            '0001-01-01T00:00:00Z'; // Приведенная к формату ISO 8601

        // Парсинг строки в DateTime
        DateTime dateTime = DateTime.parse(dateString);
        if (lastFarmStartTime != dateTime) {
          DateTime now = DateTime.now();
          Duration timeDifference = now.difference(lastFarmStartTime!);

          if (timeDifference.isNegative) {
            // More than 8 hours have passed, reset lastFarmStartTime
            _currentState = FarmState.claimingReward;
          } else {
            // Less than 8 hours have passed, update timer
            _startTimer();
            _currentState = FarmState.farming;
          }
        } else {
          _currentState = FarmState.initial;
        }
      });
    } else {
      setState(() {
        _error = true;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> startFarm() async {
    if (user != null) {
      setState(() {
        _isButtonLoading = true;
      });

      // const id = 784937345;

      final success = await httpService.startFarm(id);
      // await Future.delayed(Duration(seconds: 5));
      if (success) {
        setState(() {
          lastFarmStartTime = DateTime.now();
          _currentState = FarmState.farming;
          _startTimer();
        });
      }

      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  Future<void> claimReward() async {
    if (user != null) {
      setState(() {
        _isButtonLoading = true;
      });
      // const id = 784937345;
      final success = await httpService.claimReward(id);
      if (success) {
        setState(() {
          // lastFarmStartTime = null;
          // timeLeft = Duration.zero;
          fmf.amount = fmf.amount + 80;
          _currentState = FarmState.initial;
        });
      }

      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('AdiKoin'),
      //   // centerTitle: true,
      // ),
      body: _error
          ? const Center(
              child: Text("Error"),
            )
          : _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue,
                        child: Text(
                          'A',
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // const Text(
                      //   'username',
                      //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      // ),
                      Text(
                        username,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        fmf
                            .copyWith(
                                symbol: '\u2200', symbolAndNumberSeparator: ' ')
                            .output
                            .symbolOnLeft,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      if (_currentState == FarmState.initial)
                        Expanded(
                          child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: _isButtonLoading
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              Colors.red, // foreground
                                        ),
                                        onPressed: startFarm,
                                        child: const Text('Start Farming'),
                                      ),
                              )),
                        )
                      else if (_currentState == FarmState.farming)
                        Expanded(
                          child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text("Farming..."),
                                    Text(
                                      "${timeLeft.inHours}:${(timeLeft.inMinutes % 60).toString().padLeft(2, '0')}:${(timeLeft.inSeconds % 60).toString().padLeft(2, '0')}",
                                    ),
                                  ],
                                ),
                              )),
                        )
                      // Column(
                      //   children: [
                      //     const Text("Farming..."),
                      //     Text(
                      //       "${timeLeft.inHours}:${(timeLeft.inMinutes % 60).toString().padLeft(2, '0')}:${(timeLeft.inSeconds % 60).toString().padLeft(2, '0')}",
                      //     ),
                      //   ],
                      // )
                      else if (_currentState == FarmState.claimingReward)
                        Expanded(
                          child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: _isButtonLoading
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              Colors.green, // foreground
                                        ),
                                        onPressed: claimReward,
                                        child: const Text('Claim'),
                                      ),
                              )),
                        ),

                      // Expanded(
                      //   child: Align(
                      //       alignment: FractionalOffset.bottomCenter,
                      //       child: Padding(
                      //         padding: const EdgeInsets.only(bottom: 20.0),
                      //         child: _isButtonLoading
                      //             ? const CircularProgressIndicator()
                      //             : ElevatedButton(
                      //                 style: ElevatedButton.styleFrom(
                      //                   foregroundColor: Colors.white,
                      //                   backgroundColor:
                      //                       Colors.red, // foreground
                      //                 ),
                      //                 onPressed: startFarm,
                      //                 child: const Text('Start Farming'),
                      //               ),
                      //       )),
                      // ),
                    ],
                  ),
                ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.task),
      //       label: 'Tasks',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.people),
      //       label: 'Frens',
      //     ),
      //   ],
      // ),
    );
  }
}
