import 'dart:math';

import 'package:conferences_mobile/components/background_homepage.dart';
import 'package:conferences_mobile/model/category.dart';
import 'package:conferences_mobile/model/conferences.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/pages/conferences/conferences_detail.dart';
import 'package:flutter/material.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _rotationController;
  late Animation<Offset> _animation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  List<Conference> _conferences = [];
  int randomNumber = Random().nextInt(3) + 1;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _getConferences();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _rotationAnimation = CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    );

    _animation = Tween<Offset>(
      begin: const Offset(-2.0, -3.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.position.pixels;
      });
    });

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.1,
    ).animate(_controller);

    _controller.forward();
  }

  _getConferences() {
    ConferenceServise.getConferences().then((conference) {
      if (mounted) {
        setState(() {
          _conferences = conference;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width - 40;
    double maxSlide = 00.0;
    double slideValue =
        _scrollPosition < maxSlide ? _scrollPosition : _scrollPosition;
    double slideOffsetX = slideValue - maxSlide;

    return Scaffold(
      backgroundColor: const Color(0xFF2A2A2A),
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
          const HomePageBackground(),
          SingleChildScrollView(
            controller: _scrollController,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SlideTransition(
                      position: _animation,
                      child: Container(
                        height: 25.0,
                        margin:
                            const EdgeInsets.fromLTRB(350.0, 20.0, 0.0, 0.0),
                        width: 25.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(230.0),
                          color: const Color(0xff4924b6).withOpacity(0.65),
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: _animation,
                      child: Align(
                        alignment: Alignment.center,
                        child: Transform.translate(
                          offset: Offset(slideOffsetX, 0.0),
                          child: Container(
                            margin:
                                const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                            height: 230.0,
                            width: 230.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(270.0),
                              color: Colors.white.withOpacity(0.85),
                            ),
                            child: const Center(
                              child: Text(
                                'CONFERENCES HUB',
                                style: TextStyle(
                                  color: Color(0xFF4924b6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: _animation,
                      child: Transform.translate(
                        offset: Offset(slideOffsetX, 0.0),
                        child: Container(
                          height: 25.0,
                          margin:
                              const EdgeInsets.fromLTRB(350.0, 15.0, 0.0, 0.0),
                          width: 25.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(230.0),
                            color: Colors.yellow.withOpacity(0.85),
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        SlideTransition(
                          position: _animation,
                          child: Align(
                            alignment: Alignment.center,
                            child: Transform.translate(
                              offset: Offset(slideOffsetX, slideOffsetX * 3),
                              child: RotationTransition(
                                turns: _rotationAnimation,
                                child: Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 0.0),
                                    height: 110.0,
                                    width: 110.0,
                                    child: Image.asset(
                                      ("images/starHomePg.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SlideTransition(
                          position: _animation,
                          child: Transform.translate(
                            offset: Offset(slideOffsetX, slideOffsetX * 3),
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(
                                  155.0, 25.0, 0.0, 0.0),
                              height: 100.0,
                              width: 100.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/conferences');
                                },
                                child: const Text(
                                  'Go to events! ',
                                  style: TextStyle(
                                    color: Color(0xFFeadc48),
                                    fontSize: 23,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Center(
                          child: Container(
                            width: cardWidth,
                            margin:
                                const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                            decoration: BoxDecoration(
                              color: const Color(0xff1a1a1a).withOpacity(0.97),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: randomNumber == 1
                                    ? const Color(0xffc32d63)
                                    : randomNumber == 2
                                        ? const Color(0xffeadc48)
                                        : const Color(0xff663fd9),
                              ),
                            ),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'UPCOMING CONFERENCES!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    decorationThickness: 1.0,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.3,
                                    wordSpacing: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        //POČETRAK KARTICA
                        Column(children: [
                          for (Conference conferences in _conferences)
                            Container(
                              height: 220.0,
                              width: cardWidth,
                              margin: const EdgeInsets.fromLTRB(
                                  0.0, 30.0, 0.0, 0.0),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xff1a1a1a).withOpacity(0.97),
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
                                    margin: const EdgeInsets.only(
                                      bottom: 1.5,
                                    ),
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
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
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
                                                    in conferences.categories ??
                                                        [])
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        category.name
                                                            .toUpperCase(),
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
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          18.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        conferences
                                                            .organization,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: randomNumber ==
                                                                  1
                                                              ? const Color(
                                                                  0xffc32d63)
                                                              : randomNumber ==
                                                                      2
                                                                  ? const Color(
                                                                      0xffeadc48)
                                                                  : const Color(
                                                                      0xff997fe6),
                                                        ),
                                                      ),
                                                      Text(
                                                        '${conferences.starting_date} - ${conferences.ending_date}',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: randomNumber ==
                                                                  1
                                                              ? const Color(
                                                                  0xffc32d63)
                                                              : randomNumber ==
                                                                      2
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
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0.0, 0.0, 18.0, 0.0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ConferencesDetailScreen(
                                                                  conferenceId:
                                                                      conferences
                                                                          .id),
                                                        ),
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                          Colors.black,
                                                      backgroundColor:
                                                          randomNumber == 1
                                                              ? const Color(
                                                                  0xffc32d63)
                                                              : randomNumber ==
                                                                      2
                                                                  ? const Color(
                                                                      0xffeadc48)
                                                                  : const Color(
                                                                      0xff4924b6),
                                                      side: BorderSide(
                                                        color: randomNumber == 1
                                                            ? const Color(
                                                                0xff91224a)
                                                            : randomNumber == 2
                                                                ? const Color(
                                                                    0xffeada4b)
                                                                : const Color(
                                                                    0xff331980),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15.0), // Ovdje postavite željeni radijus
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'See more!',
                                                      style: TextStyle(
                                                        color: randomNumber == 1
                                                            ? const Color(
                                                                0xff2a2a2a)
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
                      ],
                    )
                  ],
                ),

                //ZUTI KRUG
                Column(
                  children: [
                    SlideTransition(
                      position: _animation,
                      child: Transform.translate(
                        offset: Offset(slideOffsetX * 1.5, 0.0),
                        child: Container(
                          margin:
                              const EdgeInsets.fromLTRB(40.0, 320.0, 0.0, 0.0),
                          height: 150.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150.0),
                            color: Colors.yellow,
                          ),
                          child: const Center(
                            child: Text(
                              'The place where knowledge and organisation cooperate',
                              style: TextStyle(
                                color: Color(0xFFc32d63),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: _animation,
                      child: Transform.translate(
                        offset: Offset(
                            slideOffsetX * (-3.0), slideOffsetX * (-1.0)),
                        child: Container(
                          height: 25.0,
                          margin:
                              const EdgeInsets.fromLTRB(30.0, 470.0, 0.0, 0.0),
                          width: 25.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(230.0),
                            color: const Color(0xffbe2c61),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
