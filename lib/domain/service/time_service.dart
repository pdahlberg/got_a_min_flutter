
class TimeService {

  DateTime now() => DateTime.now();

  int nowMillis() => now().millisecondsSinceEpoch;

  Stream<int> get heartbeat => Stream<int>.periodic(const Duration(seconds: 5), (x) => x);

}
