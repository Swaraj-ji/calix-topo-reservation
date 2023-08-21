import 'package:flutter/material.dart';
import 'package:topo_reservation_sys/utils/checking_refresh.dart';
import 'package:topo_reservation_sys/utils/constants.dart';
import 'package:topo_reservation_sys/utils/dailogs.dart';
import 'package:topo_reservation_sys/data/test_bed_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade400,
          title: const Center(
            child: Text(
              "CVIL Static Topology Reservation System",
              style: kHeadingStyle,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey.shade400,
          child: const Icon(
            Icons.refresh_outlined,
            size: 40,
            color: Colors.black,
          ),
          onPressed: () {
            CheckingRefresh.refresh();
            CheckingRefresh.rebuildAllChildren(context);
            print("Floating button pressed");
          },
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  topoName: 'E9-2_1',
                ),
                Card(
                  topoName: 'E9-2_2',
                ),
                Card(
                  topoName: 'E9-2_3',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  topoName: 'ASM',
                ),
                Card(
                  topoName: 'E3-2',
                ),
              ],
            ),
          ],
        ));
  }
}

class Card extends StatefulWidget {
  // topoName= eg: E9-2_1, E9-2_2, E9-2_3, ASM, E3-2
  // testBedName= eg: Avatar_VZ, Avatar_CF, Avatar_ROW, Darkknight, hanuman
  final String topoName;
  const Card({required this.topoName});

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String lockImg = 'assets/images/lock.png';
    String unlockImg = 'assets/images/unlock.png';
    bool isLock = info[widget.topoName]!['locked'];
    String testBedName = info[widget.topoName]!['Testbed_name'].toString();
    String currentUser = info[widget.topoName]!['current_user'].toString();
    String pastUser = info[widget.topoName]!['past_user'].toString();
    DateTime endTime = info[widget.topoName]!['ending_time'];
    return InkWell(
      onTap: () {
        if (isLock) {
          showDialog(
            context: context,
            builder: (BuildContext context) => LockAlertDailog(
              topoName: widget.topoName,
              currentUser: currentUser,
              pastUser: pastUser,
              tym: endTime.toString(),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => UnlockAlertDailog(
              topoName: widget.topoName,
            ),
          );
        }
        print("Clicked the ${widget.topoName}");
      },
      child: Container(
        height: screenHeight * 0.3,
        width: screenWidth * 0.2,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer),
          ],
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage("assets/images/internet.jpg"),
            fit: BoxFit.cover,
          ),
          // color: Color(0xFF8de0df),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: isLock ? AssetImage(lockImg) : AssetImage(unlockImg),
                height: screenHeight * 0.1,
                width: screenWidth * 0.1,
              ),
              Text(
                testBedName,
                style: kCardHeadingStyle,
              ),
              Text(
                isLock
                    ? "Ending Time: " + "${endTime.hour}:" + "${endTime.minute}"
                    : "𝘊𝘭𝘪𝘤𝘬 𝘛𝘰 𝘙𝘦𝘴𝘦𝘳𝘷𝘦",
                style: isLock ? kCardDetailsStyle : kCLickToReservwStyle,
              ),
              Text(
                isLock
                    ? "Current User: " + currentUser
                    : "Past User: " + pastUser,
                style: kCardDetailsStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
