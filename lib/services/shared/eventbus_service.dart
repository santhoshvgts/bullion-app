import 'package:event_taxi/event_taxi.dart';

class EventBusService {
  Future<void> configure() async {
    _eventBus = EventTaxiImpl.singleton();
  }

  EventTaxiImpl? _eventBus;

  EventTaxiImpl get eventBus {
    return _eventBus ?? EventTaxiImpl.singleton();
  }
}

class DisableLockTimeoutEvent implements Event {
  final bool disable;

  DisableLockTimeoutEvent({this.disable = false});
}

class RefreshDataEvent implements Event {
  String name;
  RefreshDataEvent(this.name);
}
