import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class ouedkniss extends StatefulWidget {
  const ouedkniss({Key? key}) : super(key: key);

  @override
  State<ouedkniss> createState() => _ouedknissState();
}

class _ouedknissState extends State<ouedkniss> {
  List<String> title = [];
  List<String> urlImages = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWebsiteData();
  }

  Future getWebsiteData() async {
    final urlc = Uri.parse('https://www.echoroukonline.com/');
    final responsec = await http.get(urlc);
    dom.Document html = dom.Document.html(responsec.body);

    final titlesc = html
        .querySelectorAll('h3 > a>span')
        .map((element) => element.innerHtml.trim())
        .toList();

    // final url =
    //     Uri.parse('https://www.ouedkniss.com/electronique/1?regionIds=oran-31');
    // final response = await http.get(url);
    // dom.Document html = dom.Document.html(response.body);
    // final List<String> titles = html
    //     .querySelectorAll(
    //         'div.d-flex.flex-column.o-announ-card-column > a > div.mx-2')
    //     .map((e) => e.innerHtml.trim())
    //     .toList();
    print('titles.length');
    print(titlesc.length);
    setState(() {
      this.title = titlesc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akhbar ${title.length}'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(12),
        itemCount: title.length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 12,
          );
        },
        itemBuilder: (context, index) {
          final titre = title[index];
          return ListTile(
              title: Text(
            titre,
            textAlign: TextAlign.end,
          ));
        },
      ),
    );
  }
}
