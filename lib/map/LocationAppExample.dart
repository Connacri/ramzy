import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_location_picker/open_location_picker.dart' as open;

class LocationAppExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LocationAppExampleState();
}

class _LocationAppExampleState extends State<LocationAppExample> {
  ValueNotifier<GeoPoint?> notifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("search picker example"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder<GeoPoint?>(
              valueListenable: notifier,
              builder: (ctx, p, child) {
                return Center(
                  child: Text(
                    "${p?.toString() ?? ""}",
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    var p = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => SearchPage()));
                    if (p != null) {
                      notifier.value = p as GeoPoint;
                    }
                  },
                  child: Text("pick address"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var p = await showSimplePickerLocation(
                      context: context,
                      isDismissible: true,
                      title: "location picker",
                      textConfirmPicker: "pick",
                      initCurrentUserPosition: false,
                      initZoom: 17,
                      initPosition: GeoPoint(
                        latitude: 47.4358055,
                        longitude: 8.4737324,
                      ),
                      radius: 8.0,
                    );
                    if (p != null) {
                      notifier.value = p;
                    }
                  },
                  child: Text("show picker address"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController textEditingController = TextEditingController();
  late PickerMapController controller = PickerMapController(
    initMapWithUserPosition: true,
  );

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(textOnChanged);
  }

  void textOnChanged() {
    controller.setSearchableText(textEditingController.text);
  }

  @override
  void dispose() {
    textEditingController.removeListener(textOnChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPickerLocation(
        controller: controller,
        topWidgetPicker: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
          child: Column(
            children: [
              Row(
                children: [
                  // TextButton(
                  //   style: TextButton.styleFrom(),
                  //   onPressed: () => Navigator.of(context).pop(),
                  //   child: Icon(
                  //     Icons.arrow_back_ios,
                  //   ),
                  // ),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      onEditingComplete: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        suffix: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: textEditingController,
                          builder: (ctx, text, child) {
                            if (text.text.isNotEmpty) {
                              return child!;
                            }
                            return SizedBox.shrink();
                          },
                          child: InkWell(
                            focusNode: FocusNode(),
                            onTap: () {
                              textEditingController.clear();
                              controller.setSearchableText("");
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        focusColor: Colors.black,
                        filled: true,
                        hintText: "Rechercher Adresse",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: Colors.grey[300],
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TopSearchWidget()
            ],
          ),
        ),
        bottomWidgetPicker: Positioned(
          bottom: 70,
          right: 18,
          child: FloatingActionButton(
            onPressed: () async {
              GeoPoint p = await controller.selectAdvancedPositionPicker();
              Navigator.pop(context, p);
            },
            child: Icon(FontAwesomeIcons.telegram),
          ),
        ),
        pickerConfig: CustomPickerLocationConfig(
          advancedMarkerPicker: MarkerIcon(
            icon: Icon(
              FontAwesomeIcons.locationDot,
              size: 100,
              color: Colors.red,
            ),
          ),
          initZoom: 17,
        ),
      ),
    );
  }
}

class TopSearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopSearchWidgetState();
}

class _TopSearchWidgetState extends State<TopSearchWidget> {
  late PickerMapController controller;
  ValueNotifier<GeoPoint?> notifierGeoPoint = ValueNotifier(null);
  ValueNotifier<bool> notifierAutoCompletion = ValueNotifier(false);

  late StreamController<List<SearchInfo>> streamSuggestion = StreamController();
  late Future<List<SearchInfo>> _futureSuggestionAddress;
  String oldText = "";
  Timer? _timerToStartSuggestionReq;
  final Key streamKey = Key("streamAddressSug");

  @override
  void initState() {
    super.initState();
    controller = CustomPickerLocation.of(context);
    controller.searchableText.addListener(onSearchableTextChanged);
  }

  void onSearchableTextChanged() async {
    final v = controller.searchableText.value;
    if (v.length > 3 && oldText != v) {
      oldText = v;
      if (_timerToStartSuggestionReq != null &&
          _timerToStartSuggestionReq!.isActive) {
        _timerToStartSuggestionReq!.cancel();
      }
      _timerToStartSuggestionReq =
          Timer.periodic(Duration(seconds: 3), (timer) async {
        await suggestionProcessing(v);
        timer.cancel();
      });
    }
    if (v.isEmpty) {
      await reInitStream();
    }
  }

  Future reInitStream() async {
    notifierAutoCompletion.value = false;
    await streamSuggestion.close();
    setState(() {
      streamSuggestion = StreamController();
    });
  }

  Future<void> suggestionProcessing(String addr) async {
    notifierAutoCompletion.value = true;
    _futureSuggestionAddress = addressSuggestion(
      addr,
      limitInformation: 5,
    );
    _futureSuggestionAddress.then((value) {
      streamSuggestion.sink.add(value);
    });
  }

  @override
  void dispose() {
    controller.searchableText.removeListener(onSearchableTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifierAutoCompletion,
      builder: (ctx, isVisible, child) {
        return AnimatedContainer(
          duration: Duration(
            milliseconds: 500,
          ),
          height: isVisible ? MediaQuery.of(context).size.height / 4 : 0,
          child: Card(
            child: child!,
          ),
        );
      },
      child: StreamBuilder<List<SearchInfo>>(
        stream: streamSuggestion.stream,
        key: streamKey,
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemExtent: 50.0,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(
                    snap.data![index].address.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  onTap: () async {
                    /// go to location selected by address
                    controller.goToLocation(
                      snap.data![index].point!,
                    );

                    /// hide suggestion card
                    notifierAutoCompletion.value = false;
                    await reInitStream();
                    FocusScope.of(context).requestFocus(
                      new FocusNode(),
                    );
                  },
                );
              },
              itemCount: snap.data!.length,
            );
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return Card(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

class LocationResult {
  final double latitude;
  final double longitude;
  final double? bearing;
  final double? zoom;

  LocationResult({
    required this.latitude,
    required this.longitude,
    this.bearing,
    this.zoom,
  });
}
