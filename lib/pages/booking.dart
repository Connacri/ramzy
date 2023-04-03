import 'dart:ui';
import 'package:jiffy/jiffy.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
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
  DateTime toDate = DateTime(2024, 1, 1);

  late List<Floor> usersInChart;
  late List<UserBooker> projectsInChart;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        duration: Duration(microseconds: 2000), vsync: this);
    animationController.forward();

    projectsInChart = userbookers;
    usersInChart = floors;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GANTT CHART Hotel'),
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
              data: projectsInChart,
              usersInChart: usersInChart,
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
  final List<UserBooker> data;
  final List<Floor> usersInChart;

  late int NombreJours;
  late int viewRange;

  int viewRangeToFitScreen = 6;
  late Animation<double> width;

  GanttChart({
    required this.animationController,
    required this.fromDate,
    required this.toDate,
    required this.data,
    required this.usersInChart,
  }) {
    viewRange = 365;

    //viewdays = differenceInDays(fromDate, toDate);
    //calculateNumberOfMonthsBetween(fromDate, toDate);
    final NombreJours = toDate.difference(fromDate).inDays;
    print(NombreJours);
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

  int calculateDistanceToLeftBorder(DateTime projectStartedAt) {
    if (projectStartedAt.compareTo(fromDate) <= 0) {
      return 0;
    } else
      return projectStartedAt.difference(fromDate).inDays; //-1;
    //calculateNumberOfMonthsBetween(fromDate, projectStartedAt) - 1;
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
      List<UserBooker> data, double chartViewWidth, Color color) {
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
              left: calculateDistanceToLeftBorder(data[i].startTime) *
                  chartViewWidth /
                  viewRangeToFitScreen,
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
      child: new Text(
        'Etage'.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Oswald',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16.0,
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
              fontFamily: 'Oswald',
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
              fontFamily: 'Oswald',
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

      child: ListView(
        // au debut elle a été simple Row et je les changer on listview
        physics: PageScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
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

  Widget buildChartForEachUser(
      List<UserBooker> userData, double chartViewWidth, Floor user) {
    Color color = //Colors.teal;
        randomColorGenerator();
    var chartBars = buildChartBars(userData, chartViewWidth, color);
    return Container(
      height: chartBars.length * 29.0 + 25.0 + 4.0,
      child: ListView(
        shrinkWrap: true,
        //physics: const NeverScrollableScrollPhysics(),
        //new ClampingScrollPhysics(),

        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Stack(fit: StackFit.loose, children: <Widget>[
            buildGrid(chartViewWidth),
            //buildHeader(chartViewWidth, color),
            Container(
                margin: EdgeInsets.only(top: 25.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: chartViewWidth / viewRangeToFitScreen,
                                height: chartBars.length * 29.0 + 4.0,
                                color: color.withAlpha(100),
                                child: Center(
                                  child: new RotatedBox(
                                    quarterTurns:
                                        chartBars.length * 29.0 + 4.0 > 50
                                            ? 0
                                            : 0,
                                    child: new Text(
                                      user.floor.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
    //************************** un seul bloc de user ou 01 avec ses charts
    List<Widget> chartContent = [];

    usersInChart.forEach((user) {
      List<UserBooker> projectsOfUser = [];

      projectsOfUser = userbookers
          .where((userBooker) => userBooker.participants.indexOf(user.id) != -1)
          .toList();

      if (projectsOfUser.length > 0) {
        chartContent
            .add(buildChartForEachUser(projectsOfUser, chartViewWidth, user));
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
        child: ListView(children: [
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
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () => null,
            child: Text('Select date'),
          ),
          SingleChildScrollView(
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
    );
  }
}

var floors = [
  Floor(id: 1, floor: '01'),
  Floor(id: 2, floor: '02'),
  Floor(id: 3, floor: '03'),
  Floor(id: 4, floor: '04'),
  Floor(id: 5, floor: '05'),
  Floor(id: 6, floor: '06'),
  Floor(id: 7, floor: '07'),
  Floor(id: 8, floor: '08'),
  Floor(id: 9, floor: '09'),
];

var rooms = [
  Room(id: 1, room: '01'),
  Room(id: 2, room: '02'),
  Room(id: 3, room: '03'),
  Room(id: 4, room: '04'),
  Room(id: 5, room: '05'),
  Room(id: 6, room: '06'),
  Room(id: 7, room: '07'),
  Room(id: 5, room: '08'),
  Room(id: 6, room: '09'),
  Room(id: 7, room: '10'),
  Room(id: 5, room: '11'),
  Room(id: 6, room: '12'),
  Room(id: 7, room: '14'),
];

var userbookers = [
  UserBooker(
    id: 1,
    name: 'Ramzi',
    startTime: DateTime(2023, 1, 2),
    endTime: DateTime(2023, 1, 5),
    participants: [1, 2, 4, 3, 7],
  ),
  UserBooker(
      id: 2,
      name: 'Danil',
      startTime: DateTime(2023, 1, 4),
      endTime: DateTime(2023, 1, 8),
      participants: [1, 4, 2, 3]),
  UserBooker(
      id: 3,
      name: 'Selyane',
      startTime: DateTime(2023, 1, 14),
      endTime: DateTime(2023, 1, 25),
      participants: [1, 2, 7, 3]),
  UserBooker(
      id: 4,
      name: 'Samir',
      startTime: DateTime(2023, 1, 30),
      endTime: DateTime(2023, 1, 3),
      participants: [1, 2, 5, 3]),
  UserBooker(
      id: 5,
      name: 'Poutin',
      startTime: DateTime(2023, 1, 28),
      endTime: DateTime(2023, 2, 2),
      participants: [1, 4, 2, 3]),
  UserBooker(
      id: 6,
      name: 'KimJan',
      startTime: DateTime(2023, 2, 26),
      endTime: DateTime(2023, 3, 7),
      participants: [1, 4, 2, 3, 5, 6, 7]),
  UserBooker(
      id: 7,
      name: 'Bruclee',
      startTime: DateTime(2023, 2, 31),
      endTime: DateTime(2023, 3, 1),
      participants: [1, 2, 3, 4]),
  UserBooker(
      id: 7,
      name: 'Cordoba',
      startTime: DateTime(2023, 1, 29),
      endTime: DateTime(2023, 2, 12),
      participants: [1, 2, 3, 5]),
  UserBooker(
      id: 7,
      name: 'Kalite',
      startTime: DateTime(2023, 1, 01),
      endTime: DateTime(2023, 1, 04),
      participants: [1, 2, 3, 4, 6]),
  UserBooker(
      id: 7,
      name: 'Vinga',
      startTime: DateTime(2023, 1, 27),
      endTime: DateTime(2023, 3, 2),
      participants: [1, 2, 3, 4, 7]),
];

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
