import 'dart:convert';

import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/conference_day.dart';
import 'package:conferences_mobile/network/conference_day_service.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/pages/conferences/conference_day_detail_for_creator.dart';
import 'package:flutter/material.dart';

class ConferenceDayEditScreen extends StatefulWidget {
  final int conferenceDayId;
  final int conferenceId;
  const ConferenceDayEditScreen(
      {super.key, required this.conferenceDayId, required this.conferenceId});

  @override
  State<ConferenceDayEditScreen> createState() =>
      _ConferenceDayEditScreenState();
}

class _ConferenceDayEditScreenState extends State<ConferenceDayEditScreen> {
  bool isCreatorOfConference = false;
  bool isLoading = false;
  UserModel? user;
  TextEditingController priceContoller = TextEditingController();
  late ConferenceDay _conferenceDay;
  String? priceError;
  @override
  void initState() {
    super.initState();
    _checkIsAutor();
    _getConferenceDayDetails(widget.conferenceDayId);
  }

  void _getConferenceDayDetails(int id) {
    ConferenceDayService.getConferenceDayDetail(id).then((conferenceDay) {
      setState(() {
        _conferenceDay = conferenceDay;
        isLoading = false;
        priceContoller.text = _conferenceDay.price.toString();
      });
    });
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
          content: Text('You must be creator so edit conference day.'),
          backgroundColor: Color(0xffbe2b61),
        ),
      );
      Navigator.of(context).pushNamed('/');
    }
  }

  void _editConferenceDay() async {
    try {
      int price = int.parse(priceContoller.text);

      final response = {
        'price': price,
      };
      final jsonData = jsonEncode(response);
      String result = await ConferenceDayService.editConferenceDay(
          jsonData, _conferenceDay.id);
      if (result == '200') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conference day edited successfully!'),
            backgroundColor: Color(0xff4a23b2),
          ),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ConferencesDayShowDetails(
                conferenceDayId: _conferenceDay.id,
                conferenceId: widget.conferenceId,
              );
            },
          ),
        );
      } else {
        final Map<String, dynamic> errorData = jsonDecode(result);
        setState(() {
          priceError = errorData['price'] != null
              ? errorData['price'][0].toString()
              : '';
        });
      }
    } catch (e) {
      throw Future.error(e);
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
                            'Edit conference days!'.toUpperCase(),
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
                              controller: priceContoller,
                              decoration: InputDecoration(
                                labelText: 'Price',
                                errorText: priceError,
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffbe2b61), width: 1.5),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffbe2b61),
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
                                  color: Color(0xffbe2b61), fontSize: 18.0),
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
                                _editConferenceDay();
                              },
                              child: const Text(
                                'Edit!',
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
