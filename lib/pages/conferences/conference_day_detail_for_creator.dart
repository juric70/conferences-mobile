import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/category.dart';
import 'package:conferences_mobile/model/conference_day.dart';
import 'package:conferences_mobile/model/timetable.dart';
import 'package:conferences_mobile/network/conference_day_service.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/pages/conferences/categories_edit.dart';
import 'package:conferences_mobile/pages/conferences/conference_day_edit.dart';
import 'package:conferences_mobile/pages/conferences/timetable_create.dart';
import 'package:conferences_mobile/pages/conferences/timetables_details.dart';
import 'package:flutter/material.dart';

class ConferencesDayShowDetails extends StatefulWidget {
  final int conferenceId;
  final int conferenceDayId;
  const ConferencesDayShowDetails(
      {super.key, required this.conferenceDayId, required this.conferenceId});

  @override
  State<ConferencesDayShowDetails> createState() =>
      _ConferencesDayShowDetailsState();
}

class _ConferencesDayShowDetailsState extends State<ConferencesDayShowDetails> {
  late ConferenceDay _conferenceDay;
  bool _isLoading = true;
  bool isCreatorOfConference = false;
  UserModel? user;

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
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                SingleChildScrollView(
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
                                'Day ${_conferenceDay.day_number}. (${_conferenceDay.date}) '
                                    .toUpperCase(),
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
                                    'Price:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${_conferenceDay.price} €',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff262626),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Color(0xffeadc48),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ConferenceDayEditScreen(
                                          conferenceId: widget.conferenceId,
                                          conferenceDayId: _conferenceDay.id,
                                        ),
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
                              height: 1.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Timetable:'.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Color(0xffeadc48),
                              height: 1.0,
                            ),
                            if (_conferenceDay.timetables != null)
                              for (Timetable timetable
                                  in _conferenceDay.timetables!)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 8.0, 20.0, 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width *
                                                    0.8) *
                                                0.60,
                                        child: Text(
                                          '${timetable.title} (${timetable.startingTime?.substring(0, 5)} - ${timetable.endingTime?.substring(0, 5)})',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width *
                                                    0.8) *
                                                0.2,
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
                                                    TimetableDetailScreen(
                                                  conferenceDayId:
                                                      widget.conferenceDayId,
                                                  conferenceId:
                                                      widget.conferenceId,
                                                  timetableId: timetable.id,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            const Divider(
                              color: Color(0xffeadc48),
                              height: 1.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Categories:'.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Color(0xffeadc48),
                              height: 1.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_conferenceDay.categories != null)
                                  for (Category category
                                      in _conferenceDay.categories!)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: category.color ??
                                                const Color(0xffeadc48),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Color(0xff2a2a2a),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            category.name,
                                            style: TextStyle(
                                                color: category.color ??
                                                    const Color(0xffeadc48)),
                                          ),
                                        ),
                                      ),
                                    )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                // width: MediaQuery.of(context).size.width * 0.15,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff262626),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Color(0xffeadc48),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditCategoriesOfConferenceDay(
                                          conferenceId: widget.conferenceId,
                                          conferenceDayId: _conferenceDay.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                    child: Text(
                                      'Add categories!',
                                      style: TextStyle(
                                        color: Color(0xffeadc48),
                                      ),
                                    ),
                                  ),
                                ),
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
                          return TimetableCreateScreen(
                            conferenceDayId: _conferenceDay.id,
                            conferenceId: widget.conferenceId,
                          );
                        },
                      ),
                    );
                  },
                  backgroundColor: const Color(0xffeadc48),
                  child: const Icon(
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
