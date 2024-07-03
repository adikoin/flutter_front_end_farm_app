import 'package:flutter/material.dart';
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart' as tg;
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart';
import 'package:vulpes/models/user.dart';
import 'package:vulpes/util/user_operations.dart';

final WebAppInitData webAppInitData = tg.initDataUnsafe;
final HttpService httpService = HttpService();

// enum FarmState { initial, farming, claimingReward }

class FrensScreen extends StatefulWidget {
  const FrensScreen({super.key});

  @override
  State<FrensScreen> createState() => _FrensScreenState();
}

class _FrensScreenState extends State<FrensScreen> {
  bool _isLoading = false,
      isClaimAvailable = false,
      _error = false,
      _isButtonLoading = false,
      success = true;
  // FarmState _currentState = FarmState.initial;
  int id = 0;
  String username = '@username';
  //  final username = webAppInitData.user?.username as String;
  User? user;

  @override
  void initState() {
    super.initState();
    // tg.expand();
    // fetchUser();
  }

  // Future<void> fetchUser() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   // Replace with actual user ID
  //   const id = 784937345;

  //   final fetchedUser = await httpService.getUser(id);

  //   if (fetchedUser != null) {
  //     setState(() {
  //       user = fetchedUser;
  //       fmf.amount = user!.balance as double;
  //       lastFarmStartTime = user!.lastFarmStartTime;
  //       String dateString =
  //           '0001-01-01T00:00:00Z'; // Приведенная к формату ISO 8601

  //       // Парсинг строки в DateTime
  //       DateTime dateTime = DateTime.parse(dateString);
  //       if (lastFarmStartTime != dateTime) {
  //         DateTime now = DateTime.now();
  //         Duration timeDifference = now.difference(lastFarmStartTime!);

  //         if (timeDifference.isNegative) {
  //           // More than 8 hours have passed, reset lastFarmStartTime
  //           _currentState = FarmState.claimingReward;
  //         } else {
  //           // Less than 8 hours have passed, update timer
  //           _startTimer();
  //           _currentState = FarmState.farming;
  //         }
  //       } else {
  //         _currentState = FarmState.initial;
  //       }
  //     });
  //   } else {
  //     setState(() {
  //       _error = true;
  //     });
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _error
          ? const Center(
              child: Text("Error"),
            )
          : _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Center(
                  child: Column(
                    children: [Text("Soon")],
                  ),
                ),
    );
  }
}
