import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class profile_edit extends StatefulWidget {
  profile_edit({Key? key, required this.userDoc}) : super(key: key);

  final userDoc;

  @override
  State<profile_edit> createState() => _profile_editState();
}

class _profile_editState extends State<profile_edit> {
  final GlobalKey<FormState> _formProfileEditKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _telContactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userRef = FirebaseFirestore.instance.collection('Users');
  }

  final documentReference = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  double val = 0;
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');

  ValueNotifier<GeoPoint?> notifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    _displayNameController.text = widget.userDoc['displayName'];
    _telContactController.text = widget.userDoc['phone'].toString();

    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: widget.userDoc['avatar'],
                  fit: BoxFit.cover,
                  height: 30,
                  width: 30,
                )),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  widget.userDoc['displayName'].toString().toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontFamily: 'oswald', fontSize: 22),
                ),
              ),
              const Text(
                ' Va Publier Une Annonce',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: 'oswald', fontSize: 17),
              ),
            ],
          )),
      body: Column(
        children: <Widget>[
          Form(
            key: _formProfileEditKey,
            child: Column(
              children: [
                TextFormField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  keyboardType: TextInputType.text,
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black38),
                    fillColor: Colors.white,
                    hintText: 'Name',
                    border: InputBorder.none,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  validator: (value) => value != null && value.length < 3
                      ? 'Entrer min 3 characteres.'
                      : null,
                ),
                SizedBox(
                  height: 10,
                ),
                IntlPhoneField(
                  controller: _telContactController,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black38),
                    fillColor: Colors.white,
                    hintText: '660 00 00 00',
                    border: InputBorder.none,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  invalidNumberMessage:
                      'Entrer Que Ooreddo ou Djezzy ou Mobilis',
                  // disableLengthCheck: true,
                  onSaved: (phone) {
                    // save phone.number and phone.countryCode in Firestore
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Entrer Ton Numero de Tel';
                    } else {
                      // validate against your regex pattern
                      RegExp regex = new RegExp(r'^[678][0-9]{8}$');
                      if (!regex.hasMatch(value.number)) {
                        return 'Entrer Que Ooreddo ou Djezzy ou Mobilis';
                      }
                      return null;
                    }
                  },

                  showDropdownIcon: false,
                  initialCountryCode: 'DZ',

                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                  flagsButtonMargin: EdgeInsets.zero,
                  flagsButtonPadding: const EdgeInsets.only(left: 15),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                // Mettez à jour le document avec les nouvelles données
                documentReference.update({
                  'displayName': _displayNameController.text,
                  'phone': int.parse(_telContactController.text),
                }).then((value) {
                  print("Document mis à jour avec succès");
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print("Erreur lors de la mise à jour du document: $error");
                });
              },
              child: Text('Sauvegarder'))
        ],
      ),
    );
  }
}
