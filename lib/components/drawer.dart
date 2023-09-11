import 'package:conferences_mobile/model/auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onDrawerIconPressed;
  const MyDrawer({required this.onDrawerIconPressed, super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus();
  }

  Future<void> _checkLoggedInStatus() async {
    await Future.delayed(Duration.zero);
    UserModel? user = await AuthModel().LoggedInUser();
    setState(() {
      if (user == null) {
        isLoggedIn = false;
      } else {
        isLoggedIn = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Color(0xff2a2a2a).withOpacity(0.98),
        shadowColor: const Color(0xFF4924b6),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                height: 60.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF1A1A1A)),
                  margin: EdgeInsets.zero,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: Color(0xFF4924b6),
              height: 0,
              thickness: 3,
            ),
            ListTile(
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/');
              },
            ),
            const Divider(
              color: Color(0xFF4924b6),
              height: 2,
              thickness: 3,
            ),
            ListTile(
              title: const Text(
                'Events',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/conferences');
              },
            ),
            const Divider(
              color: Color(0xFF4924b6),
              height: 2,
              thickness: 3,
            ),
            ListTile(
              title: const Text(
                'Organizations offers',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/organizationsOffers');
              },
            ),
            const Divider(
              color: Color(0xFF4924b6),
              height: 2,
              thickness: 3,
            ),
            if (isLoggedIn == true)
              Column(
                children: [
                  ListTile(
                    title: const Text(
                      'My tickets',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/bookedTickets');
                    },
                  ),
                  const Divider(
                    color: Color(0xFF4924b6),
                    height: 2,
                    thickness: 3,
                  ),
                  ListTile(
                    title: const Text(
                      'My organizations',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/myorganizations');
                    },
                  ),
                  const Divider(
                    color: Color(0xFF4924b6),
                    height: 2,
                    thickness: 3,
                  ),
                  ListTile(
                    title: const Text(
                      'My conferences',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/conferencesForCreator');
                    },
                  ),
                  const Divider(
                    color: Color(0xFF4924b6),
                    height: 2,
                    thickness: 3,
                  ),
                ],
              ),
            if (isLoggedIn == true)
              ListTile(
                title: const Text(
                  'LogOut',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/logout');
                },
              )
            else
              ListTile(
                title: const Text(
                  'Log in!',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/login');
                },
              ),
            const Divider(
              color: Color(0xFF4924b6),
              height: 2,
              thickness: 3,
            ),
          ],
        ));
  }

  Size get preferredSize => throw UnimplementedError();
}
