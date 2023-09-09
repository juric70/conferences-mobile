import 'dart:convert';

import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/network/autentification_service.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/network/timetable_service.dart';
import 'package:conferences_mobile/pages/conferences/add_categories_to_conference_day.dart';
import 'package:flutter/material.dart';

class TimetableCreateScreen extends StatefulWidget {
  final int conferenceDayId;
  final int conferenceId;

  const TimetableCreateScreen(
      {super.key, required this.conferenceDayId, required this.conferenceId});

  @override
  State<TimetableCreateScreen> createState() => _TimetableCreateScreenState();
}

class _TimetableCreateScreenState extends State<TimetableCreateScreen> {
  bool isCreatorOfConference = false;
  UserModel? user;
  bool isLoading = false;
  final TextEditingController _starttimeController = TextEditingController();
  final TextEditingController _endtimeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _conferenceRoomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _availableSeatsController = TextEditingController();
  final TextEditingController _tutorController = TextEditingController();
  String? _startingTimeError,
      _endingTimeError,
      _titleEerror,
      _addressError,
      _conferenceRoomError,
      _descriptionError,
      _availableSeatsError,
      _tutorError;

  @override
  void initState() {
    super.initState();
    _checkIsAutor();
  }

  Future<int> _createTimetable() async {
    try {
      final response = {
        'start_time': _starttimeController.text,
        'end_time': _endtimeController.text,
        'title': _titleController.text,
        'address': _addressController.text,
        'conference_room': _conferenceRoomController.text,
        'description': _descriptionController.text,
        'available_seats': int.parse(_availableSeatsController.text),
        'conference_day_id': widget.conferenceDayId,
        'user_id':
            await AuthentificationService.getUserByEmail(_tutorController.text),
      };
      final jsonData = jsonEncode(response);
      String result = await TimetableService.createTimeTable(jsonData);
      if (result == '200') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Timetable created successfully!'),
            backgroundColor: Color(0xff4a23b2),
          ),
        );
        return 1;
      } else {
        final Map<String, dynamic> errorData = jsonDecode(result);
        setState(() {
          _startingTimeError = errorData['start_time'] != null
              ? errorData['start_time'][0].toString()
              : '';
          _endingTimeError = errorData['end_time'] != null
              ? errorData['end_time'][0].toString()
              : '';
          _titleEerror = errorData['title'] != null
              ? errorData['title'][0].toString()
              : '';
          _addressError = errorData['address'] != null
              ? errorData['address'][0].toString()
              : '';
          _conferenceRoomError = errorData['conference_room'] != null
              ? errorData['conference_room'][0].toString()
              : '';
          _descriptionError = errorData['description'] != null
              ? errorData['description'][0].toString()
              : '';
          _availableSeatsError = errorData['available_seats'] != null
              ? errorData['available_seats'][0].toString()
              : '';
          _tutorError = errorData['user_id'] != null
              ? errorData['user_id'][0].toString()
              : '';
        });
        return 0;
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  Future<void> _checkIsAutor() async {
    await Future.delayed(Duration.zero);
    user = await AuthModel().LoggedInUser();

    int creatorId =
        await ConferenceServise.getIdOfCreatorOfConference(widget.conferenceId);

    if (user!.id == creatorId) {
      setState(() {
        isCreatorOfConference = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'You must be creator so edit conference and its days and timetables.'),
          backgroundColor: Color(0xffbe2b61),
        ),
      );
      Navigator.of(context).pushNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCreatorOfConference == false) {
      return Scaffold(
        appBar: CustomAppBar(
          onDrawerIconPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyDrawer(
                  onDrawerIconPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            );
          },
          onBackIconPressed: () {
            Navigator.of(context).maybePop();
          },
          showBackIcon: true,
        ),
        body: const Stack(
          children: [
            BackgroundScrollView(),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            onDrawerIconPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MyDrawer(
                    onDrawerIconPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              );
            },
            onBackIconPressed: () {
              Navigator.pop(context);
            },
            showBackIcon: false,
          ),
          body: Stack(
            children: [
              const BackgroundScrollView(),
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Create timetable!'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: _starttimeController,
                            decoration: InputDecoration(
                              labelText: '  Starting time    (12:00)',
                              errorText: _startingTimeError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: _endtimeController,
                            decoration: InputDecoration(
                              labelText: 'Ending time     (12:00)',
                              errorText: _endingTimeError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              errorText: _titleEerror,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              errorText: _addressError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: _conferenceRoomController,
                            decoration: InputDecoration(
                              labelText: 'Conference room',
                              errorText: _conferenceRoomError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              errorText: _descriptionError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: _availableSeatsController,
                            decoration: InputDecoration(
                              labelText: 'Available seats',
                              errorText: _availableSeatsError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: _tutorController,
                            decoration: InputDecoration(
                              labelText: 'Tutors email',
                              errorText: _tutorError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SizedBox(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffbe2b61),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Color(0xffbb2a5f),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () async {
                                  int res = await _createTimetable();
                                  if (res == 1) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return TimetableCreateScreen(
                                            conferenceDayId:
                                                widget.conferenceDayId,
                                            conferenceId: widget.conferenceId,
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Create more timetables!',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SizedBox(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffbe2b61),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Color(0xffbb2a5f),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () async {
                                  int res = await _createTimetable();
                                  if (res == 1) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddCategoryToConferenceDay(
                                          conferenceId: widget.conferenceId,
                                          conferenceDayId:
                                              widget.conferenceDayId,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Next step - add categories!',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
