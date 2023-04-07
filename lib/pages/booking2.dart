import 'dart:ui';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:math';
import 'package:date_utils/date_utils.dart' as DUtils;

class GranttChartScreen2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GranttChartScreen2State();
  }
}

class GranttChartScreen2State extends State<GranttChartScreen2>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  DateTime fromDate = DateTime(2023, 1, 1);
  DateTime toDate = DateTime(2024, 1, 1);

  late List<Room> roomsInChart;
  late List<UserGantt> UserGanttsInChart;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        duration: Duration(microseconds: 2000), vsync: this);
    animationController.forward();

    UserGanttsInChart = UsersGantt;
    roomsInChart = rooms;
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text('GANTT CHART'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GANTT CHART2 Hotel'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: GanttChart(
                animationController: animationController,
                fromDate: fromDate,
                toDate: toDate,
                data: UserGanttsInChart,
                roomsInChart: roomsInChart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GanttChart extends StatelessWidget {
  final AnimationController animationController;
  final DateTime fromDate;
  final DateTime toDate;
  final List<UserGantt> data;
  final List<Room> roomsInChart;

  int viewRange = 62;
  int viewRangeToFitScreen = 6;
  late Animation<double> width;

  GanttChart({
    required this.animationController,
    required this.fromDate,
    required this.toDate,
    required this.data,
    required this.roomsInChart,
  }) {
    //viewRange = calculateNumberOfMonthsBetween(fromDate, toDate);
  }

  Color randomColorGenerator() {
    var r = new Random();
    return Color.fromRGBO(r.nextInt(256), r.nextInt(256), r.nextInt(256), 0.75);
  }

  int calculateNumberOfMonthsBetween(DateTime from, DateTime to) {
    return to.month - from.month + 12 * (to.year - from.year) + 1;
  }

  int calculateDistanceToLeftBorder(DateTime UserGanttstartedAt) {
    if (UserGanttstartedAt.compareTo(fromDate) <= 0) {
      return 0;
    } else
      print('/////////////////////////////////////');

    print(calculateNumberOfMonthsBetween(fromDate, UserGanttstartedAt) - 1);

    return calculateNumberOfMonthsBetween(fromDate, UserGanttstartedAt) - 1;
  }

  int calculateRemainingWidth(
      DateTime UserGanttstartedAt, DateTime UserGanttEndedAt) {
    int UserGanttLength =
        calculateNumberOfMonthsBetween(UserGanttstartedAt, UserGanttEndedAt);
    if (UserGanttstartedAt.compareTo(fromDate) >= 0 &&
        UserGanttstartedAt.compareTo(toDate) <= 0) {
      if (UserGanttLength <= viewRange)
        return UserGanttLength;
      else
        return viewRange -
            calculateNumberOfMonthsBetween(fromDate, UserGanttstartedAt);
    } else if (UserGanttstartedAt.isBefore(fromDate) &&
        UserGanttEndedAt.isBefore(fromDate)) {
      return 0;
    } else if (UserGanttstartedAt.isBefore(fromDate) &&
        UserGanttEndedAt.isBefore(toDate)) {
      return UserGanttLength -
          calculateNumberOfMonthsBetween(UserGanttstartedAt, fromDate);
    } else if (UserGanttstartedAt.isBefore(fromDate) &&
        UserGanttEndedAt.isAfter(toDate)) {
      return viewRange;
    }
    return 0;
  }

  List<Widget> buildChartBars(
      List<UserGantt> data, double chartViewWidth, Color color) {
    List<Widget> chartBars = [];
    Color randomColor() {
      var r = new Random();
      return Color.fromRGBO(
          r.nextInt(56), r.nextInt(156), r.nextInt(256), 0.75);
    }

    for (int i = 0; i < data.length; i++) {
      var remainingWidth =
          calculateRemainingWidth(data[i].startTime, data[i].endTime);
      var calc = calculateDistanceToLeftBorder(data[i].startTime);
      var rest = calc - remainingWidth;
      print(data[i].name +
          '  Width : $remainingWidth' +
          '  Left : $calc' +
          ' Distance : $rest');
      // print('Width : $remainingWidth');
      // print('Left : $calc');
      // print(calc - remainingWidth);
      if (remainingWidth > 0) {
        chartBars.add(Container(
          decoration: BoxDecoration(
              color: randomColor().withAlpha(100),
              borderRadius: BorderRadius.circular(10.0)),
          height: 25.0,
          width: remainingWidth * chartViewWidth / viewRangeToFitScreen,
          margin: EdgeInsets.only(
            left: calc * chartViewWidth / viewRangeToFitScreen,
            top: i == 0 ? 4.0 : 2.0,
            bottom: i == data.length - 1 ? 4.0 : 2.0,
          ),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              data[i].name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10.0),
            ),
          ),
        ));
      }
    }

    return chartBars;
  }

  Widget buildHeader(double chartViewWidth, Color color) {
    List<Widget> headerItems = [];

    DateTime tempDate = fromDate;

    headerItems.add(Container(
      width: chartViewWidth / viewRangeToFitScreen,
      child: new Text(
        'NAME',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10.0,
        ),
      ),
    ));

    for (int i = 0; i < viewRange; i++) {
      headerItems.add(Container(
        width: chartViewWidth / viewRangeToFitScreen,
        child: new Text(
          tempDate.month.toString() + '/' + tempDate.year.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.0,
          ),
        ),
      ));
      tempDate = DUtils.DateUtils.nextMonth(tempDate);
    }

    return Container(
      height: 25.0,
      color: color.withAlpha(100),
      child: Row(
        children: headerItems,
      ),
    );
  }

  Widget buildGrid(double chartViewWidth) {
    List<Widget> gridColumns = [];

    for (int i = 0; i <= viewRange; i++) {
      gridColumns.add(Container(
        decoration: BoxDecoration(
            border: Border(
                right:
                    BorderSide(color: Colors.grey.withAlpha(100), width: 1.0))),
        width: chartViewWidth / viewRangeToFitScreen,
        //height: 300.0,
      ));
    }

    return Row(
      children: gridColumns,
    );
  }

  Widget buildChartForEachRoom(
      List<UserGantt> RoomData, double chartViewWidth, Room Room) {
    Color color = randomColorGenerator();
    var chartBars = buildChartBars(RoomData, chartViewWidth, color);
    return Container(
      height: //29.0 + 25.0 + 4.0,//***************************************************** hauteur room
          chartBars.length * 29.0 + 25.0 + 4.0,
      child: ListView(
        shrinkWrap: true,
        //physics: NeverScrollableScrollPhysics(), //new ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Stack(fit: StackFit.loose, children: <Widget>[
            buildGrid(chartViewWidth),
            buildHeader(chartViewWidth, color),
            Container(
                margin: EdgeInsets.only(top: 25.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: chartViewWidth / viewRangeToFitScreen,
                                height: 29.0, //chartBars.length * 29.0 + 4.0,
                                color: color.withAlpha(100),
                                child: Center(
                                  child: new RotatedBox(
                                    quarterTurns:
                                        chartBars.length * 29.0 + 4.0 > 50
                                            ? 0
                                            : 0,
                                    child: new Text(
                                      'Room ' + Room.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )),
                            Stack(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: chartBars,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ]),
        ],
      ),
    );
  }

  List<Widget> buildChartContent(double chartViewWidth) {
    List<Widget> chartContent = [];

    roomsInChart.forEach((Room) {
      List<UserGantt> UserGanttsOfRoom = [];

      UserGanttsOfRoom = UsersGantt.where(
          (UserGantt) => UserGantt.rooms.indexOf(Room.id) != -1).toList();

      if (UserGanttsOfRoom.length > 0) {
        chartContent
            .add(buildChartForEachRoom(UserGanttsOfRoom, chartViewWidth, Room));
      }
    });

    return chartContent;
  }

  @override
  Widget build(BuildContext context) {
    var chartViewWidth = MediaQuery.of(context).size.width;
    var screenOrientation = MediaQuery.of(context).orientation;

    screenOrientation == Orientation.landscape
        ? viewRangeToFitScreen = 12
        : viewRangeToFitScreen = 6;

    return Container(
      child: MediaQuery.removePadding(
        child: ListView(children: buildChartContent(chartViewWidth)),
        removeTop: true,
        context: context,
      ),
    );
  }
}

var rooms = [
  Room(id: 1, name: '01'),
  Room(id: 2, name: '02'),
  Room(id: 3, name: '03'),
  Room(id: 4, name: '04'),
  Room(id: 5, name: '05'),
  Room(id: 6, name: '06'),
  Room(id: 7, name: '07'),
  Room(id: 8, name: '08'),
  Room(id: 9, name: '09'),
  Room(id: 10, name: '10'),
  Room(id: 11, name: '11'),
  Room(id: 12, name: '12'),
  Room(id: 13, name: '14'),
];

var UsersGantt = [
  UserGantt(
      id: 1,
      name: 'Basetax janvier',
      startTime: DateTime(2023, 1, 1),
      endTime: DateTime(2023, 2, 2),
      rooms: [1, 3, 5, 7]),
  UserGantt(
      id: 2,
      name: '2_Basetax mars',
      startTime: DateTime(2023, 3, 3),
      endTime: DateTime(2023, 4, 4),
      rooms: [1, 2, 4]),

  UserGantt(
      id: 3,
      name: 'Uber juillet',
      startTime: DateTime(2023, 7, 1),
      endTime: DateTime(2023, 8, 1),
      rooms: [1, 2, 4, 5, 7]),
  UserGantt(
      id: 4,
      name: 'Grab september',
      startTime: DateTime(2023, 9, 1),
      endTime: DateTime(2023, 10, 1),
      rooms: [1, 4, 3, 6, 8]),
  UserGantt(
      id: 5,
      name: 'GO-JEK november',
      startTime: DateTime(2023, 11, 1),
      endTime: DateTime(2023, 12, 1),
      rooms: [4, 2, 3, 9]),
  // UserGantt(
  //     id: 6,
  //     name: 'Lyft',
  //     startTime: DateTime(2023, 4, 1),
  //     endTime: DateTime(2023, 7, 1),
  //     rooms: [4, 2, 3, 10]),
  // UserGantt(
  //     id: 7,
  //     name: 'San Jose',
  //     startTime: DateTime(2023, 5, 1),
  //     endTime: DateTime(2023, 12, 1),
  //     rooms: [1, 2, 4]),
];

class Room {
  int id;
  String name;

  Room({required this.id, required this.name});
}

class UserGantt {
  int id;
  String name;
  DateTime startTime;
  DateTime endTime;
  List<int> rooms;

  UserGantt(
      {required this.id,
      required this.name,
      required this.startTime,
      required this.endTime,
      required this.rooms});
}
