import 'dart:convert';

import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/city.dart';
import 'package:conferences_mobile/model/organization.dart';
import 'package:conferences_mobile/network/city_service.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/network/organization_service.dart';
import 'package:conferences_mobile/pages/conferences/conference_days_create.dart';
import 'package:flutter/material.dart';

class ConferencesCreateScreen extends StatefulWidget {
  const ConferencesCreateScreen({super.key});

  @override
  State<ConferencesCreateScreen> createState() =>
      _ConferencesCreateScreenState();
}

class _ConferencesCreateScreenState extends State<ConferencesCreateScreen> {
  bool isLoggedin = false;
  bool isLoading = true;
  List<Organization> _organizations = [];
  List<City> _cities = [];
  UserModel? user;
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime.now();
  TextEditingController nameContoller = TextEditingController();
  TextEditingController descriptionContoller = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateContoller = TextEditingController();
  int? selectedOrganization;
  int? selectedCity;
  String? _nameError, _descriptionError, _startingDateError, _endingDateError;
  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus();
    _getCity();
  }

  bool _isNumeric(String str) {
    if (str.isNotEmpty) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void _createConference() async {
    try {
      String name = nameContoller.text;
      String description = descriptionContoller.text;
      String startDate = startDateController.text;
      String endDate = endDateContoller.text;
      final response = {
        'name': name,
        'description': description,
        'starting_date': startDate,
        'ending_date': endDate,
        'city_id': selectedCity,
        'organization_id': selectedOrganization
      };
      final jsonData = jsonEncode(response);
      String result = await ConferenceServise.createConference(jsonData);
      if (_isNumeric(result) && result != '-1') {
        int confId = jsonDecode(result);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conference created successfully!'),
            backgroundColor: Color(0xff4a23b2),
          ),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ConferencesDayCreateScreen(conferenceId: confId);
            },
          ),
        );
      } else if (result == '-1') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'You need to buy subscription so you can publish conference'),
          ),
        );
        Navigator.of(context).pushNamed('/organizationsOffers');
      } else {
        final Map<String, dynamic> errorData = jsonDecode(result);
        setState(() {
          _nameError =
              errorData['name'] != null ? errorData['name'][0].toString() : '';
          _descriptionError = errorData['description'] != null
              ? errorData['description'][0].toString()
              : '';
          _startingDateError = errorData['starting_date'] != null
              ? errorData['starting_date'][0].toString()
              : '';
          _endingDateError = errorData['ending_date'] != null
              ? errorData['ending_date'][0].toString()
              : '';
        });
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  void getOrganizationsOfUser(int id) {
    OrganizationService.getOrganizationsByUser(id).then((organization) {
      setState(() {
        _organizations = organization;
        isLoading = false;
      });
    });
  }

  Future<void> _checkLoggedInStatus() async {
    await Future.delayed(Duration.zero);
    user = await AuthModel().LoggedInUser();
    setState(
      () {
        if (user == null) {
          isLoggedin = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You must be logedin so You can buy subscription.'),
              backgroundColor: Color(0xffbe2b61),
            ),
          );
          Navigator.of(context).pushNamed('/login');
        } else {
          isLoggedin = true;
          getOrganizationsOfUser(user!.id);
        }
      },
    );
  }

  _getCity() {
    CityService.getCity().then((city) {
      if (mounted) {
        setState(() {
          _cities = city;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedin == false) {
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
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Create your conference!'.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
//name
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: TextFormField(
                              controller: nameContoller,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                errorText: _nameError,
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

                        //description
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: TextFormField(
                              controller: descriptionContoller,
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
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width * 0.85,
                            decoration: BoxDecoration(
                              color: const Color(0XFF1A1A1A),
                              border: Border.all(
                                color: const Color(0xff4a23b2),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: const Color(0xff1A1A1A),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int?>(
                                  value: selectedOrganization,
                                  hint: const Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        16.0, 8.0, 16.0, 8.0),
                                    child: Text(
                                      'Select your organization ',
                                      style: TextStyle(
                                        color: Color((0xffbe2b61)),
                                      ),
                                    ),
                                  ),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      selectedOrganization = newValue!;
                                    });
                                  },
                                  items: _organizations
                                      .map<DropdownMenuItem<int?>>(
                                          (Organization organization) {
                                    return DropdownMenuItem<int?>(
                                      value: organization.id,
                                      child: Text(
                                        organization.name,
                                        style: const TextStyle(
                                          color: Color(0xffbe2b61),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width * 0.85,
                            decoration: BoxDecoration(
                              color: const Color(0XFF1A1A1A),
                              border: Border.all(
                                color: const Color(0xff4a23b2),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: const Color(0xff1A1A1A),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int?>(
                                  value: selectedCity,
                                  hint: const Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        16.0, 8.0, 16.0, 8.0),
                                    child: Text(
                                      'Select city ',
                                      style: TextStyle(
                                        color: Color((0xffbe2b61)),
                                      ),
                                    ),
                                  ),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      selectedCity = newValue!;
                                    });
                                  },
                                  items: _cities
                                      .map<DropdownMenuItem<int?>>((City city) {
                                    return DropdownMenuItem<int?>(
                                      value: city.id,
                                      child: Text(
                                        city.name,
                                        style: const TextStyle(
                                          color: Color(0xffbe2b61),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: TextFormField(
                              controller: startDateController,
                              decoration: InputDecoration(
                                labelText: 'Starting date',
                                errorText: _startingDateError,
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
                                fillColor: const Color(0xff1a1a1a),
                                filled: true,
                                suffixIcon: InkWell(
                                  onTap: () async {
                                    DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: startDate,
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100),
                                    );
                                    if (newDate == null) return;
                                    setState(() {
                                      startDate = newDate;
                                      startDateController.text =
                                          '${startDate.year}/${startDate.month}/${startDate.day}';
                                    });
                                  },
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xffbe2b61),
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                  color: Colors.amber, fontSize: 18.0),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: TextFormField(
                              controller: endDateContoller,
                              decoration: InputDecoration(
                                labelText: 'Ending date',
                                errorText: _endingDateError,
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
                                fillColor: const Color(0xff1a1a1a),
                                filled: true,
                                suffixIcon: InkWell(
                                  onTap: () async {
                                    DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: startDate,
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100),
                                    );
                                    if (newDate == null) return;
                                    setState(() {
                                      endDate = newDate;
                                      endDateContoller.text =
                                          '${endDate.year}/${endDate.month}/${endDate.day}';
                                    });
                                  },
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xffbe2b61),
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                  color: Colors.amber, fontSize: 18.0),
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
                                _createConference();
                              },
                              child: const Text(
                                'Create conference!',
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  )
          ]),
        ),
      );
    }
  }
}
