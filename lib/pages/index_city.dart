import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/model/city.dart';
import 'package:conferences_mobile/network/city_service.dart';
import 'package:conferences_mobile/pages/detail_city.dart';
import 'package:flutter/material.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';

class IndexCity extends StatefulWidget {
  const IndexCity({super.key});

  @override
  State<IndexCity> createState() => _IndexCityState();
}

class _IndexCityState extends State<IndexCity> {
  String name = '';
  List<City> _city = [];

  @override
  void initState() {
    super.initState();
    _getCity();
  }

  _getCity() {
    CityService.getCity().then((city) {
      if (mounted) {
        // ignore: avoid_print
        print("City response: $city");
        setState(() {
          _city = city;
        });
      }
    });
  }

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
      body: SafeArea(
        child: Stack(
          children: [
            const BackgroundScrollView(),
            Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'City Data',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 25,
                ),
                cities(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Table cities() {
    return Table(
      border: const TableBorder(
        horizontalInside: BorderSide(
          width: 1,
          color: Colors.black,
        ),
      ),
      children: [
        const TableRow(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Text(
                'ID',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Text(
                'Opcije',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        for (City city in _city)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                child: Text(
                  "${city.id}",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                child: Text(
                  city.name,
                ),
              ),
              ElevatedButton(
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.pink,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailCity(
                        city: city,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
      ],
    );
  }
}
