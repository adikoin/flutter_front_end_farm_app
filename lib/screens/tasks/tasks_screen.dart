import 'package:flutter/material.dart';
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart' as tg;
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart';
import 'package:vulpes/models/task.dart';
import 'package:vulpes/models/user.dart';
import 'package:vulpes/util/user_operations.dart';
import 'package:url_launcher/url_launcher.dart';

final WebAppInitData webAppInitData = tg.initDataUnsafe;
final HttpService httpService = HttpService();

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _isLoading = false,
      isClaimAvailable = false,
      _error = false,
      _isButtonLoading = false,
      success = true;
  // FarmState _currentState = FarmState.initial;
  // int id = 784937345;
  // String username = '@username';
  int id = webAppInitData.user?.id as int;
  final username = webAppInitData.user?.username as String;
  User? user;

  @override
  void initState() {
    super.initState();
    // tg.expand();
    // fetchUser();
    fetchTasks();
  }

  fetchTasks() async {
    setState(() {
      _isLoading = true;
    });

    tasks = await httpService.getTasks(id);

    // print(tasks.length);

    setState(() {
      // tasks = tasks;
      _isLoading = false;
    });
  }

  List<Task> tasks = [];

  IconData getIcon(String icon) {
    IconData returnType = Icons.check;
    switch (icon) {
      case 'Icons.check':
        returnType = Icons.check;
        break;
      // continue alsoCat;
      // case 'notPaid':
      //   returnType = "Не оплачено";
      //   // print("it's a arrival");
      //   break;
      // case 'prePay':
      //   returnType = "Предоплата";
      //   break;
    }
    return returnType;
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
      backgroundColor: Colors.black,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Tasks',
                            style:
                                TextStyle(color: Colors.white, fontSize: 24)),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                            'We’ll reward you immediately with points after each task completion.',
                            style: TextStyle(color: Colors.white)),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return ListTile(
                              leading: const Text("\u2200"),
                              title: Text(task.title,
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(task.subtitle,
                                  style:
                                      const TextStyle(color: Colors.white70)),
                              trailing: TrailingWidget(task: task, id: id),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class TrailingWidget extends StatefulWidget {
  final Task task;
  final int id;

  const TrailingWidget({
    super.key,
    required this.task,
    required this.id,
  });

  @override
  // _TrailingWidgetState createState() => _TrailingWidgetState();
  State<TrailingWidget> createState() => _TrailingWidgetState();
}

class _TrailingWidgetState extends State<TrailingWidget> {
  Future<void>? _launched;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      // throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.task.status) {
      case 'completed':
        return ElevatedButton(
          onPressed: () async {
            var claim = await httpService.claimTask(widget.id, widget.task.id);
            if (claim) {
              setState(() {
                widget.task.status = "claimed";
              });
            }
          },
          child: const Text('Claim'),
        );

      case 'claimed':
        return const Icon(Icons.check, color: Colors.green);
      // return IconButton(
      //   icon: const Icon(Icons.assignment_turned_in, color: Colors.blue),
      //   onPressed: () {
      //     // Действие для кнопки "claimed"
      //   },
      // );
      case 'started':
        return ElevatedButton(
          onPressed: () async {
            var check = await httpService.checkTask(widget.id, widget.task.id);
            if (check) {
              setState(() {
                widget.task.status = "completed";
              });
            }
          },
          child: const Text('Check'),
        );
      default:
        return ElevatedButton(
          onPressed: () async {
            setState(() {
              final Uri toLaunch = Uri(
                scheme: 'https',
                host: widget.task.host,
                path: widget.task.path,
              );
              _launched = _launchInBrowser(toLaunch);
            });
            var start = await httpService.startTask(widget.id, widget.task.id);
            if (start) {
              setState(() {
                widget.task.status = "started";
              });
            }
          },
          child: const Text('Start'),
        );
    }
  }
}
