import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/booked_ticket.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/pages/conferences/conferences_detail.dart';
import 'package:flutter/material.dart';

class BookedTicketsScreen extends StatefulWidget {
  const BookedTicketsScreen({super.key});

  @override
  State<BookedTicketsScreen> createState() => _BookedTicketsScreenState();
}

class _BookedTicketsScreenState extends State<BookedTicketsScreen> {
  bool isLoggedIn = false;
  bool isLoading = true;
  UserModel? user;
  List<BookedTicket> _tickets = [];
  String searchText = '';

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
                  'You must be logedin so You can see your booked tickets.'),
              backgroundColor: Color(0xffbe2b61),
            ),
          );
          Navigator.of(context).pushNamed('/login');
        } else {
          isLoggedIn = true;
          _getTickets(user!.id);
        }
      },
    );
  }

  List<BookedTicket> _search(String value) {
    final searchTerm = value.toLowerCase();
    if (value != '') {
      List<BookedTicket> conf = _tickets
          .where((tickets) => tickets.conferenceDay.conference
              .toLowerCase()
              .contains(searchTerm))
          .toList();
      return conf;
    } else {
      return _tickets;
    }
  }

  _getTickets(int id) {
    ConferenceServise.getUsersTicket(id).then((ticket) {
      if (mounted) {
        setState(() {
          _tickets = ticket;
          isLoading = false;
        });
      }
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
            const BackgroundScrollView(),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 30.0, 0.0, 0.0),
                                child: Center(
                                  child: Text(
                                    'MY TICKETS!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 30.0, 10.0, 0.0),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xff4a23b2),
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
                                      decoration: const InputDecoration(
                                        hintText: 'Search',
                                        hintStyle:
                                            TextStyle(color: Color(0xffbe2b61)),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Color(0xff4a23b2),
                                        ),
                                      ),
                                      style: const TextStyle(
                                          color: Color(0xffbe2b61)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              for (BookedTicket ticket in _search(searchText))
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xff1a1a1a)
                                            .withOpacity(0.7),
                                        border: Border.all(
                                            color: const Color(0XFFeadc48),
                                            width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      height: 170.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${ticket.conferenceDay.conference} - Day ${ticket.conferenceDay.day_number}',
                                              style: const TextStyle(
                                                color: Color(0xffeadc48),
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          ticket.paid == true
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Price:  ${ticket.price}, it is paid',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Price:  ${ticket.price}, it is not paid',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Date of conference: ${ticket.conferenceDay.date}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ),
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
                                                            conferenceId: ticket
                                                                .conferenceDay
                                                                .conferenceId),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.black,
                                                backgroundColor:
                                                    const Color(0XFF1A1A1A),
                                                side: const BorderSide(
                                                    color: Color(0xffeada4b)),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0), // Ovdje postavite željeni radijus
                                                ),
                                              ),
                                              child: const Text(
                                                'See more!',
                                                style: TextStyle(
                                                    color: Color(0xffeada4b)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
          ]),
        ),
      );
    }
  }
}
