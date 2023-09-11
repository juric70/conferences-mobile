import 'dart:math';

import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/category.dart';
import 'package:conferences_mobile/model/conferences.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/pages/conferences/conferences_detail.dart';
import 'package:flutter/material.dart';

class ConferencesAllScreen extends StatefulWidget {
  const ConferencesAllScreen({super.key});

  @override
  State<ConferencesAllScreen> createState() => _ConferencesAllScreenState();
}

class _ConferencesAllScreenState extends State<ConferencesAllScreen> {
  List<Conference> _conferences = [];
  String searchText = '';
  int randomNumber = Random().nextInt(3) + 1;

  _getConferences() {
    ConferenceServise.getConferences().then((conference) {
      if (mounted) {
        setState(() {
          _conferences = conference;
        });
      }
    });
  }

  List<Conference> _search(String value) {
    final searchTerm = value.toLowerCase();
    if (value != '') {
      List<Conference> conf = _conferences
          .where((conference) =>
              conference.name.toLowerCase().contains(searchTerm))
          .toList();
      return conf;
    } else {
      return _conferences;
    }
  }

  @override
  void initState() {
    super.initState();
    _getConferences();
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width - 40;
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
                  child: Column(children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 30.0, 0.0, 0.0),
                          child: Center(
                            child: Text(
                              'ALL CONFERENCES',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 30.0, 10.0, 0.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 40.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: randomNumber == 1
                                      ? const Color(0xffc32d63)
                                      : randomNumber == 2
                                          ? const Color(0xffeadc48)
                                          : const Color(0xff663fd9),
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                                color: const Color(0xff1a1a1a),
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                    color: randomNumber == 1
                                        ? const Color(0xffc32d63)
                                        : randomNumber == 2
                                            ? const Color(0xffeadc48)
                                            : const Color(0xff997fe6),
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: randomNumber == 1
                                        ? const Color(0xffc32d63)
                                        : randomNumber == 2
                                            ? const Color(0xffeadc48)
                                            : const Color(0xff997fe6),
                                  ),
                                ),
                                style:
                                    const TextStyle(color: Color(0xffbe2b61)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(),
                    for (Conference conferences in _search(searchText))
                      Container(
                        height: 220.0,
                        width: cardWidth,
                        margin: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                        decoration: BoxDecoration(
                          color: const Color(0xff1a1a1a).withOpacity(0.97),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: randomNumber == 1
                                ? const Color(0xffc32d63)
                                : randomNumber == 2
                                    ? const Color(0xffeadc48)
                                    : const Color(0xff663fd9),
                          ),
                        ),
                        child: Row(
                          children: [
                            //ONO SA STRANE
                            Container(
                              height: double.infinity,
                              width: 15.0,
                              // margin: const EdgeInsets.only(
                              //   bottom: 1.5,
                              // ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                ),
                                gradient: randomNumber == 1
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xffe283a6),
                                          Color(0xffc32d63)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      )
                                    : (randomNumber == 2)
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xffefe376),
                                              Color(0xffb7a915)
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          )
                                        : const LinearGradient(
                                            colors: [
                                              Color(0xff8a6ae2),
                                              Color(0xff4a23b2)
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                              ),
                            ),

                            //SASTRANE OD KARTICE :)
                            SizedBox(
                              height: 220.0,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 32.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        conferences.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        18.0, 10.0, 8.0, 0.0),
                                    width: cardWidth - 17,
                                    height: 85.0,
                                    child: Text(
                                      conferences.description,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                      ),
                                      maxLines: 4,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 45.0,
                                    width: cardWidth - 17,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          for (Category category
                                              in conferences.categories ?? [])
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: category.color!,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  30.0,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  category.name.toUpperCase(),
                                                  style: TextStyle(
                                                    color: category.color,
                                                    fontSize: 9.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 45.0,
                                    width: cardWidth - 17,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                18.0, 0.0, 0.0, 0.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  conferences.organization,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: randomNumber == 1
                                                        ? const Color(
                                                            0xffc32d63)
                                                        : randomNumber == 2
                                                            ? const Color(
                                                                0xffeadc48)
                                                            : const Color(
                                                                0xff997fe6),
                                                  ),
                                                ),
                                                Text(
                                                  '${conferences.starting_date} - ${conferences.ending_date}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: randomNumber == 1
                                                        ? const Color(
                                                            0xffc32d63)
                                                        : randomNumber == 2
                                                            ? const Color(
                                                                0xffeadc48)
                                                            : const Color(
                                                                0xff997fe6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 0.0, 18.0, 0.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ConferencesDetailScreen(
                                                            conferenceId:
                                                                conferences.id),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.black,
                                                backgroundColor: randomNumber ==
                                                        1
                                                    ? const Color(0xffc32d63)
                                                    : randomNumber == 2
                                                        ? const Color(
                                                            0xffeadc48)
                                                        : const Color(
                                                            0xff4924b6),
                                                side: BorderSide(
                                                  color: randomNumber == 1
                                                      ? const Color(0xff91224a)
                                                      : randomNumber == 2
                                                          ? const Color(
                                                              0xffeada4b)
                                                          : const Color(
                                                              0xff331980),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0), // Ovdje postavite željeni radijus
                                                ),
                                              ),
                                              child: Text(
                                                'See more!',
                                                style: TextStyle(
                                                  color: randomNumber == 1
                                                      ? const Color(0xff2a2a2a)
                                                      : randomNumber == 2
                                                          ? const Color(
                                                              0xff2a2a2a)
                                                          : Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                  ]),
                ),
              ),
            ],
          )),
    );
  }
}

@override
Widget build(BuildContext context) {
  throw UnimplementedError();
}
