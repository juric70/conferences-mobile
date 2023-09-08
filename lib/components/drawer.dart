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
        backgroundColor: const Color(0xFF2A2A2A),
        shadowColor: const Color(0xFF4924b6),
        width: 150.0,
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
              child: const SizedBox(
                height: 60.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF1A1A1A)),
                  margin: EdgeInsets.zero,
                  child: Text(
                    'CONFERENCES',
                    style: TextStyle(color: Colors.white),
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
                'Conferences create',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Close the drawer
                Navigator.pop(context);

                // Navigate to the '/conferences' page
                Navigator.pushNamed(context, '/conferencesCreate');
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
            ListTile(
              title: const Text(
                'Create day',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/conferenceDayCreate');
              },
            ),
            const Divider(
              color: Color(0xFF4924b6),
              height: 2,
              thickness: 3,
            ),
            ListTile(
              title: const Text(
                'Create organization',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/organizationsCreate');
              },
            ),
            const Divider(
              color: Color(0xFF4924b6),
              height: 2,
              thickness: 3,
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
            ListTile(
              title: const Text(
                'Conferences',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onDrawerIconPressed();
              },
            ),
          ],
        ));
  }

  Size get preferredSize => throw UnimplementedError();
}
