import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class BookingAAA extends StatefulWidget {
  @override
  _BookingAAAState createState() => _BookingAAAState();
}

class _BookingAAAState extends State<BookingAAA> {
  ScrollController _controller = ScrollController();
  List<DateTime> _dates = [];

  @override
  void initState() {
    super.initState();
    _generateDates();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      _generateDates();
    }
  }

  void _generateDates() {
    for (int i = 0; i < 20; i++) {
      _dates.add(DateTime.now().add(Duration(days: i)));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Date List'),
        ),
        body: CustomScrollView(
          shrinkWrap: true,
          slivers: <Widget>[
            // Correct: SliverList
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        controller: _controller,
                        itemCount: _dates.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              DateFormat.yMd().format(_dates[index]),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    controller: _controller,
                    itemCount: _dates.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          'date : ' + DateFormat.yMd().format(_dates[index]),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Correct: SliverToBoxAdapter
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                color: Colors.red,
              ),
            ),
          ],
        ));
  }
}
