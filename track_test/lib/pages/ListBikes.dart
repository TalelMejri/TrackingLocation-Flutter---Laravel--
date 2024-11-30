import 'package:flutter/material.dart';
import 'package:track_test/model/BikeModel.dart';
import 'package:track_test/pages/TrackBikes.dart';
import 'package:track_test/services/BikeServices.dart';

class ListBuses extends StatefulWidget {
  const ListBuses({super.key});

  @override
  State<ListBuses> createState() => _ListBusesState();
}

class _ListBusesState extends State<ListBuses> {
  List<BikeModel> buses = [];
  var loading = true;
  final BusService _busService = BusService();

  fetchBUses() async {
    List<BikeModel> buses_data = await _busService.getBikes();
    setState(() {
      buses = buses_data;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBUses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(
                child: Text(
              "Bikes",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
            backgroundColor: Colors.blueAccent),
        body: Container(
          margin: const EdgeInsets.only(top: 1, left: 1, right: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(6, 1, 95, 190),
                Color.fromARGB(-28, 0, 193, 243)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                )
              : buses.isEmpty
                  ? const Center(
                      child: Text("No buses Yet",
                          style: TextStyle(color: Colors.white, fontSize: 20)))
                  : ListView.builder(
                      itemCount: buses.length,
                      itemBuilder: (context, index) {
                        BikeModel _BikeModel = buses[index];
                        return Dismissible(
                          key: Key(_BikeModel.id.toString()),
                          background: Container(
                            color: Colors.cyan,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  content: Text(
                                      "Would you like to delete ${_BikeModel.name}?"),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: const Text("Delete",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey),
                                      child: const Text("Cancel",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) async {
                            setState(() {
                              buses.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Delete")));
                          },
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              trailing: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                TrackBus(bus: _BikeModel)));
                                  },
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  label: const Text("Check")),
                              title: Text(
                                "${_BikeModel.name}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                _BikeModel.id.toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ));
  }
}
