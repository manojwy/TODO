import 'package:meta/meta.dart';

enum Priority { high, medium, low }

class Item {
//  1. title:TEXT
//  2. description: TEXT
//  3. longitude: TEXT
//  4. latitude: TEXT
//  5. start time: DateTime
//  6. end time: DateTime
//  7. priority: Priority

  static final idCol = "id";
  static final titleCol = "title";
  static final descriptionCol = "description";
  static final longitudeCol = "longitude";
  static final latitudeCol = "latitude";
  static final startTimeCol = "startTime";
  static final endTimeCol = "endTime";
  static final priorityCol = "priority";

  int id;
  String title;
  String description;
  String longitude;
  String latitude;
  DateTime startTime;
  DateTime endTime;
  Priority priority;

  Item(
      {@required this.title,
      this.description,
      this.longitude,
      this.latitude,
      @required this.startTime,
      this.endTime,
      this.priority});

  Item.from(Map<String, dynamic> map) {

    if (map[idCol] != null) {
      this.id = map[idCol];
    }

    this.title = '';
    if (map[titleCol] != null) {
      this.title = map[titleCol];
    }

    this.description = '';
    if (map[descriptionCol] != null) {
      this.description = map[descriptionCol];
    }

    this.longitude = '';
    if (map[longitudeCol] != null) {
      this.title = map[longitudeCol];
    }

    this.latitude = '';
    if (map[latitudeCol] != null) {
      this.title = map[latitudeCol];
    }

    var timestamp = map[startTimeCol];
    this.startTime =
        DateTime.fromMicrosecondsSinceEpoch(timestamp, isUtc: true);

    timestamp = map[endTimeCol];
    if (timestamp != null) {
      this.endTime = this.startTime;
    }

    this.priority = Priority.low;
    if (map[priorityCol] != null) {
      this.priority = map[priorityCol];
    }
  }
}
