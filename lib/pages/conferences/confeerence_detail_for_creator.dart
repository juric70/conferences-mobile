import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/conference_day.dart';
import 'package:conferences_mobile/model/conferences.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/pages/conferences/conference_day_detail_for_creator.dart';
import 'package:conferences_mobile/pages/conferences/conference_days_create.dart';
import 'package:conferences_mobile/pages/conferences/conferences_edit.dart';
import 'package:flutter/material.dart';

class ConferenceDetailForCreatorScreen extends StatefulWidget {
  final int conferenceId;

  const ConferenceDetailForCreatorScreen(
      {super.key, required this.conferenceId});
  @override
  State<ConferenceDetailForCreatorScreen> createState() =>
      _ConferenceDetailForCreatorScreenState();
}

class _ConferenceDetailForCreatorScreenState
    extends State<ConferenceDetailForCreatorScreen> {
  late Conference _conference;
  bool _isLoading = true;
  bool isCreatorOfConference = false;
  UserModel? user;
  @override
  void initState() {
    super.initState();
    _getConferenceDetails(widget.conferenceId);

    _checkIsAutor();
  }

  void _getConferenceDetails(int id) {
    ConferenceServise.getConferenceDetail(id).then((conference) {
      setState(() {
        _conference = conference;
        _isLoading = false;
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
          content: Text('You must be creator so you can see conference.'),
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
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xffeadc48),
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _conference.name.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: Color(0xffeadc48),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 8.0, 20.0, 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Date:',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${_conference.starting_date} - ${_conference.ending_date}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 8.0, 20.0, 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'City:',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        _conference.city,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 8.0, 20.0, 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Organization:',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        _conference.organization,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 8.0, 20.0, 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Description:',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        width:
                                            (MediaQuery.of(context).size.width *
                                                    0.78) *
                                                0.45,
                                        child: Text(
                                          _conference.description,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff262626),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            color: Color(0xffeadc48),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ConferenceEditScreen(
                                                    conferenceId:
                                                        _conference.id),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Edit!',
                                        style: TextStyle(
                                          color: Color(0xffeadc48),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: Color(0xffeadc48),
                                ),
                                for (ConferenceDay conferenceDay
                                    in _conference.conferences_day!)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 8.0, 20.0, 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Day:${conferenceDay.day_number}  (${conferenceDay.date})',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xff262626),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Color(0xffeadc48),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                            child: const Text(
                                              'More...',
                                              style: TextStyle(
                                                color: Color(0xffeadc48),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConferencesDayShowDetails(
                                                    conferenceDayId:
                                                        conferenceDay.id,
                                                    conferenceId:
                                                        _conference.id,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              Positioned(
                bottom: 10.0,
                right: 10.0,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ConferencesDayCreateScreen(
                              conferenceId: widget.conferenceId);
                        },
                      ),
                    );
                  },
                  backgroundColor: Color(0xffeadc48),
                  child: Icon(
                    Icons.add,
                    color: Color(0xff2a2a2a),
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
