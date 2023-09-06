import 'dart:convert';

import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/conference_day.dart';
import 'package:conferences_mobile/model/conferences.dart';
import 'package:conferences_mobile/model/users_offer.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/network/users_offer_service.dart';
import 'package:conferences_mobile/pages/conferences/conferences_detail.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class BookTicketScreen extends StatefulWidget {
  final int conferenceId;
  const BookTicketScreen({super.key, required this.conferenceId});

  @override
  State<BookTicketScreen> createState() => _BookTicketScreenState();
}

class _BookTicketScreenState extends State<BookTicketScreen> {
  TextEditingController codeController = TextEditingController();
  late Conference _conference;
  late List<UsersOffer> _usersOffer = [];
  bool _isLoaded = true;
  bool isLoggedIn = false;
  List<ConferenceDay> conferenceDay = [];
  List<int> selectedIds = [];
  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus();
    _getConfereceDetails(widget.conferenceId);
  }

  Future<void> _checkLoggedInStatus() async {
    await Future.delayed(Duration.zero);
    UserModel? user = await AuthModel().LoggedInUser();

    setState(
      () {
        if (user == null) {
          isLoggedIn = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You must be logedin so You can book ticket.'),
              backgroundColor: Color(0xffbe2b61),
            ),
          );
          Navigator.of(context).pushNamed('/login');
        } else {
          isLoggedIn = true;
        }
      },
    );
  }

  void _getConfereceDetails(int id) {
    ConferenceServise.getConferenceDetail(id).then((conference) {
      setState(() {
        _conference = conference;
        _getUsersOffers(_conference.id);
        _isLoaded = false;
        conferenceDay = conference.conferences_day!;
      });
    });
  }

  void _getUsersOffers(int id) {
    UsersOfferService.getOffersForConference(id).then((usersOffer) {
      setState(() {
        _usersOffer = usersOffer;
      });
    });
  }

  void _buyTicket() async {
    try {
      String code = codeController.text;
      final response = {"code": code, "conf_days": selectedIds};
      final jsonData = jsonEncode(response);
      String result = await ConferenceServise.buyTicket(jsonData);
      if (result.contains('Successfully')) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: const Color(0xff4a23b2),
          ),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ConferencesDetailScreen(conferenceId: _conference.id),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
          ),
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<MultiSelectItem<ConferenceDay>> multiSelect = conferenceDay
        .map((day) => MultiSelectItem<ConferenceDay>(
            day, '${day.date} - Day ${day.day_number}'))
        .toList();
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
            _isLoaded
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              'Book ticket now!!!'.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            for (ConferenceDay confDays
                                in _conference.conferences_day!)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                  child: Text(
                                    '${confDays.date} - Day ${confDays.day_number}: ${confDays.price}€'
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xffbe2b61),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Available Discounts'.toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xffbe2b61),
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            for (UsersOffer usersOffer in _usersOffer)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                  child: Text(
                                    'CODE: ${usersOffer.code}        ${usersOffer.kind}        PRICE: ${usersOffer.price}€ ',
                                    style: const TextStyle(
                                      color: Color(0xffbe2b61),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.83,
                            child: MultiSelectDialogField(
                              items: multiSelect,
                              listType: MultiSelectListType.CHIP,
                              onConfirm: (values) {
                                setState(() {
                                  selectedIds =
                                      values.map((e) => e.id).toList();
                                });
                              },
                              buttonText: const Text(
                                'Select',
                                style: TextStyle(color: Color(0xffbe2b61)),
                              ),
                              selectedItemsTextStyle:
                                  const TextStyle(color: Colors.white),
                              backgroundColor: const Color(0xff1a1a1a),
                              title: Text(
                                'Select days of conference You want to book!',
                                style: TextStyle(
                                    color: const Color(0xff4a23b2),
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(0.50, 0.50),
                                        blurRadius: 0.80,
                                        color: Colors.white.withOpacity(0.3),
                                      )
                                    ],
                                    fontWeight: FontWeight.w900),
                              ),
                              selectedColor: const Color(0xff4a23b2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xff4a23b2), width: 2.0),
                                borderRadius: BorderRadius.circular(1.0),
                                color: const Color(0xff1a1a1a),
                              ),
                              buttonIcon: const Icon(
                                Icons.arrow_downward,
                                color: Color(0xff4a23b2),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: TextFormField(
                              controller: codeController,
                              decoration: const InputDecoration(
                                labelText: 'Code for discount ',
                                labelStyle: TextStyle(
                                    color: Color(0xffbe2b61), fontSize: 14.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xff4a23b2), width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff4a23b2),
                                    width: 0.50,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                  vertical: 6.0,
                                ),
                                fillColor: Color(0xff1a1a1a),
                                filled: true,
                              ),
                              style: const TextStyle(
                                  color: Color(0xffbe2b61), fontSize: 17.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff4a23b2),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Color(0xff351980),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                _buyTicket();
                              },
                              child: const Text(
                                'Book ticket!',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
          ]),
        ),
      );
    }
  }
}
