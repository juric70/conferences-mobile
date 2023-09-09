import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/city.dart';
import 'package:flutter/material.dart';

class DetailCity extends StatefulWidget {
  final City city;
  const DetailCity({required this.city, super.key});

  @override
  State<DetailCity> createState() => _DetailCityState(city);
}

class _DetailCityState extends State<DetailCity> {
  final City city;
  _DetailCityState(this.city);

  @override
  void initState() {
    super.initState();
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
      body: Stack(
        children: [
          const BackgroundScrollView(),
          SingleChildScrollView(
            child: Card(
              elevation: 4,
              color: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${city.id}',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          city.name,
                        ),
                        Text(
                          '${city.state_id}',
                        ),
                        Text(
                          city.zip_code,
                        ),
                        Text(
                          city.country,
                        ),
                        Text(
                          city.country_code,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
