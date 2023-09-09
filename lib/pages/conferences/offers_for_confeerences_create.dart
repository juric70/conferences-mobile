import 'dart:convert';

import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/pages/conferences/conferences_detail.dart';
import 'package:flutter/material.dart';

class UsersOffersCreateScreen extends StatefulWidget {
  final int conferenceId;
  final int conferenceDayId;
  const UsersOffersCreateScreen(
      {super.key, required this.conferenceId, required this.conferenceDayId});

  @override
  State<UsersOffersCreateScreen> createState() =>
      _UsersOffersCreateScreenState();
}

class _UsersOffersCreateScreenState extends State<UsersOffersCreateScreen> {
  bool isCreatorOfConference = false;
  UserModel? user;
  final TextEditingController _kindController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _numberOfDaysController = TextEditingController();
  String? _kindError,
      _codeError,
      _priceError,
      _descriptionError,
      _numberOfDaysError;
  @override
  void initState() {
    super.initState();
    _checkIsAutor();
  }

  Future<int> _createUsersOffers() async {
    try {
      final response = {
        'kind': _kindController.text,
        'code': _codeController.text,
        'price': int.parse(_priceController.text),
        'description': _descriptionController.text,
        'number_of_days': int.parse(_numberOfDaysController.text),
        'conference_id': widget.conferenceId,
      };
      final jsonData = jsonEncode(response);
      String result = await ConferenceServise.createUsersOffers(jsonData);
      if (result == '200') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offer for user created successfully!'),
            backgroundColor: Color(0xff4a23b2),
          ),
        );
        return 1;
      } else {
        final Map<String, dynamic> errorData = jsonDecode(result);
        setState(() {
          _kindError =
              errorData['kind'] != null ? errorData['kind'][0].toString() : '';
          _codeError =
              errorData['code'] != null ? errorData['code'][0].toString() : '';
          _priceError = errorData['price'] != null
              ? errorData['price'][0].toString()
              : '';
          _descriptionError = errorData['description'] != null
              ? errorData['description'][0].toString()
              : '';
          _numberOfDaysError = errorData['number_of_days'] != null
              ? errorData['number_of_days'][0].toString()
              : '';
        });
        return 0;
      }
    } catch (e) {
      throw Future.error(e);
    }
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
          content: Text('You must be creator so you can edit conference.'),
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
          body: Stack(children: [
            const BackgroundScrollView(),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Create offers for users!'.toUpperCase(),
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
                          controller: _kindController,
                          decoration: InputDecoration(
                            labelText: 'Kind',
                            errorText: _kindError,
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
                          controller: _codeController,
                          decoration: InputDecoration(
                            labelText: 'Code',
                            errorText: _codeError,
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
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            errorText: _priceError,
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
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            errorText: _descriptionError,
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
                          controller: _numberOfDaysController,
                          decoration: InputDecoration(
                            labelText: 'Number of days user have to book',
                            errorText: _numberOfDaysError,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SizedBox(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width * 0.42,
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
                              onPressed: () async {
                                int res = await _createUsersOffers();
                                if (res == 1) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ConferencesDetailScreen(
                                          conferenceId: widget.conferenceId,
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Done creating conference!',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SizedBox(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width * 0.42,
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
                              onPressed: () async {
                                int res = await _createUsersOffers();
                                if (res == 1) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return UsersOffersCreateScreen(
                                          conferenceId: widget.conferenceId,
                                          conferenceDayId:
                                              widget.conferenceDayId,
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Create more offers!',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
