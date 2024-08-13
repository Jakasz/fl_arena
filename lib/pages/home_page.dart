import 'package:fl_arena/api/api.dart';
import 'package:fl_arena/const/boss_info.dart';
import 'package:fl_arena/const/enums_spawn.dart';
import 'package:fl_arena/model/ip_model.dart';
import 'package:fl_arena/provider/fb_provider.dart';
import 'package:fl_arena/storage/firebase_data.dart';
import 'package:fl_arena/widgets/dynamic_button.dart';
import 'package:flutter/material.dart';
import 'package:custom_zoom_widget/custom_zoom_widget.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'dart:convert';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  // Controllers
  Stream<DatabaseEvent> stream = const Stream.empty();
  late final FirebaseFirestore firestoreDB;

  final List<CountdownTimerController> _controllers = [];
  final ScrollController _controller = ScrollController();
  IpCallModel model = IpCallModel();
  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<FbProvider>(context, listen: false);
    updateFirebaseData(dataProvider);
    initIpdata();
    return Scaffold(
        backgroundColor: const Color.fromRGBO(1, 11, 19, 0.9),
        body: SafeArea(
          child: Consumer<FbProvider>(
              builder: (BuildContext context, FbProvider data, Widget? child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomZoomWidget(
                  child: SizedBox(
                    height: 960,
                    width: 1161,
                    child: Stack(
                      children: makeButtons(data),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 820,
                        width: 650,
                        child: ScrollbarTheme(
                          data: ScrollbarThemeData(
                            thickness: MaterialStateProperty.all(15),
                            thumbColor: MaterialStateProperty.all(Colors.amber),
                          ),
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1.35,
                                      crossAxisCount: 3),
                              controller: _controller,
                              itemCount: data.rtdb.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  child: SizedBox(
                                    child: Card(
                                      color: index == data.selectedIndex
                                          ? const Color.fromRGBO(
                                              170, 172, 10, 1)
                                          : const Color.fromARGB(
                                              255, 31, 56, 100),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Padding(
                                          //     padding:
                                          //         const EdgeInsets.only(top: 10),
                                          //     child: Text(
                                          //       data.rtdb[index].pointId,
                                          //       style: const TextStyle(
                                          //           fontSize: 11,
                                          //           fontWeight: FontWeight.bold,
                                          //           color: Colors.white),
                                          //     )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Center(
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  data.rtdb[index].pointName,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              )),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 10),
                                              child: Text(
                                                data.rtdb[index].eliteName,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              )),
                                          const Padding(
                                            padding: EdgeInsets.only(bottom: 5),
                                            child: Text(
                                              "Min respawn delay:",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: CountdownTimer(
                                              controller: _controllers[index],
                                              textStyle: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              endWidget: const Text(
                                                "NO BOSS INFO",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              endTime: convertTimeStampToDate(
                                                  data.rtdb[index].rewpawnTime),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTapDown: (details) {
                                    if (data.selectedIndex != index) {
                                      data.updateSelectedIndex(index);
                                    } else {
                                      data.updateSelectedIndex(-1);
                                    }
                                  },
                                );
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          height: 50,
                          width: 392,
                          child: ElevatedButton(
                            child: const Text("Set boss kill time"),
                            onPressed: () async {
                              if (dataProvider.selectedIndex == -1) {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      content: const Text(
                                          "Не вибрано жодної точки на мапі"),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("OK")),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        content: Text(
                                            "Підтвердити що боса вбили на ${dataProvider.rtdb[dataProvider.selectedIndex].pointName}?"),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancel")),
                                          TextButton(
                                            onPressed: () {
                                              try {
                                                // setDataTofirestore(
                                                //     dataProvider.selectedIndex,
                                                //     dataProvider);
                                                var ref = FirebaseDatabase
                                                    .instance
                                                    .ref(
                                                        'points/${dataProvider.rtdb[dataProvider.selectedIndex].pointId}');

                                                ref.update({
                                                  '"respawnTime"': (DateTime
                                                              .now()
                                                          .millisecondsSinceEpoch +
                                                      getRespawnTime(
                                                          dataProvider
                                                              .selectedIndex))
                                                });
                                              } on Exception catch (e) {
                                                print(e.toString());
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Send"),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ));
  }

  void scrollTo(FbProvider data) {
    final contentSize = _controller.position.viewportDimension +
        _controller.position.maxScrollExtent;
    final target = contentSize * data.selectedIndex / data.rtdb.length;
    _controller.position.animateTo(target,
        duration: const Duration(microseconds: 50),
        curve: Curves.fastOutSlowIn);
  }

  convertTimeStampToDate(double timestamp) {
    int milliseconds = (timestamp).toInt();
    // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    // DateFormat timeFormat = DateFormat('HH:mm:ss'); // 24-hour format

    return milliseconds;
  }

  updateFirebaseData(FbProvider provider) {
    stream = FirebaseDatabase.instance.ref('points').onValue;
    List<FirebaseData> rtdbData = [];

    ///inititalize firbase firestore
    firestoreDB = FirebaseFirestore.instance;

    DatabaseReference ref = FirebaseDatabase.instance.ref('points');
    ref.onValue.listen((DatabaseEvent event) {
      _controllers.clear();
      provider.cleanDB();
      final data = event.snapshot;
      try {
        if (data.exists) {
          for (var element in data.children) {
            final el =
                jsonDecode(element.value.toString()) as Map<String, dynamic>;
            var data = FirebaseData.fromRTDB(el);
            rtdbData.add(data);
          }
        }
      } finally {
        rtdbData.sort((a, b) => a.pointIndex.compareTo(b.pointIndex));
        provider.updateDB(rtdbData);
        createCountDownControllers(provider);
      }
    });
  }

  createCountDownControllers(FbProvider provider) async {
    // int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
    for (var element in provider.rtdb) {
      _controllers.add(CountdownTimerController(
          endTime: convertTimeStampToDate(element.rewpawnTime)));
    }
  }

  Future<IpCallModel> fetchApi(IpApiCall model) async {
    var data = await model.fetchIpData();
    return data;
  }

  // setDataTofirestore(int index, FbProvider provider) {
  //   DateTime now = DateTime.now();
  //   DateTime date = DateTime(
  //       now.year, now.month, now.day, now.hour, now.minute, now.second);

  //   var curTime = DateTime.now().millisecondsSinceEpoch + 10800000 / 1000;
  //   var point = SpawnLocalPositions.values
  //       .firstWhere((point) => point.keyName == provider.rtdb[index].pointId);

  //   firestoreDB
  //       .collection('points')
  //       .doc(point.keyName)
  //       .collection(curTime.toString())
  //       .doc(date.toString())
  //       .set({
  //     'killTime': curTime.toString(),
  //     'countryName': model.countryName,
  //     'city': model.cityName,
  //     'regionName': model.regionName ?? '',
  //     'continentCode': model.continentCode,
  //     'continent': model.continent,
  //     'ipAddress': model.ipAddress
  //   });
  // }

  List<Widget> makeButtons(FbProvider provider) {
    List<Widget> widgets = [];
    widgets.add(
      Positioned(
        top: 0,
        left: 0,
        child: SizedBox(
          height: 950,
          width: 1141,
          child: GestureDetector(
            child: Image.asset('assets/images/map_kildebat.png'),
            onTapDown: (details) {},
          ),
        ),
      ),
    );
    for (FirebaseData el in provider.rtdb) {
      widgets.add(DynamicButtonWidget(
        data: el,
        selectedItem: provider.selectedIndex,
        onUpdate: () {
          // setState(() {
          for (var element in provider.rtdb) {
            if (element.pointId == el.pointId) {
              var point = SpawnLocalPositions.values
                  .firstWhere((point) => point.keyName == el.pointId);
              provider.updateSelectedIndex(point.z);
              scrollTo(provider);
              break;
            }
          }
          // }
          // );
        },
      ));
    }
    return widgets;
  }

  void initIpdata() async {
    model = await fetchApi(IpApiCall());
  }

  num getRespawnTime(int selectedIndex) {
    var time = 0;

    SpawnLocalPositions bossType = SpawnLocalPositions.values
        .firstWhere((element) => element.z == selectedIndex);
    BossInfo boss = BossInfo.values
        .firstWhere((element) => element.name == bossType.bossType);
    time = boss.respawn - boss.delay;
    return time;
  }
}
