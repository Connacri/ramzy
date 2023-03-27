import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class khra extends StatefulWidget {
  const khra({Key? key}) : super(key: key);

  @override
  _khraState createState() => _khraState();
}

class _khraState extends State<khra> {

  TextEditingController date_debut = TextEditingController();
  TextEditingController date_fin = TextEditingController();
  //text editing controller for text field

  @override
  void initState() {
    date_debut.text = ""; //set the initial value of text field
    date_fin.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const Text("DatePicker on TextField"),
          backgroundColor: Colors.redAccent, //background color of app bar
        ),
        body:ListView(
          children: [
            const SizedBox(height: 15),
            // Center(child: Text('${_dateinit.day}/${_dateinit.month}/${_dateinit.year}')),
            //Center(child: Text(_dateinit.toString())),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    Center(child: Text(date_debut.text)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    Center(child: Text(date_fin.text)),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed:  () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context, initialDate: DateTime.now(),
                            firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101)
                        );

                        if(pickedDate != null ){
                          print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            date_debut.text = formattedDate; //set output date to TextField value.
                          });
                        }else{
                          print("Date is not selected");
                        }
                      },
                      child: const Text('Date Début'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed:  () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context, initialDate: DateTime.now(),
                            firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101)
                        );

                        if(pickedDate != null ){
                          print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            date_fin.text = formattedDate; //set output date to TextField value.
                          });
                        }else{
                          print("Date is not selected");
                        }
                      },
                      child: const Text('Date Fin'),
                    ),
                  ),
                ),
              ],
            ),

          ],
        )
    );
  }
}



