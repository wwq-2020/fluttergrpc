import 'dart:async';

class Buffer<T> {
  Duration period;
  void Function(List<T>) onReceive;
  Buffer({this.period, this.onReceive});
  List<T> _cur = <T>[];
  Timer _timer;
  void start() {
    _timer = Timer.periodic(period, onTimerTrigged);
  }
  add(T item){
    _cur.add(item);
  }


  onTimerTrigged(Timer timer) {
    if (_cur.length!=0){
      var toSend = _cur;
      _cur = <T>[];
      onReceive(toSend);
    }

  }
}
