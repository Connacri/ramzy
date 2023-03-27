import 'package:flutter/material.dart';

class dataTableTest extends StatefulWidget {
  const dataTableTest({Key? key}) : super(key: key);

  @override
  _dataTableTestState createState() => _dataTableTestState();
}

class _dataTableTestState extends State<dataTableTest> {
  late DateTime _selectedDate = DateTime.now().day as DateTime;
  late DateTime _selectedDate1 = DateTime.now().add(const Duration(days: 1));
  late DateTime _selectedDate2 = DateTime.now().add(const Duration(days: 2));
  late DateTime _selectedDate3 = DateTime.now().add(const Duration(days: 3));
  late DateTime _selectedDate4 = DateTime.now().add(const Duration(days: 4));
  late DateTime _selectedDate5 = DateTime.now().add(const Duration(days: 5));
  late DateTime _selectedDate6 = DateTime.now().add(const Duration(days: 6));

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now().add(const Duration(days: 0));
    _selectedDate1 = _selectedDate.add(const Duration(days: 1));
    _selectedDate2 = _selectedDate.add(const Duration(days: 2));
    _selectedDate3 = _selectedDate.add(const Duration(days: 3));
    _selectedDate4 = _selectedDate.add(const Duration(days: 4));
    _selectedDate5 = _selectedDate.add(const Duration(days: 5));
    _selectedDate6 = _selectedDate.add(const Duration(days: 6));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(_selectedDate1.month.toString() /*.toUpperCase()*/,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Oswald',
              )),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          rows: [
            DataRow(cells: [
              DataCell(_selectedDate == 'dateD'
                  ? const Text('Reserved')
                  : const Text('Available')),
              const DataCell(Text('Flutter Basics')),
              const DataCell(Text('David John')),
              const DataCell(Text('David John')),
              const DataCell(Text('David John')),
              const DataCell(Text('David John')),
              const DataCell(Text('David John')),
            ]),
            const DataRow(cells: [
              DataCell(Text('#101')),
              DataCell(Text('Dart Internals')),
              DataCell(Text('Alex Wick')),
              DataCell(Text('Alex Wick')),
              DataCell(Text('Alex Wick')),
              DataCell(Text('Alex Wick')),
              DataCell(Text('Alex Wick')),
            ])
          ],
          columns: [
            DataColumn(
              label: Text(_selectedDate.day.toString() /*.toUpperCase()*/,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    fontFamily: 'Oswald',
                  )),
            ),
            DataColumn(
              label: Text(_selectedDate1.day.toString() /*.toUpperCase()*/,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    fontFamily: 'Oswald',
                  )),
            ),
            DataColumn(
              label: Text(_selectedDate2.day.toString() /*.toUpperCase()*/,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    fontFamily: 'Oswald',
                  )),
            ),
            DataColumn(
              label: Text(_selectedDate3.day.toString() /*.toUpperCase()*/,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    fontFamily: 'Oswald',
                  )),
            ),
            DataColumn(
              label: Text(_selectedDate4.day.toString() /*.toUpperCase()*/,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    fontFamily: 'Oswald',
                  )),
            ),
            DataColumn(
              label: Text(_selectedDate5.day.toString() /*.toUpperCase()*/,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    fontFamily: 'Oswald',
                  )),
            ),
            DataColumn(
              label: Text(_selectedDate6.day.toString() /*.toUpperCase()*/,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    fontFamily: 'Oswald',
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
