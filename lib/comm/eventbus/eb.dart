import 'package:event_bus/event_bus.dart';
import 'package:znote/comm/eventbus/event_note_changed.dart';

class EventBusHelper {
  static final EventBus _eventBus = EventBus();

  static void fire(dynamic event) {
    _eventBus.fire(event);
  }

  static onNoteChanged(void Function(EventNoteChanged event0)? onDate,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _eventBus.on<EventNoteChanged>().listen(onDate,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}
