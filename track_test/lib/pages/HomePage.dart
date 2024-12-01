import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:track_test/model/MenuModel.dart';
import 'package:track_test/pages/ListBikes.dart';
import 'package:track_test/services/BikeServices.dart';
import 'package:track_test/widgets/buildDashboardCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectIndex = 0;

  void changeSelectedIndex(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  final BikeSrvice _bikeSrvice = BikeSrvice();
  MenuModel menu = new MenuModel(bikesReserved: 0, bikesNotReserved: 0);
  var loading = true;
  @override
  void initState() {
    super.initState();
    getMenu();
  }

  Future<void> getMenu() async {
    MenuModel bikes_menu = await _bikeSrvice.getMenuBikes();
    setState(() {
      menu = bikes_menu;
      loading = false;
    });
    print(menu);
  }

  @override
  void dispose() {
    super.dispose();
    getMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE2F0),
      bottomNavigationBar: CurvedNavigationBar(
        color: const Color(0xFF50586C),
        buttonBackgroundColor: const Color(0xFF50586C),
        backgroundColor: const Color(0xFFDCE2F0),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
        onTap: changeSelectedIndex,
        index: _selectIndex,
        items: const [
          Icon(Icons.dashboard, color: Colors.white, size: 30),
          Icon(Icons.pedal_bike_sharp, color: Colors.white, size: 30),
        ],
      ),
      body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _selectIndex == 0
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Image.asset(
                        'images/logo.png',
                        height: 250,
                        width: 250,
                      ),
                      const Center(
                        child: Text(
                          "Welcome to BikeGo",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            final cardColors = [
                              Colors.black,
                              Colors.indigo,
                            ];
                            final icons = [
                              Icons.lock,
                              Icons.lock_open,
                            ];
                            final titles = ["Reserved", "Not Reserved"];
                            final values = [
                              menu.bikesReserved,
                              menu.bikesNotReserved
                            ];
                            final subtitles = [
                              "BikeGo",
                              "BikeGo",
                            ];
                            return BuildDashboardCard(
                              color: cardColors[index],
                              icon: icons[index],
                              title: titles[index],
                              value: values[index].toString(),
                              subtitle: subtitles[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : const LisetBikes()),
    );
  }
}
