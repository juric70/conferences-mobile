import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:flutter/material.dart';

class Conferences extends StatelessWidget implements PreferredSizeWidget {
  const Conferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onDrawerIconPressed: () {
          // Ovdje pozivamo konstruktor klase MyDrawer i proslijeđujemo mu funkciju za otvaranje drawer-a
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
      body: Stack(
        children: [
          const BackgroundScrollView(),
          Column(children: [
            const SizedBox(
              height: 25,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 25, 25, 25),
              child: const Text(
                'Conferencssses',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            _buildTable(),
          ]),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Table(
      border: TableBorder.all(
        color: Colors.black54,
        width: 3,
      ),
      children: List.generate(4, (index) {
        return TableRow(
            children: List.generate(3, (colIndex) {
          return Container(
            alignment: Alignment.center,
            height: 50,
            color: Colors.blueAccent,
            child: Text('Row $index col $colIndex'),
          );
        }));
      }),
    );
  }

  @override
  Size get preferredSize => throw UnimplementedError();
}
