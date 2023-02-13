
import 'dart:async';

import 'package:flutter/foundation.dart';

class TimeService {

  TimeService() {
    setHeartbeatInterval();
  }

  DateTime now() => DateTime.now();

  int nowMillis() => now().millisecondsSinceEpoch;

  /*Stream<int> get heartbeatSource => Stream<int>
      .periodic(const Duration(milliseconds: 400), (x) => x)
      .asBroadcastStream();*/

  final _controller = StreamController<int>();
  Stream<int> get heartbeat => _controller.stream.asBroadcastStream();

  Stream<int>? heartbeatSource;
  StreamSubscription<int>? heartbeatSourceListener;
  var heartbeatInterval = 400;

  void setHeartbeatInterval({ int millis = 400 }) {
    final change = heartbeatInterval != millis;
    if(change) {
      debugPrint("interval old: $heartbeatInterval, new: $millis");
    }

    if(heartbeatSource != null && change) {
      heartbeatSourceListener?.cancel();
      heartbeatSourceListener = null;
      heartbeatSource = null;
    }

    if(heartbeatSource == null) {
      heartbeatInterval = millis;
      heartbeatSource = Stream.periodic(Duration(milliseconds: heartbeatInterval), (x) => x);
      heartbeatSourceListener = heartbeatSource?.listen((time) {
        _controller.add(time);
      });
    }
  }

}
