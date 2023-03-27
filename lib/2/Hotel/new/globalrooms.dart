import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Room {
  final String id;
  final String name;
  final List<Reservation> reservations;

  Room({
    required this.id,
    required this.name,
    required this.reservations,
  });
}

class Reservation {
  final DateTime start;
  final DateTime end;

  Reservation({required this.start, required this.end});
}

class RoomTimeline extends StatelessWidget {
  final Room room;
  final List<DateTime> dates;

  const RoomTimeline({required this.room, required this.dates});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(room.name),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              // final reservation = room.reservations.firstWhere(
              //   (reservation) =>
              //       reservation.start.isBefore(date) &&
              //       reservation.end.isAfter(date),
              //   orElse: () => null,
              // );
              final reservation = room.reservations.firstWhere(
                (reservation) =>
                    reservation.start.isBefore(date) &&
                    reservation.end.isAfter(date),
                orElse: () => Reservation(start: date, end: date),
              );

              final isReserved = reservation != null;
              final isFirst = index == 0;
              final isLast = index == dates.length - 1;
              return Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Divider(
                        thickness: 2,
                        color: isReserved ? Colors.red : Colors.grey,
                      ),
                    ),
                    if (isFirst)
                      Positioned(
                        left: 0,
                        top: -16,
                        child: Text(
                          date.day.toString(),
                        ),
                      ),
                    if (isLast)
                      Positioned(
                        right: 0,
                        top: -16,
                        child: Text(
                          date.day.toString(),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class HotelAvailability extends StatefulWidget {
  @override
  _HotelAvailabilityState createState() => _HotelAvailabilityState();
}

class _HotelAvailabilityState extends State<HotelAvailability> {
  final List<DateTime> dates =
      List.generate(14, (index) => DateTime.now().add(Duration(days: index)));
  final List<Room> rooms = [
    Room(
      id: '1',
      name: 'Chambre 1',
      reservations: [
        Reservation(
          start: DateTime(2022, 03, 10),
          end: DateTime(2022, 03, 14),
        ),
        Reservation(
          start: DateTime(2022, 03, 20),
          end: DateTime(2022, 03, 23),
        ),
      ],
    ),
    Room(
      id: '2',
      name: 'Chambre 2',
      reservations: [
        Reservation(
          start: DateTime(2022, 03, 15),
          end: DateTime(2022, 03, 18),
        ),
        Reservation(
          start: DateTime(2022, 03, 22),
          end: DateTime(2022, 03, 24),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                return RoomListItem(
                  room: room,
                  dates: dates,
                );
              },
            ),
          ),
          Container(
            height: 100,
            child: CalendarTimeline(
              initialDate: DateTime.now().add(Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 14)),
              onDateSelected: (date) {
                print(date);
              },
              leftMargin: 20,
              monthColor: Colors.black87,
              dayColor: Colors.teal[200],
              dayNameColor: Color(0xFF333A47),
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.teal[300],
              dotsColor: Color(0xFF333A47),
              selectableDayPredicate: (date) => date.isAfter(DateTime.now()),
              //locale: 'fr_FR',
            ),
          ),
        ],
      ),
    );
  }
}

class RoomListItem extends StatelessWidget {
  final Room room;
  final List<DateTime> dates;

  const RoomListItem({
    required this.room,
    required this.dates,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              room.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final date = dates[index];
                final reservations = room.reservations.where(
                  (r) =>
                      r.start.isBefore(date) ||
                      r.start == date && r.end.isAfter(date) ||
                      r.end == date,
                );

                final isAvailable = reservations.isEmpty;
                return Container(
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.day.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 20,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: isAvailable
                            ? null
                            : Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: _getFlex(room, date),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4 - _getFlex(room, date),
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getFlex(Room room, DateTime date) {
    final reservations = room.reservations.where(
      (r) =>
          r.start.isBefore(date) ||
          r.start == date && r.end.isAfter(date) ||
          r.end == date,
    );

    final isAvailable = reservations.isEmpty;
    if (isAvailable) {
      return 4;
    } else {
      final reservation = reservations.first;
      final duration = reservation.end.difference(reservation.start);
      final days = duration.inDays + 1;
      final startDay = date.difference(reservation.start).inDays;

      if (startDay == 0) {
        return days;
      } else if (startDay == days - 1) {
        return days;
      } else {
        return 1;
      }
    }
  }
}
