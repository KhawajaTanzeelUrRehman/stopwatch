import 'dart:async';
import 'package:flutter/material.dart';
import 'platform_alert.dart';

class StopWatch extends StatefulWidget {
  static const route = '/stopwatch';
  final String name;
  final String email;
  const StopWatch({Key? key, required this.name, required this.email})
      : super(key: key);
  @override
  State createState() => StopWatchState();
}

class StopWatchState extends State<StopWatch> {
  int? milliseconds = 0;
  Timer? timer;
  final laps = <int>[];
  final itemHeight = 60.0;
  final scrollController = ScrollController();
  bool isTicking = false;
  @override
  void _onTick(Timer time) {
    setState(() {
      milliseconds = milliseconds! + 100;
    });
  }

  void _lap() {
    setState(() {
      laps.add(milliseconds!);
      milliseconds = 0;
    });
    scrollController.animateTo(
      itemHeight * laps.length,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    String name = ModalRoute.of(context)?.settings.arguments?.toString() ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Text("Name is $name"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildCounter(context)),
          Expanded(child: _buildLapDisplay()),
        ],
      ),
    );
  }

  Container _buildCounter(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Laps: ${laps.length + 1}',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: Colors.white),
          ),
          Text(
            _secondsText(milliseconds!),
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 20),
          _buildControls()
        ],
      ),
    );
  }

  Row _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: isTicking
              ? null
              : () {
                  timer = Timer.periodic(
                      const Duration(milliseconds: 100), _onTick);
                  setState(() {
                    milliseconds = 0;
                    isTicking = true;
                  });
                },
          child: const Text('Start'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
          ),
          onPressed: isTicking ? _lap : null,
          child: const Text('Lap'),
        ),
        const SizedBox(width: 20),
        Builder(
            builder: (context) => TextButton(
                  child: Text('Stop'),
                  onPressed: isTicking ? () => _stopTimer(context) : null,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                )),
      ],
    );
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), _onTick);
    setState(() {
      milliseconds = 0;
      isTicking = true;
      laps.clear();
    });
  }

  void _stopTimer(BuildContext context) {
    setState(() {
      timer?.cancel();
      isTicking = false;
    });
    final controller =
        showBottomSheet(context: context, builder: _buildRunCompleteSheet);
    Future.delayed(const Duration(seconds: 5)).then((_) {
      controller.close();
    });
    // final totalRuntime =
    //     laps.fold(milliseconds ?? 0, (total, lap) => total + lap);
    // final alert = PlatformAlert(
    //   title: 'Run Completed!',
    //   message: 'Total Run Time is ${_secondsText(totalRuntime)}.',
    // );
    // alert.show(context);
  }

  Widget _buildRunCompleteSheet(BuildContext context) {
    final totalRuntime =
        laps.fold(milliseconds ?? 0, (total, lap) => total + lap);
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
        child: Container(
      color: Theme.of(context).cardColor,
      width: double.infinity,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Run Finished!', style: textTheme.headline6),
            Text('Total Run Time is ${_secondsText(totalRuntime)}.')
          ])),
    ));
  }

  String _secondsText(int milliseconds) {
    final seconds = milliseconds / 1000;
    return '$seconds seconds';
  }

  Widget _buildLapDisplay() {
    return Scrollbar(
      child: ListView.builder(
        controller: scrollController,
        itemExtent: itemHeight,
        itemCount: laps.length,
        itemBuilder: (context, index) {
          final milliseconds = laps[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
            title: Text('Lap ${index + 1}'),
            trailing: Text(_secondsText(milliseconds)),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
