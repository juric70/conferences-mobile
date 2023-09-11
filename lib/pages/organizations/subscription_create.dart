import 'dart:convert';

import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/organization.dart';
import 'package:conferences_mobile/model/organizations_offer.dart';
import 'package:conferences_mobile/network/organization_service.dart';
import 'package:conferences_mobile/network/organizations_offer_service.dart';
import 'package:flutter/material.dart';

class SubscriptionCreateScreen extends StatefulWidget {
  final int organizationsOfferId;
  const SubscriptionCreateScreen(
      {super.key, required this.organizationsOfferId});

  @override
  State<SubscriptionCreateScreen> createState() =>
      _SubscriptionCreateScreenState();
}

class _SubscriptionCreateScreenState extends State<SubscriptionCreateScreen> {
  late OrganizationsOffer _organizationsOffer;
  UserModel? user;
  bool isLoggedIn = false;
  bool isLoading = true;
  List<Organization> _organizations = [];
  int? selectedOrganization;

  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus();
    _getOrganizationOffer(widget.organizationsOfferId);
  }

  void _createSubscription() async {
    final response = {
      'organizationOffer': _organizationsOffer.id,
      'organization': selectedOrganization
    };
    final jsonData = jsonEncode(response);
    int result = await OrganizationsOfferService.buySubscription(jsonData);
    if (result == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Successfully reserved your subscription, all you need to do now is to pay!'),
          backgroundColor: Color(0xff4a23b2),
        ),
      );
      Navigator.of(context).pushNamed('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong!'),
        ),
      );
    }
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
              content: Text('You must be logedin so You can buy subscription.'),
              backgroundColor: Color(0xffbe2b61),
            ),
          );
          Navigator.of(context).pushNamed('/login');
        } else {
          isLoggedIn = true;
          getOrganizationsOfUser(user!.id);
        }
      },
    );
  }

  void _getOrganizationOffer(int id) {
    OrganizationsOfferService.getOrganizationsOffer(id)
        .then((organizationOffer) {
      setState(() {
        _organizationsOffer = organizationOffer;
      });
    });
  }

  void getOrganizationsOfUser(int id) {
    OrganizationService.getOrganizationsByUser(id).then((organization) {
      setState(() {
        _organizations = organization;
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
            const BackgroundScrollView(),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffeadc48),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    _organizationsOffer.kind,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Color(0xffeadc48),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _organizationsOffer.description,
                                    style: const TextStyle(
                                      color: Color(0xffeadc48),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Nuber of conference to publish: ${_organizationsOffer.publishable_conferences} for ${_organizationsOffer.price}€',
                                    style: const TextStyle(
                                      color: Color(0xffeadc48),
                                      fontSize: 20.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  decoration: BoxDecoration(
                                    color: const Color(0XFF1A1A1A),
                                    border: Border.all(
                                      color: const Color(0xffeadc48),
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
                                              color: Color((0xffeadc48)),
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
                                                color: Color(0xffeadc48),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xffeadc48),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Color(0xffb7a915),
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      _createSubscription();
                                    },
                                    child: const Text(
                                      'Buy subscription!',
                                      style: TextStyle(
                                        color: Color(0xff2a2a2a),
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
                  )
          ]),
        ),
      );
    }
  }
}
