import 'dart:convert';

import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/city.dart';
import 'package:conferences_mobile/model/organization.dart';
import 'package:conferences_mobile/model/organization_type.dart';
import 'package:conferences_mobile/network/city_service.dart';
import 'package:conferences_mobile/network/organization_service.dart';
import 'package:conferences_mobile/network/organization_type_service.dart';
import 'package:conferences_mobile/pages/organizations/organization_details.dart';
import 'package:flutter/material.dart';

class OrganizationEditScreen extends StatefulWidget {
  final int organizationId;
  const OrganizationEditScreen({super.key, required this.organizationId});

  @override
  State<OrganizationEditScreen> createState() => _OrganizationEditScreenState();
}

class _OrganizationEditScreenState extends State<OrganizationEditScreen> {
  UserModel? user;
  bool isCreatorOfConference = false;
  bool isLoading = true;
  Organization? _organization;
  TextEditingController nameContoller = TextEditingController();
  TextEditingController descriptionContoller = TextEditingController();
  TextEditingController addressContoller = TextEditingController();
  String? _nameError, _descriptionError, _addressError;
  int? selectedCity;
  int? selectedOrganizationType;
  List<City> _city = [];
  List<OrganizationType> _organizationType = [];
  @override
  void initState() {
    super.initState();
    _checkIsAutor();
    _getOrganization(widget.organizationId);
    _getCity();
    _getOrganizationType();
  }

  Future<void> _checkIsAutor() async {
    await Future.delayed(Duration.zero);
    user = await AuthModel().LoggedInUser();

    int creatorId = await OrganizationService.getIdOfCreatorOfOrganization(
        widget.organizationId);

    if (user!.id == creatorId) {
      setState(() {
        isCreatorOfConference = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('You must be creator of organization so you can edit it!'),
          backgroundColor: Color(0xffbe2b61),
        ),
      );
      Navigator.of(context).pushNamed('/');
    }
  }

  _getOrganization(int id) {
    OrganizationService.getOfOrganizationDetails(id).then((organization) {
      if (mounted) {
        setState(() {
          _organization = organization;
          nameContoller.text = _organization!.name;
          descriptionContoller.text = _organization!.description;
          addressContoller.text = _organization!.address;
          selectedCity = _organization!.cityId;
          selectedOrganizationType = _organization!.organizationTypeId;
          isLoading = false;
        });
      }
    });
  }

  _getCity() {
    CityService.getCity().then((city) {
      if (mounted) {
        setState(() {
          _city = city;
        });
      }
    });
  }

  _getOrganizationType() {
    OrganizationTypeService.getOrganizationTypes().then((organizationType) {
      if (mounted) {
        setState(() {
          _organizationType = organizationType;
        });
      }
    });
  }

  void _editOrganization() async {
    try {
      String name = nameContoller.text;
      String address = addressContoller.text;
      String description = descriptionContoller.text;
      final response = {
        'name': name,
        'address': address,
        'description': description,
        'city_id': selectedCity,
        'organization_type_id': selectedOrganizationType,
        'user_id': user!.id,
      };
      final jsonData = jsonEncode(response);
      String result = await OrganizationService.editOrganization(
          jsonData, widget.organizationId);
      if (result != '200') {
        final Map<String, dynamic> errorData = jsonDecode(result);
        setState(() {
          _addressError = errorData['address'] != null
              ? errorData['address'][0].toString()
              : '';
          _nameError =
              errorData['name'] != null ? errorData['name'][0].toString() : '';
          _descriptionError = errorData['description'] != null
              ? errorData['description'][0].toString()
              : '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Organization edited successfully!'),
            backgroundColor: Color(0xff4a23b2),
          ),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                OrganizationDetailScreen(organizationId: _organization!.id),
          ),
        );
      }
    } catch (e) {
      throw Exception(e);
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
                        'Create your organization!'.toUpperCase(),
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
                      padding: const EdgeInsets.all(8.0),
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: TextFormField(
                          controller: addressContoller,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            errorText: _addressError,
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
                      child: Container(
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
                                padding:
                                    EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
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
                              items: _city
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
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
                              value: selectedOrganizationType,
                              hint: const Padding(
                                padding:
                                    EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                child: Text(
                                  'Select organization type ',
                                  style: TextStyle(
                                    color: Color((0xffbe2b61)),
                                  ),
                                ),
                              ),
                              onChanged: (int? newValue) {
                                setState(() {
                                  selectedOrganizationType = newValue!;
                                });
                              },
                              items: _organizationType
                                  .map<DropdownMenuItem<int?>>(
                                      (OrganizationType organizationType) {
                                return DropdownMenuItem<int?>(
                                  value: organizationType.id,
                                  child: Text(
                                    organizationType.name,
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
                      padding: const EdgeInsets.all(6.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffbe2b61),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Color(0xffbb2a5f),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            _editOrganization();
                          },
                          child: const Text(
                            'Edit organization!',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      );
    }
  }
}
