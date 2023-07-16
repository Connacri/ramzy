// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dart_date/dart_date.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ProfilePage extends StatefulWidget {
//   final DocumentSnapshot<Object?> data;
//   final int daysRemaining;
//
//   const ProfilePage({
//     Key? key,
//     required this.data,
//     required this.daysRemaining,
//   }) : super(key: key);
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   List<String> WeekDays = ['sam', 'dim', 'lun', 'mar', 'mer', 'jeu', 'ven'];
//
//   @override
//   Widget build(BuildContext context) {
//     // final user = UserPreferences.myUser;
//     final List daysList = widget.data['days'];
//
//     return Scaffold(
//       appBar: buildAppBar(context),
//       body: ListView(
//         physics: BouncingScrollPhysics(),
//         children: [
//           ProfileWidget(
//             imagePath: widget.data['photoUrl'], //user.imagePath,
//             onClicked: () async {},
//           ),
//           const SizedBox(height: 24),
//           buildName(
//             widget.data['name'],
//             widget.data['phone'],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                   icon: Icon(
//                     Icons.call,
//                     color: Colors.green,
//                   ),
//                   onPressed: () async {
//                     final Uri launchUrlR =
//                         Uri(scheme: 'Tel', path: '+213${widget.data['phone']}');
//                     if (await canLaunchUrl(launchUrlR)) {
//                       await launchUrl(launchUrlR);
//                     } else {
//                       print('This Call Cant execute');
//                     }
//                   }),
//               IconButton(
//                 onPressed: () async {
//                   // Navigator.of(context).push(MaterialPageRoute(
//                   //   builder: (context) => SubscriptionAddScreen(
//                   //     athlete_id: widget.data.id,
//                   //   ),
//                   // ));
//                 },
//                 icon: Icon(
//                   Icons.add,
//                   color: Colors.blue,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           Center(child: buildUpgradeButton()),
//           const SizedBox(height: 24),
//           NumbersWidget(
//             daysRemaining: widget.daysRemaining,
//             data: widget.data,
//           ),
//           const SizedBox(height: 48),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               height: 50,
//               child: ListView.builder(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   // physics: NeverScrollableScrollPhysics(),
//                   itemCount: daysList.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       child: Container(
//                         width: MediaQuery.of(context).size.width / 9,
//                         child: Center(
//                           child: Text(
//                             WeekDays[index % 7].toString().toUpperCase(),
//                             style: TextStyle(
//                                 fontWeight:
//                                     daysList[index] ? FontWeight.w500 : null),
//                           ),
//                         ),
//                       ),
//                       color: daysList[index]
//                           ? Colors.lightBlueAccent
//                           : Colors.grey,
//                     );
//                   }),
//             ),
//           ),
//           buildAbout(widget.data),
//         ],
//       ),
//     );
//   }
//
//   Widget buildName(name, phone) => Column(
//         children: [
//           Text(
//             name,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             '+213 ${phone}',
//             style: TextStyle(color: Colors.grey),
//           )
//         ],
//       );
//
//   Widget buildUpgradeButton() => ButtonWidget(
//         text: 'Upgrade To PRO',
//         onClicked: () {},
//       );
//
//   Widget buildAbout(data) {
//     final birthday = data['birthday'];
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 48),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'About',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                   //birthday.toString(),
//                   'Né(e) Le ${DateTime.parse(birthday.toDate().toString()).format('dd MMMM yyyy', 'fr_FR')}'
//                   '  Age : ${((DateTime.now().difference(birthday.toDate()).inDays) / 365).toInt()}',
//                   textAlign: TextAlign.start,
//                   style: const TextStyle(
//                     color: Colors.black54,
//                     fontWeight: FontWeight.normal,
//                     fontSize: 14,
//                   )),
//               Text(
//                   //birthday.toString(),
//                   'Groupe: ${data['groupe']}'
//                   '  Grade : ${data['grade']}',
//                   textAlign: TextAlign.start,
//                   style: const TextStyle(
//                     color: Colors.black54,
//                     fontWeight: FontWeight.normal,
//                     fontSize: 14,
//                   )),
//               Text(
//                   //birthday.toString(),
//                   'Inscription ${DateTime.parse(data['createdAt'].toDate().toString()).format('dd MMMM yyyy', 'fr_FR')}',
//                   textAlign: TextAlign.start,
//                   style: const TextStyle(
//                     color: Colors.black54,
//                     fontWeight: FontWeight.normal,
//                     fontSize: 14,
//                   )),
//               Text(data['program'],
//                   textAlign: TextAlign.start,
//                   style: const TextStyle(
//                     color: Colors.black54,
//                     fontWeight: FontWeight.normal,
//                     fontSize: 14,
//                   ))
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// AppBar buildAppBar(BuildContext context) {
//   final icon = CupertinoIcons.moon_stars;
//
//   return AppBar(
//     leading: BackButton(),
//     backgroundColor: Colors.transparent,
//     elevation: 0,
//     actions: [
//       IconButton(
//         icon: Icon(icon),
//         onPressed: () {},
//       ),
//     ],
//   );
// }
//
// class ButtonWidget extends StatelessWidget {
//   final String text;
//   final VoidCallback onClicked;
//
//   const ButtonWidget({
//     Key? key,
//     required this.text,
//     required this.onClicked,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           shape: StadiumBorder(),
//           onPrimary: Colors.black54,
//           padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//         ),
//         child: Text(text),
//         onPressed: onClicked,
//       );
// }
//
// class NumbersWidget extends StatelessWidget {
//   final DocumentSnapshot<Object?> data;
//   final int daysRemaining;
//
//   NumbersWidget({
//     Key? key,
//     required this.data,
//     required this.daysRemaining,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final birthday = data['birthday'];
//
//     final int age =
//         ((DateTime.now().difference(birthday.toDate()).inDays) / 365).toInt();
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         buildButton(context, age.toString(), 'Age'),
//         buildDivider(),
//         buildButton(context, data['poids'].toString(), 'Poids'),
//         buildDivider(),
//         buildButton(context, daysRemaining.toString(), 'Jours Restant'),
//       ],
//     );
//   }
//
//   Widget buildDivider() => Container(
//         height: 24,
//         child: VerticalDivider(),
//       );
//
//   Widget buildButton(BuildContext context, String value, String text) =>
//       MaterialButton(
//         padding: EdgeInsets.symmetric(vertical: 4),
//         onPressed: () {},
//         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               value,
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//             ),
//             SizedBox(height: 2),
//             Text(
//               text,
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       );
// }
//
// class ProfileWidget extends StatelessWidget {
//   final String imagePath;
//   final VoidCallback onClicked;
//
//   const ProfileWidget({
//     Key? key,
//     required this.imagePath,
//     required this.onClicked,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final color = Theme.of(context).colorScheme.primary;
//
//     return Center(
//       child: Stack(
//         children: [
//           buildImage(),
//           Positioned(
//             bottom: 0,
//             right: 4,
//             child: buildEditIcon(color),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildImage() {
//     final image = NetworkImage(imagePath);
//
//     return ClipOval(
//       child: Material(
//         color: Colors.transparent,
//         child: Ink.image(
//           image: image,
//           fit: BoxFit.cover,
//           width: 128,
//           height: 128,
//           child: InkWell(onTap: onClicked),
//         ),
//       ),
//     );
//   }
//
//   Widget buildEditIcon(Color color) => buildCircle(
//         color: Colors.white,
//         all: 3,
//         child: buildCircle(
//           color: color,
//           all: 8,
//           child: Icon(
//             Icons.edit,
//             color: Colors.white,
//             size: 20,
//           ),
//         ),
//       );
//
//   Widget buildCircle({
//     required Widget child,
//     required double all,
//     required Color color,
//   }) =>
//       ClipOval(
//         child: Container(
//           padding: EdgeInsets.all(all),
//           color: color,
//           child: child,
//         ),
//       );
// }
//
// class User {
//   final String imagePath;
//   final String name;
//   final String email;
//   final String about;
//   final bool isDarkMode;
//
//   const User({
//     required this.imagePath,
//     required this.name,
//     required this.email,
//     required this.about,
//     required this.isDarkMode,
//   });
// }
