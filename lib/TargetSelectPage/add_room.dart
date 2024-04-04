// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types, file_names, unused_import, avoid_print, non_constant_identifier_names, library_prefixes
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:map1/Home/home_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map1/Map/classes.dart' as MyClass;
import 'package:map1/Map/classes.dart';
import 'package:map1/Record/components/task_complete_card.dart';
import 'package:map1/TargetSelectPage/components/display_employee_assigned.dart';
import 'package:map1/TargetSelectPage/components/map_dialog.dart';
import 'package:map1/components/my_button.dart';

//  File to choose target location on map and add it to the realtime database

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  List<Marker> allMarkers = [];
  late DatabaseReference dbRef;
  late double lat;
  late double long;
  bool completed = false;
  List<Marker> myMarker = [];
  final roomLocation = TextEditingController();
  final roomName = TextEditingController();
  final tInfo = TextEditingController();

  static const CameraPosition _cecLocation =
      CameraPosition(target: LatLng(12.898799, 74.984734), zoom: 15);

  // ignore: unused_field
  late GoogleMapController _mapController;

  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  // Dropdown widget
  late MyClass.User selectedUser;
  late MyClass.User selectedAssign;

  bool IsEmployeeAssigned = false;

  bool MapTapped = false;
  // String selectedUser = "";
  // String selectedAssign = "";

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Rooms');

    selectedTime = TimeOfDay.now();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  handleTap(LatLng tappedPoint) {
    (tappedPoint);

    lat = tappedPoint.latitude;
    long = tappedPoint.longitude;

    setState(
      () {
        MapTapped = true;
        myMarker = [];
        myMarker.add(
          Marker(
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
            infoWindow:
                const InfoWindow(title: 'Target', snippet: 'Choose a target'),
            draggable: true,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextField(
                    controller: roomName,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Task name',
                      hintText: 'Enter Task name',
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextField(
                    controller: roomLocation,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Task location',
                      hintText: 'Enter Task location',
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextField(
                    controller: tInfo,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Information',
                      hintText: 'Enter target information',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.0),
                  child: Row(
                    children: [
                      Text(
                        'Deadline time : ${selectedTime.format(context)}',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(width: 6),
                      IconButton(
                        onPressed: () => _selectTime(context),
                        icon: Icon(
                            Icons.access_time), // Use your desired icon here
                        tooltip: 'Select Deadline',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.0),
                  child: Row(
                    children: [
                      Text(
                        'Deadline date : ${DateFormat.yMMMd().format(selectedDate)}',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(width: 6),
                      IconButton(
                        focusColor: Colors.blue.withOpacity(0.7),
                        onPressed: () => _selectDate(context),
                        icon: Icon(
                            Icons.calendar_month), // Use your desired icon here
                        tooltip: 'Select Deadline',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Tap on the map below to choose a target location',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                AddRoomMap(context),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }

                      List<DropdownMenuItem<MyClass.User>> items = [];

                      final users = snapshot.data!.docs;

                      for (var user in users) {
                        final userData = user.data() as Map<String, dynamic>;
                        final username = userData['username'] as String;
                        final userObject = MyClass.User(
                          name: userData['name'] as String,
                          username: username,
                          userUid: user.id,
                          location: MyClass.Location(
                            lat: Random().nextDouble() * 180 - 90,
                            lng: Random().nextDouble() * 360 - 180,
                          ),
                        );
                        items.add(
                          DropdownMenuItem<MyClass.User>(
                            value: userObject,
                            child: Text(username),
                          ),
                        );
                      }

                      return DropdownButton<MyClass.User>(
                        items: items,
                        onChanged: (selectedItem) {
                          setState(() {
                            selectedUser = selectedItem!;
                            selectedAssign = selectedUser;
                            IsEmployeeAssigned = true;
                          });
                          print('Selected MyClass.User: $selectedUser');
                          print(
                              'SelectedUser uid is : ${selectedUser.userUid}');
                          print(
                              'SelectedAssign uid is : ${selectedAssign.userUid}');
                          print(
                              'SelectedAssign name is : ${selectedAssign.username}');
                          print('selectedAssign: $selectedAssign');
                        },
                        hint: Text('Select Assign'),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  child: MapTapped
                      ? Container(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            // height: 600,
                            width: MediaQuery.of(context).size.width * 0.8,

                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 192, 187, 238),
                                  Color.fromARGB(255, 221, 219, 224)
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(10),
                                  scrollDirection: Axis.vertical,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.266,
                                    // height: 500,
                                    child: StreamBuilder<List<User>>(
                                      stream: FirestoreService
                                          .userCollectionStream(),
                                      builder: (context, userSnapshot) {
                                        if (userSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (userSnapshot.hasError) {
                                          return Text(
                                              'Error: ${userSnapshot.error}');
                                        } else {
                                          return ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            padding: const EdgeInsets.all(9),
                                            itemCount:
                                                userSnapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              final user =
                                                  userSnapshot.data![index];

                                              // if (user.assignedToEmployee) {
                                              //   return Text('username');
                                              // } else {
                                              return Container();
                                              // }
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                ),
                const SizedBox(
                  height: 15,
                ),
                DisplayEmployeeAssigned(
                    IsEmployeeAssigned: IsEmployeeAssigned,
                    selectedAssign: selectedAssign),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: MyButton(
                    onPressed: () {
                      Map<dynamic, dynamic> roomsMap = {
                        'roomName': roomName.text,
                        'roomLocation': roomLocation.text,
                        'latitude': lat,
                        'longitude': long,
                        'completed': false,
                        'targetInfo': tInfo.text,
                      };

                      dbRef.push().set(roomsMap);

                      DateTime dateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      print("FIRESTORE to store TARGETLOC");
                      try {
                        FirebaseFirestore.instance
                            .collection('TargetLoc')
                            .doc()
                            .set(
                          {
                            'roomName': roomName.text,
                            'roomLocation': roomLocation.text,
                            'completed': false,
                            'targetInfo': tInfo.text,
                            'location': {
                              'lat': lat,
                              'lng': long,
                            },
                            'deadlineTime': dateTime,
                            'deadlineCompletedAt': dateTime.toString(),
                            // 'assignedToEmployee': selectedAssign,
                            'assignedToEmployee': selectedUser.username,
                          },
                        );
                        print('Data stored successfully');
                      } catch (e) {
                        print('Error storing data: $e');
                      }

                      Navigator.pop(context);
                    },
                    buttonIcon: Icons.map,
                    buttonText: 'Create Task',
                  ),
                ),
                const SizedBox(
                  height: 55,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox AddRoomMap(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.52,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onVerticalDragStart: (start) {},
        child: GoogleMap(
          initialCameraPosition: _cecLocation,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: Set.from(myMarker),
          onTap: handleTap,
          mapType: MapType.normal,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
          onMapCreated: (GoogleMapController Addcontroller) {
            _mapController = Addcontroller;
          },
        ),
      ),
    );
  }
}
