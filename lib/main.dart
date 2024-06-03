import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

void main(List<String> args) {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StopWatch(),
    );
  }
}

class StopWatch extends StatefulWidget {
  const StopWatch({super.key});

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = false; // Modification ici pour ne pas afficher les heures

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (_stopWatchTimer.isRunning) {
            _stopWatchTimer.onStopTimer();
          } else {
            _stopWatchTimer.onStartTimer();
          }
        },
        onDoubleTap: () {
          if (!_stopWatchTimer.isRunning) {
            _stopWatchTimer.onStartTimer();
          }
        },
        onLongPress: () {
          _stopWatchTimer.onResetTimer();
        },
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: 0,
                  builder: (context, snapshot) {
                    final value = snapshot.data;
                    final displayTime =
                        StopWatchTimer.getDisplayTime(value!, hours: _isHours);
                    final parts = displayTime.split(':');
                    final minutes = parts.isNotEmpty ? parts[0] : '00';
                    final seconds =
                        parts.length > 1 ? parts[1].split('.')[0] : '00';
                    final milliseconds =
                        parts.length > 1 && parts[1].contains('.')
                            ? parts[1].split('.')[1]
                            : '000';

                    Color colorMinutes = const Color.fromARGB(
                        255, 183, 1, 7); // Rouge par défaut pour les minutes
                    Color colorSeconds = const Color.fromARGB(
                        255, 183, 1, 7); // Rouge par défaut pour les secondes
                    Color colorMilliseconds = const Color.fromARGB(255, 183, 1,
                        7); // Rouge par défaut pour les millisecondes

                    if (_stopWatchTimer.isRunning) {
                      colorMilliseconds = Colors
                          .white; // Les millisecondes passent en blanc si le timer est en cours
                      if (minutes != '00') {
                        colorMinutes = Colors
                            .white; // Les minutes passent en blanc si un des chiffres est supérieur à 0
                        colorSeconds = Colors
                            .white; // Les secondes restent blanc également si les minutes sont supérieures à 0
                      } else if (seconds != '00') {
                        colorSeconds = Colors
                            .white; // Les secondes passent en blanc si un des chiffres est supérieur à 0
                      }
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            minutes,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 110,
                              fontWeight: FontWeight.bold,
                              color:
                                  colorMinutes, // Utilisation de la variable 'color' ici
                              fontFamily: 'BebasKai',
                            ),
                          ),
                        ),
                        Text(
                          ':',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 90,
                            fontWeight: FontWeight.bold,
                            color:
                                colorMinutes, // Utilisation de la variable 'color' ici
                            fontFamily: 'BebasKai',
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            seconds,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 110,
                              fontWeight: FontWeight.bold,
                              color:
                                  colorSeconds, // Utilisation de la variable 'colorSeconds' ici
                              fontFamily: 'BebasKai',
                            ),
                          ),
                        ),
                        Text(
                          '.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 90,
                            fontWeight: FontWeight.bold,
                            color:
                                colorSeconds, // Utilisation de la variable 'color' ici
                            fontFamily: 'BebasKai',
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            milliseconds,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 110,
                              fontWeight: FontWeight.bold,
                              color:
                                  colorMilliseconds, // Utilisation de la variable 'color' ici
                              fontFamily: 'BebasKai',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
