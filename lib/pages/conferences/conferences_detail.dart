import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/category.dart';
import 'package:conferences_mobile/model/conference_day.dart';
import 'package:conferences_mobile/model/conferences.dart';
import 'package:conferences_mobile/model/timetable.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/pages/conferences/book_ticket.dart';
import 'package:flutter/material.dart';

class ConferencesDetailScreen extends StatefulWidget {
  final int conferenceId;
  ConferencesDetailScreen({required this.conferenceId});

  @override
  State<ConferencesDetailScreen> createState() =>
      _ConferencesDetailScreenState();
}

class _ConferencesDetailScreenState extends State<ConferencesDetailScreen> {
  late Conference _conference;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getConferenceDetails(widget.conferenceId);
  }

  void _getConferenceDetails(int id) {
    ConferenceServise.getConferenceDetail(id).then((conference) {
      setState(() {
        _conference = conference;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double conference_data_width = MediaQuery.of(context).size.width * 0.65;

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
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Color(0xff4924b6), Color(0xff2a2a2a)],
              )),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                //DATUM

                                Row(
                                  children: [
                                    Container(
                                      width: conference_data_width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: conference_data_width,
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Text(
                                                '${_conference.starting_date} - ${_conference.ending_date}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            height: 5.0,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              _conference.name.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              _conference.description,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            height: 5.0,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              'Conference schedule'
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            height: 5.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: Center(
                                        child: Container(
                                          width: 115.0,
                                          height: 115.0,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 3.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(150.0),
                                          ),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              onPrimary: Color(0XFF2A2A2A),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        150.0),
                                              ),
                                            ),
                                            child: Text('BOOK NOW'),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookTicketScreen(
                                                          conferenceId:
                                                              _conference.id),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                //**********************************OVO SU PREDAVANJA ******************************************************************************

                                for (ConferenceDay conferenceDay
                                    in _conference.conferences_day!)
                                  Row(
                                    children: [
                                      //**************************Lijevo gdje je predavanje*********************************+++ */
                                      Container(
                                        width: conference_data_width,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 40.0,
                                                    width: 40.0,
                                                    child: Container(
                                                      child: Center(
                                                        child: Text(
                                                          '${conferenceDay.day_number}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 30.0),
                                                        ),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 3.0)),
                                                  ),
                                                  Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          8.0, 0.0, 0.0, 0.0),
                                                      child: Text(
                                                        conferenceDay.date,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            for (Timetable timetable
                                                in conferenceDay.timetables!)
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Container(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          '${timetable.startingTime} - ${timetable.endingTime}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        width:
                                                            conference_data_width *
                                                                0.6,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              '${timetable.title}'
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width:
                                                            conference_data_width *
                                                                0.4,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${timetable.host}'
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      12.0),
                                                            )),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),

                                      //******************************************SA STRANE GDJEE SU KRUGOVI */

                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height: 100.0,
                                        child: Center(
                                          child: Wrap(
                                            children: [
                                              for (Category category
                                                  in conferenceDay.categories!)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    width: 58.0,
                                                    height: 58.0,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: category.color!,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80.0),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        category.name,
                                                        style: TextStyle(
                                                          color: category.color,
                                                          fontSize: 11.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              ],
                            ),
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
