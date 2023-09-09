import 'dart:convert';

import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/conferences.dart';
import 'package:conferences_mobile/network/conference_day_service.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/pages/conferences/timetable_create.dart';
import 'package:flutter/material.dart';

class ConferencesDayCreateScreen extends StatefulWidget {
  final int conferenceId;
  const ConferencesDayCreateScreen({super.key, required this.conferenceId});

  @override
  State<ConferencesDayCreateScreen> createState() =>
      _ConferencesDayCreateScreenState();
}

class _ConferencesDayCreateScreenState
    extends State<ConferencesDayCreateScreen> {
  bool isCreatorOfConference = false;
  bool isLoading = false;
  UserModel? user;
  TextEditingController dayNumberContoller = TextEditingController();
  TextEditingController priceContoller = TextEditingController();
  late Conference _conference;
  String? dayNumberError, priceError;
  @override
  void initState() {
    super.initState();
    _checkIsAutor();
    _getConferenceDetails(widget.conferenceId);
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
          content: Text('You must be creator so edit conference.'),
          backgroundColor: Color(0xffbe2b61),
        ),
      );
      Navigator.of(context).pushNamed('/');
    }
  }

  void _createConferenceDay() async {
    try {
      int dayNumber = int.parse(dayNumberContoller.text);
      int price = int.parse(priceContoller.text);
      DateTime date = DateTime.parse(_conference.starting_date);
      date = date.add(Duration(days: dayNumber - 1));
      String newDate = date.toString();

      final response = {
        'day_number': dayNumber,
        'date': newDate,
        'price': price,
        'conference_id': widget.conferenceId
      };
      final jsonData = jsonEncode(response);
      String result = await ConferenceDayService.createConferenceDay(jsonData);
      if (_isNumeric(result) && result != '-1') {
        int confDayId = jsonDecode(result);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conference day created successfully!'),
            backgroundColor: Color(0xff4a23b2),
          ),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return TimetableCreateScreen(
                conferenceDayId: confDayId,
                conferenceId: widget.conferenceId,
              );
            },
          ),
        );
      } else {
        final Map<String, dynamic> errorData = jsonDecode(result);
        setState(() {
          dayNumberError = errorData['day_number'] != null
              ? errorData['day_number'][0].toString()
              : '';
          priceError = errorData['price'] != null
              ? errorData['price'][0].toString()
              : '';
        });
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  bool _isNumeric(String str) {
    // ignore: unnecessary_null_comparison
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void _getConferenceDetails(int id) {
    ConferenceServise.getConferenceDetail(id).then((conference) {
      setState(() {
        _conference = conference;
      });
    });
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
          body: Stack(children: [
            const BackgroundScrollView(),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Center(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Create conference days!'.toUpperCase(),
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
                              controller: dayNumberContoller,
                              decoration: InputDecoration(
                                labelText: 'Day of conference',
                                errorText: dayNumberError,
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
                              controller: priceContoller,
                              decoration: InputDecoration(
                                labelText: 'price',
                                errorText: priceError,
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
                          padding: const EdgeInsets.all(6.0),
                          child: SizedBox(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffbe2b61),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Color(0xffbb2a5f),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                _createConferenceDay();
                              },
                              child: const Text(
                                'Next step - create timetable!',
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                  )
          ]),
        ),
      );
    }
  }
}
