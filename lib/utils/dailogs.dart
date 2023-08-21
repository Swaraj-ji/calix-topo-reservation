import 'package:flutter/material.dart';
import 'package:topo_reservation_sys/data/test_bed_info.dart';
import 'package:topo_reservation_sys/utils/checking_refresh.dart';

class LockAlertDailog extends StatelessWidget {
  final String topoName, currentUser, pastUser, tym;
  const LockAlertDailog(
      {required this.topoName,
      required this.currentUser,
      required this.pastUser,
      required this.tym});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Already Allocated'),
      content: Text(
          "Device: $topoName\nCurrent User: $currentUser\nPast User: $pastUser\nEnd time: $tym"),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class UnlockAlertDailog extends StatefulWidget {
  final String topoName;
  const UnlockAlertDailog({required this.topoName});

  @override
  State<UnlockAlertDailog> createState() => _UnlockAlertDailogState();
}

class _UnlockAlertDailogState extends State<UnlockAlertDailog> {
  TextEditingController _textFieldControllerName = TextEditingController();
  TextEditingController _textFieldControllerTime = TextEditingController();
  TextEditingController timeinput = TextEditingController();

  String name = "", reservationTime = "";
  @override
  void initState() {
    // TODO: implement initState
    timeinput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Fill the details to reserve'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (nameValue) {
              setState(() {
                name = nameValue;
                print(nameValue);
              });
            },
            controller: _textFieldControllerName,
            decoration: InputDecoration(hintText: "Enter Name"),
          ),
          TextField(
            onChanged: (timeValue) {
              setState(() {
                reservationTime = timeValue;
                print(timeValue);
              });
            },
            controller: _textFieldControllerTime,
            decoration: InputDecoration(hintText: "Enter Time (min.)"),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            info[widget.topoName]!['locked'] = true;
            info[widget.topoName]!['current_user'] = name;
            DateTime curTime = DateTime.now();
            DateTime endTime =
                curTime.add(Duration(minutes: int.parse(reservationTime)));
            print(curTime);
            print(endTime);
            info[widget.topoName]!['ending_time'] = endTime;
            print(info[widget.topoName]!['ending_time']);
            print("$name, $reservationTime");
            CheckingRefresh.refresh();
            CheckingRefresh.rebuildAllChildren(NavigationService.navigatorKey.currentContext);
            Navigator.pop(context, 'Submit');
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
