import 'package:topo_reservation_sys/data/test_bed_info.dart';
import 'package:flutter/material.dart';

class NavigationService { 
  static GlobalKey<NavigatorState> navigatorKey = 
  GlobalKey<NavigatorState>();
}

class CheckingRefresh {
  static void refresh() {
    // Check for all locked cards if reservation is over or not.
    DateTime curTime = DateTime.now();
    info.forEach((key, value) {
      DateTime endTime = info[key]!['ending_time'];
      if (info[key]!['locked'] && curTime.isAfter(endTime)) {
        info[key]!['locked'] = false;
        info[key]!['past_user'] = info[key]!['current_user'];
      }
    });
  }
  static void rebuildAllChildren(BuildContext? context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }
}
