import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/organization.dart';
import 'package:conferences_mobile/network/organization_service.dart';
import 'package:conferences_mobile/pages/organizations/organization_details.dart';
import 'package:flutter/material.dart';

class ShowUsersOrganizationsScreen extends StatefulWidget {
  const ShowUsersOrganizationsScreen({super.key});

  @override
  State<ShowUsersOrganizationsScreen> createState() =>
      _ShowUsersOrganizationsScreenState();
}

class _ShowUsersOrganizationsScreenState
    extends State<ShowUsersOrganizationsScreen> {
  bool isLoggedIn = false;
  bool isLoading = true;
  UserModel? user;
  List<Organization> _organizations = [];

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
          getOrganizationsOfUser(user!.id);
        }
      },
    );
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
                              'My organizations!'.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Organizations',
                                  style: TextStyle(
                                      color: Color(0xffeadc48),
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'See more',
                                  style: TextStyle(
                                      color: Color(0xffeadc48),
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Color(0xFF4924b6),
                            height: 1.0,
                            thickness: 2.0,
                          ),
                          for (Organization organization in _organizations)
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      organization.name,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17.0),
                                    ),
                                    Container(
                                      height: 30.0,
                                      width: 50.0,
                                      color: const Color(0xff2a2a2a),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OrganizationDetailScreen(
                                                      organizationId:
                                                          organization.id),
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
                    Navigator.of(context).pushNamed('/organizationsCreate');
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
