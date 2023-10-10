import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/f_wallet/main.dart';
import 'package:ramzy/f_wallet/payment.dart';
import 'package:ramzy/f_wallet/qr_scanner.dart';
import 'package:ramzy/f_wallet/usersList.dart';
import 'package:ramzy/food2/MyListLotties.dart';
import 'package:intl/intl.dart' as intl;
import 'package:ramzy/pages/Profile.dart';
import 'package:screenshot/screenshot.dart';
import 'package:ticket_widget/ticket_widget.dart';

class HomeScreen extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    userDataProvider.fetchCurrentUserData();
    final currentUserDatas = userDataProvider.currentUserData;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MyDrawer(),
      // appBar: AppBar(
      //   title: Consumer<UserDataProvider>(
      //     builder: (context, userDataProvider, _) {
      //       final displayName = currentUserDatas['displayName'] ?? '';
      //       return Text(
      //         displayName
      //             .toString(), // Utilisation de ?? pour éviter une erreur si displayName est null
      //         overflow: TextOverflow.ellipsis,
      //         style: TextStyle(
      //           color: Colors.black,
      //           fontSize: 20,
      //           fontWeight: FontWeight.w600,
      //         ),
      //       );
      //     },
      //   ),
      // ),
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            snap: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(vertical: 0),
              centerTitle: true,
              background: Lottie.asset(
                'assets/lotties/autumn.json',
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(
                  0), // Ajustez la hauteur préférée en conséquence
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    20, 0, 20, 8), // Ajustez le padding selon vos préférences
                child: Row(
                  children: [
                    Consumer<UserDataProvider>(
                      builder: (context, userDataProvider, _) {
                        final currentUserData =
                            userDataProvider.currentUserData;
                        final avatar = currentUserData['avatar'];

                        if (avatar == null) {
                          return Icon(Icons.account_circle_rounded);
                        }
                        return InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Profile())),
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(avatar),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                        width: 10.0), // Espacement entre l'avatar et le titre
                    Expanded(
                      child: Consumer<UserDataProvider>(
                        builder: (context, userDataProvider, _) {
                          final currentUserData =
                              userDataProvider.currentUserData;
                          final displayName =
                              currentUserData['displayName'] ?? '';

                          return Text(
                            displayName.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: TotalCoinsWidget(),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Historique())),
              child: Container(
//                color: Colors.yellow,
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ajoutez l'animation Lottie en arrière-plan
                    Lottie.asset(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 300,
                      'assets/lotties/animation_lnekrur4.json', // Remplacez par le chemin de votre fichier d'animation Lottie
                      fit: BoxFit
                          .contain, // Ajustez le mode d'ajustement selon vos préférences
                    ),

                    FittedBox(
                      child: Container(
                        height: 200,
                        width: 150,
                        child: Consumer<UserDataProvider>(
                          builder: (context, userDataProvider, _) {
                            final coins = currentUserDatas['coins'];
                            final formattedCoins = intl.NumberFormat.currency(
                              locale: 'fr_FR',
                              symbol: 'DZD',
                              decimalDigits: 2,
                            ).format(coins ??
                                0); // Utilisation de ?? pour éviter une erreur si coins est null
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: FittedBox(
                                child: Text(
                                  formattedCoins,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                    // Contenu de la carte (texte, boutons, etc.) va au-dessus de l'animation Lottie
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => QrScanner()));
                          },
                          child: Lottie.asset(
                              'assets/lotties/animation_qr1.json',
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserListPageCoins()));
                          },
                          child: Lottie.asset(
                              'assets/lotties/animation_lneit2vo.json',
                              fit: BoxFit.cover)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<UserDataProvider>(
        builder: (context, userDataProvider, _) {
          final currentUserData = userDataProvider.currentUserData;

          // Vérifiez si le currentUserData est vide (non connecté)
          if (currentUserData.isEmpty) {
            return Center(
                child: FittedBox(child: Text("Utilisateur\nnon connecté")));
          }

          // Récupérez les informations nécessaires
          final email = currentUserData['email'];
          final coins = currentUserData['coins'];
          final userImageUrl = currentUserData['avatar'];
          final usertimeline = currentUserData['timeline'];
          final userName = currentUserData['displayName'];
          final id = currentUserData['id'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      userName.toUpperCase(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    accountEmail: Text(
                      email,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    currentAccountPicture: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(userImageUrl),
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          usertimeline,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 25),
                    child: Hero(
                      tag: 'qrCodeHero',
                      child: GestureDetector(
                        onTap: () {
                          // Naviguez vers une autre page où vous afficherez le code QR en utilisant le même tag
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => QRCodePage(
                                currentUserData: currentUserData,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          height: 120,
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PrettyQrView.data(
                                data: id,
                                decoration: PrettyQrDecoration(
                                  shape: PrettyQrSmoothSymbol(
                                      roundFactor: 0, color: Colors.black),
                                  image: PrettyQrDecorationImage(
                                    scale: 0.2,
                                    padding: EdgeInsets.all(50),
                                    image: CachedNetworkImageProvider(
                                        userImageUrl),
                                    position: PrettyQrDecorationImagePosition
                                        .embedded,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: InkWell(
                  // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => UserProfileWidget(),
                  // )),
                  child: Card(
                      color: Colors.teal,
                      child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: FittedBox(
                            child: Text(
                              intl.NumberFormat.currency(
                                locale: 'fr_FR',
                                symbol: 'DZD',
                                decimalDigits: 2,
                              ).format(coins),
                              //overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ))),
                ),
              ),
              // TotalCoinsWidget(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Hey, ' + userName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    'What flavor do you want today?'.capitalize(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text('ما هي النكهة التي تريدها اليوم؟',
                      style: GoogleFonts.cairo(
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  Icons.qr_code_2_sharp,
                  size: 35,
                ),
                title: Text("Payer"),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => QrScanner()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.send_sharp,
                  size: 35,
                ),
                title: Text("Virement"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserListPageCoins()));
                },
              ),
              ListTile(
                leading: Icon(
                  FontAwesomeIcons.alipay,
                  size: 35,
                ),
                title: Text('Mes Lotties'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LottieListPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  FontAwesomeIcons.chargingStation,
                  size: 35,
                ),
                title: Text("Recharger"),
                onTap: () {
                  // Afficher une boîte de dialogue avec un code QR
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        width: 300.0, // Largeur souhaitée
                        height: 200.0,
                        child: AlertDialog(
                          title: Center(child: Text('Mon Code QR')),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Center(
                                  child: PrettyQrView.data(
                                    data: id,
                                    decoration: PrettyQrDecoration(
                                      shape: PrettyQrSmoothSymbol(
                                          roundFactor: 0, color: Colors.black),
                                      image: PrettyQrDecorationImage(
                                        scale: 0.2,
                                        padding: EdgeInsets.all(50),
                                        image: CachedNetworkImageProvider(
                                            userImageUrl),
                                        position:
                                            PrettyQrDecorationImagePosition
                                                .embedded,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // actions: <Widget>[
                          //   Center(
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: TextButton(
                          //         onPressed: () {
                          //           Navigator.of(context).pop();
                          //         },
                          //         child: Text('Fermer'),
                          //       ),
                          //     ),
                          //   ),
                          // ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}

class QRCodePage extends StatelessWidget {
  final Map<String, dynamic> currentUserData;

  const QRCodePage({
    Key? key,
    required this.currentUserData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final email = currentUserData['email'];
    final coins = currentUserData['coins'];
    final userImageUrl = currentUserData['avatar'];
    final usertimeline = currentUserData['timeline'];
    final userName = currentUserData['displayName'];
    final id = currentUserData['id'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Code QR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: TicketWidget(
          width: 1000,
          height: 600,
          color: Theme.of(context).secondaryHeaderColor,
          isCornerRounded: true, // Coins arrondis
          // shadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.3),
          //     blurRadius: 5.0,
          //     offset: Offset(0, 2),
          //   ),
          // ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(userImageUrl),
                      ),
                      title: Text(userName.toString().toUpperCase()),
                      subtitle: Text(email.toString()),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Présentez Votre Code QR au Point de Vente Pour Recharge Rapide et Sécurisé CASH'
                        .capitalize(),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'قدّم رمز الاستجابة السريعة الخاص بك في نقطة البيع للشحن السريع والآمن نقدا',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      color: Colors.black45,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 40),
                    child: Hero(
                      tag:
                          'qrCodeHero', // Utilisez le même tag que dans le ListTile
                      child: PrettyQrView.data(
                        data: id,
                        decoration: PrettyQrDecoration(
                          shape: PrettyQrSmoothSymbol(
                            roundFactor: 0,
                            color: Colors.black,
                          ),
                          image: PrettyQrDecorationImage(
                            scale: 0.2,
                            padding: EdgeInsets.all(10),
                            image: CachedNetworkImageProvider(userImageUrl),
                            position: PrettyQrDecorationImagePosition.embedded,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Center(
                  //     child: FittedBox(
                  //   child: Text(
                  //     id.toUpperCase(),
                  //     style: TextStyle(fontSize: 15, color: Colors.white),
                  //   ),
                  // )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class listMove extends StatelessWidget {
  const listMove(
      {Key? key, required this.scrollController, required this.images})
      : super(key: key);
  final ScrollController scrollController;
  final List images;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(
                imageUrl: '',
                fit: BoxFit.cover,
                width: 150,
              ),
            ),
          );
        },
      ),
    );
  }
}
