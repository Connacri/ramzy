class Floor {
  int id;
  String floor;

  Floor({required this.id, required this.floor});
}

class Room {
  int id;
  String room;

  Room({required this.id, required this.room});
}

class UserBooker {
  int id;
  String name;
  DateTime startTime;
  DateTime endTime;
  List<int> participants;

  UserBooker(
      {required this.id,
      required this.name,
      required this.startTime,
      required this.endTime,
      required this.participants});
}
