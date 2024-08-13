import 'package:fl_arena/const/boss_info.dart';
import 'package:fl_arena/const/enums_spawn.dart';
import 'package:fl_arena/provider/fb_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../storage/firebase_data.dart';

class DynamicButtonWidget extends StatelessWidget {
  final FirebaseData data;
  final VoidCallback onUpdate;
  final int selectedItem;

  const DynamicButtonWidget(
      {super.key,
      required this.data,
      required this.onUpdate,
      required this.selectedItem});

  @override
  Widget build(BuildContext context) {
    FbProvider provider = Provider.of<FbProvider>(context, listen: false);
    late SpawnLocalPositions point;
    //  = SpawnLocalPositions.defaultValue;
    Color pointColor = const Color.fromARGB(255, 12, 25, 207);
    try {
      point = SpawnLocalPositions.values
          .firstWhere((element) => element.keyName == data.pointId);
    } on Exception {
      // print(e.toString());
    }
    double remainTime =
        (data.rewpawnTime - DateTime.now().millisecondsSinceEpoch);
    //Remain less than 30 mins to minimal spawn
    if (remainTime < 1800000 && remainTime > 0) {
      pointColor = const Color.fromARGB(255, 242, 247, 0);
    }

    BossInfo boss =
        BossInfo.values.firstWhere((element) => element.name == data.eliteName);

    if (remainTime > 1800000 &&
        remainTime < data.rewpawnTime &&
        DateTime.now().millisecondsSinceEpoch < data.rewpawnTime) {
      pointColor = const Color.fromARGB(232, 245, 8, 8);
    } else if (remainTime < 0 &&
        data.rewpawnTime + (boss.delay * 2) >
            DateTime.now().millisecondsSinceEpoch) {
      pointColor = const Color.fromARGB(232, 178, 1, 248);
    }

    return Positioned(
      top: point.y,
      left: point.x,
      height: 20,
      width: 20,
      child: TextButton(
          style: ButtonStyle(
              backgroundColor: point.z == provider.selectedIndex
                  ? MaterialStateProperty.all(
                      const Color.fromARGB(255, 3, 245, 3))
                  : MaterialStateProperty.all(pointColor)),
          onPressed: onUpdate,
          child: const Text("")),
    );
  }
}
