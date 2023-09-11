import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/conferences.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/pages/conferences/confeerence_detail_for_creator.dart';
import 'package:flutter/material.dart';

class ConferencesForCreatorScreen extends StatefulWidget {
  const ConferencesForCreatorScreen({super.key});

  @override
  State<ConferencesForCreatorScreen> createState() =>
      _ConferencesForCreatorScreenState();
}

class _ConferencesForCreatorScreenState
    extends State<ConferencesForCreatorScreen> {
  bool isLoggedIn = false;
  bool isLoading = true;
  UserModel? user;
  List<Conference> _conferences = [];

  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus();
  }

  Future<void> _checkLoggedInStatus() async {
    await Future.delayed(Duration.zero);
    user = await AuthModel().LoggedInUser();
    setState(
      () {
        if (user == null) {
          isLoggedIn = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'You must be logedin so You can see your organizations.'),
              backgroundColor: Color(0xffbe2b61),
            ),
          );
          Navigator.of(context).pushNamed('/login');
        } else {
          isLoggedIn = true;
          getConferencesOfUser(user!.id);
        }
      },
    );
  }

  void getConferencesOfUser(int id) {
    ConferenceServise.getConferencesByUser(id).then((conferences) {
      setState(() {
        _conferences = conferences;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == false) {
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
            BackgroundScrollView(),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'My conferences!'.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: const Text(
                                    'Conferences',
                                    style: TextStyle(
                                        color: Color(0xffeadc48),
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Text(
                                    'Organization',
                                    style: TextStyle(
                                        color: Color(0xffeadc48),
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: Text(
                                    'See more',
                                    style: TextStyle(
                                        color: Color(0xffeadc48),
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Color(0xFF4924b6),
                            height: 1.0,
                            thickness: 2.0,
                          ),
                          for (Conference conference in _conferences)
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: Text(
                                        conference.name,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.0),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: Text(
                                        conference.organization,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.0),
                                      ),
                                    ),
                                    Container(
                                      height: 30.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      color: const Color(0xff2a2a2a),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ConferenceDetailForCreatorScreen(
                                                      conferenceId:
                                                          conference.id),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff2a2a2a),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          color: Color(0xffbe2b61),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const Divider(
                            color: Color(0xFF4924b6),
                            height: 1.0,
                            thickness: 2.0,
                          ),
                        ],
                      ),
                    ),
                  ),
            Positioned(
                bottom: 10.0,
                right: 10.0,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/conferencesCreate');
                  },
                  backgroundColor: Color(0xff4924b6),
                  child: Icon(Icons.add, color: Colors.white),
                ))
          ]),
        ),
      );
    }
  }
}
