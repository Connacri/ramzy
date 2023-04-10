import 'dart:ui';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:math';

class gantt_chart extends StatelessWidget {
  const gantt_chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GranttChartScreen();
  }
}

class GranttChartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GranttChartScreenState();
  }
}

class GranttChartScreenState extends State<GranttChartScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  DateTime fromDate = DateTime(2023, 1, 1);
  DateTime toDate = DateTime(2023, 12, 31);

  late List<Room> roomsInChart;
  late List<UserGantt> UsersGanttInChart;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        duration: Duration(microseconds: 2000), vsync: this);
    animationController.forward();

    UsersGanttInChart = UsersGantt;
    roomsInChart = rooms;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rent Managment'),
      ),
      body:
          // GestureDetector(
          //   onTap: () {
          //     FocusScope.of(context).requestFocus(new FocusNode());
          //   },
          //   child:
          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: GanttChart(
              animationController: animationController,
              fromDate: fromDate,
              toDate: toDate,
              data: UsersGanttInChart,
              roomsInChart: roomsInChart,
            ),
          ),
        ],
      ),

      //),
    );
  }
}

class GanttChart extends StatelessWidget {
  final AnimationController animationController;
  final DateTime fromDate;
  final DateTime toDate;
  final List<UserGantt> data;
  final List<Room> roomsInChart;

  late int NombreJours;
  late int viewRange;

  int viewRangeToFitScreen = 6;
  late Animation<double> width;

  GanttChart({
    required this.animationController,
    required this.fromDate,
    required this.toDate,
    required this.data,
    required this.roomsInChart,
  }) {
    viewRange = 365; //365;

    //viewdays = differenceInDays(fromDate, toDate);
    //calculateNumberOfMonthsBetween(fromDate, toDate);
    final NombreJours = toDate.difference(fromDate).inDays;
    print('NombreJours : $NombreJours');
  }

  Color randomColorGenerator() {
    var r = new Random();
    return Color.fromRGBO(
        r.nextInt(256), r.nextInt(256), r.nextInt(256), 1 /*0.75*/);
  }

  // int calculateNumberOfMonthsBetween(DateTime from, DateTime to) {
  //   return to.month - from.month + 12 * (to.year - from.year) + 1;
  // }

  /*************************************************************************************************/
  final itemKey = GlobalKey();
  Future scrollToItem() async {
    final context = itemKey.currentContext!;
    await Scrollable.ensureVisible(context);
  }
  /*************************************************************************************************/

  int calculateDistanceToLeftBorder(
      DateTime projectStartedAt, int beforeChartGant) {
    if (projectStartedAt.compareTo(fromDate) <= 0) {
      return 0;
    } else {
      // print('NombreJours : {$projectStartedAt}');
      return projectStartedAt.difference(fromDate).inDays - beforeChartGant;
    }
  }

  int calculateRemainingWidth(
      DateTime projectStartedAt, DateTime projectEndedAt) {
    int projectLength = projectEndedAt.difference(projectStartedAt).inDays;
    //calculateNumberOfMonthsBetween(projectStartedAt, projectEndedAt);

    if (projectStartedAt.compareTo(fromDate) >= 0 &&
        projectStartedAt.compareTo(toDate) <= 0) {
      if (projectLength <= viewRange)
        return projectLength;
      else
        return viewRange - projectStartedAt.difference(fromDate).inDays;
      //calculateNumberOfMonthsBetween(fromDate, projectStartedAt);
    } else if (projectStartedAt.isBefore(fromDate) &&
        projectEndedAt.isBefore(fromDate)) {
      return 0;
    } else if (projectStartedAt.isBefore(fromDate) &&
        projectEndedAt.isBefore(toDate)) {
      return projectLength - projectStartedAt.difference(fromDate).inDays;
      //calculateNumberOfMonthsBetween(projectStartedAt, fromDate);
    } else if (projectStartedAt.isBefore(fromDate) &&
        projectEndedAt.isAfter(toDate)) {
      return viewRange;
    }
    return 0;
  }

  List<Widget> buildChartBars(
      List<UserGantt> data, double chartViewWidth, Color color) {
    List<Widget> chartBars = [];

    for (int i = 0; i < data.length; i++) {
      var remainingWidth =
          calculateRemainingWidth(data[i].startTime, data[i].endTime);
      if (remainingWidth > 0) {
        chartBars.add(Container(
          decoration: BoxDecoration(
              color: color.withAlpha(100),
              borderRadius: BorderRadius.circular(10.0)),
          height: 25.0,
          width: remainingWidth * chartViewWidth / viewRangeToFitScreen,
          margin: EdgeInsets.only(
              left: (calculateDistanceToLeftBorder(data[i].startTime, 0) *
                  chartViewWidth /
                  viewRangeToFitScreen),
              top: i == 0 ? 4.0 : 2.0,
              bottom: i == data.length - 1 ? 4.0 : 2.0),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 4.0),
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
    // DateTime tempDatem = fromDate;
    // DateTime tempDatey = fromDate;

    headerItems.add(Container(
      width: chartViewWidth / viewRangeToFitScreen,
      color: Colors.lightBlue,
      child: Center(
        child: new Text(
          'Rooms'.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    ));

    for (int i = 0; i < viewRange; i++) {
      Jiffy.locale('fr');
      headerItems.add(Column(
        children: [
          Container(
              child: Text(
            Jiffy(tempDate).format("yyyy").toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16.0,
            ),
          )),
          Container(
              child: Text(
            Jiffy(tempDate).format("MMMM").toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 12.0,
            ),
          )),
          Container(
            width: chartViewWidth / viewRangeToFitScreen,
            child: new Text(
              tempDate.day.toString()
              // +
              // '/' +
              // tempDate.month.toString() +
              // '/' +
              // tempDate.year.toString()
              ,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
              child: Text(
            Jiffy(tempDate).format("EEE").toUpperCase(),
            /********EEEE AFFICHE JOUR COMPLETE SAMEDI AU LIEU DE SAM.*/
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 10.0,
            ),
          )),
        ],
      ));
      tempDate = tempDate.nextDay;
      // tempDatem = tempDate.nextMonth;
      // tempDatey = tempDate.nextYear;
    }

    return Container(
      color: Colors.blueAccent,
      //padding: EdgeInsets.all(8),
      height: 100, //25.0,
      //color: color.withAlpha(100),
      child: ListView.builder(
          physics: PageScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: headerItems.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              tempDate = tempDate;
              // return headerItems.first;
            } else {
              tempDate = tempDate.nextDay;
            }
            ;
            return headerItems[index];
          }),
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

  Widget buildChartForEachUser(
      List<UserGantt> userData, double chartViewWidth, Room roomA) {
    //************************************
    Color color = //Colors.teal;
        randomColorGenerator();
    var chartBars = buildChartBars(userData, chartViewWidth, color);

    return Container(
      height: 35.0, // chartBars.length * 29.0 + 25.0 + 4.0,
      child: Row(
        children: [
          ListView(
            shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
            //new ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Stack(fit: StackFit.loose, children: <Widget>[
                buildGrid(chartViewWidth),
                //buildHeader(chartViewWidth, color),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: chartViewWidth / viewRangeToFitScreen,
                          height: 23.0, //chartBars.length * 29.0 + 4.0,
                          //color: color.withAlpha(100),
                          child: Center(
                            child: new RotatedBox(
                              quarterTurns:
                                  chartBars.length * 29.0 + 4.0 > 50 ? 0 : 0,
                              child: new Text(
                                roomA.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )),
                      Stack(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: chartBars,
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> buildChartContent(double chartViewWidth) {
    //************************** un seul bloc de user ou 01 avec ses charts
    List<Widget> chartContent = [];

    roomsInChart.forEach((room) {
      List<UserGantt> roomsOfUser = [];

      roomsOfUser = UsersGantt.where(
          (UserGantt) => UserGantt.rooms.indexOf(room.id) != -1).toList();

      //if (roomsOfUser.length > 0) {
      chartContent
          .add(buildChartForEachUser(roomsOfUser, chartViewWidth, room));
      //}
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
    // Create a ScrollController
    final ScrollController _scrollController = ScrollController();

// Calculate the index of today's date
    final int todayIndex = DateTime.now().difference(fromDate).inDays;
    print('today index $todayIndex');

    return GestureDetector(
      onDoubleTap: () {
        _scrollController.jumpTo(
          todayIndex * (chartViewWidth / viewRangeToFitScreen),
        );

        print('onouletap');
      },
      child: Container(
        child: MediaQuery.removePadding(
          child: ListView(shrinkWrap: true, children: [
            // CalendarTimeline(
            //   initialDate: fromDate,
            //   firstDate: fromDate,
            //   lastDate: toDate,
            //   onDateSelected: (DateTime) {},
            //   showYears: true,
            //   leftMargin: 60,
            //   monthColor: Colors.blueGrey,
            //   dayColor: Colors.teal[200],
            //   activeDayColor: Colors.white,
            //   activeBackgroundDayColor: Colors.redAccent[100],
            //   dotsColor: Color(0xFF333A47),
            //   selectableDayPredicate: (date) => date.day != 23,
            //   locale:
            //       'en_ISO', //********************************************en_ISO
            // ),
            // SizedBox(
            //   height: 10.0,
            // ),
            // ElevatedButton(
            //   onPressed: () => null,
            //   child: Text('Select date'),
            // ),
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  buildHeader(chartViewWidth, Colors.indigo),
                  Column(
                    children: buildChartContent(chartViewWidth),
                  ),
                ],
              ),
            ),
          ]),
          removeTop: true,
          context: context,
        ),
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
  Room(id: 101, name: '101'),
  Room(id: 102, name: '102'),
  Room(id: 103, name: '103'),
  Room(id: 104, name: '104'),
  Room(id: 105, name: '105'),
  Room(id: 106, name: '106'),
  Room(id: 107, name: '107'),
  Room(id: 108, name: '108'),
  Room(id: 109, name: '109'),
  Room(id: 110, name: '110'),
  Room(id: 111, name: '111'),
  Room(id: 112, name: '112'),
  Room(id: 113, name: '114'),
];

class Room {
  int id;
  String name;

  Room({required this.id, required this.name});
}

var UsersGantt = [
  UserGantt(
      id: 1,
      name: 'Ramzi',
      startTime: DateTime(2023, 1, 1),
      endTime: DateTime(2023, 1, 3),
      rooms: [1, 2, 4, 7]),
  UserGantt(
      id: 2,
      name: 'Danil',
      startTime: DateTime(2023, 1, 4),
      endTime: DateTime(2023, 1, 5),
      rooms: [
        1,
        4,
        2,
      ]),
  UserGantt(
      id: 3,
      name: 'Selyane',
      startTime: DateTime(2023, 1, 14),
      endTime: DateTime(2023, 1, 25),
      rooms: [1, 7, 106]),
  UserGantt(
      id: 4,
      name: 'Samir',
      startTime: DateTime(2023, 2, 28),
      endTime: DateTime(2023, 3, 3),
      rooms: [1, 2, 5, 13]),
  UserGantt(
      id: 5,
      name: 'Poutin',
      startTime: DateTime(2023, 1, 2),
      endTime: DateTime(2023, 1, 6),
      rooms: [
        3,
      ]),
  UserGantt(
      id: 6,
      name: 'KimJan',
      startTime: DateTime(2023, 1, 1),
      endTime: DateTime(2023, 1, 7),
      rooms: [5]),
  UserGantt(
      id: 7,
      name: 'Bruclee',
      startTime: DateTime(2023, 3, 31),
      endTime: DateTime(2023, 4, 1),
      rooms: [
        7,
      ]),
  UserGantt(
      id: 8,
      name: 'Cordoba',
      startTime: DateTime(2023, 4, 6),
      endTime: DateTime(2023, 4, 12),
      rooms: [2, 11]),
  UserGantt(
      id: 9,
      name: 'Kalite',
      startTime: DateTime(2023, 4, 5),
      endTime: DateTime(2023, 4, 09),
      rooms: [3, 12]),
  UserGantt(
      id: 10,
      name: 'Vinga',
      startTime: DateTime(2023, 3, 27),
      endTime: DateTime(2023, 4, 2),
      rooms: [4, 6]),
];

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
