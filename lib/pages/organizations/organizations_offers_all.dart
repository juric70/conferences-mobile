import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/organizations_offer.dart';
import 'package:conferences_mobile/network/organizations_offer_service.dart';
import 'package:conferences_mobile/pages/organizations/subscription_create.dart';
import 'package:flutter/material.dart';

class OrganizationsOfferScreen extends StatefulWidget {
  const OrganizationsOfferScreen({super.key});

  @override
  State<OrganizationsOfferScreen> createState() =>
      _OrganizationsOfferScreenState();
}

class _OrganizationsOfferScreenState extends State<OrganizationsOfferScreen> {
  List<OrganizationsOffer> _organizationOffers = [];
  bool isLoaded = true;

  _getOrganizationsOffers() {
    OrganizationsOfferService.getOrganizationsOffers()
        .then((organizationsOffer) {
      setState(() {
        _organizationOffers = organizationsOffer;
        isLoaded = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getOrganizationsOffers();
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width - 50;
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
          isLoaded
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Offers for organisations!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        for (OrganizationsOffer orgOffer in _organizationOffers)
                          Container(
                            height: 220.0,
                            width: cardWidth,
                            margin:
                                const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                            decoration: BoxDecoration(
                              color: const Color(0xff1a1a1a).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                  color: Color(0xff4924b6), width: 2.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 218.0,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 35.0,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            orgOffer.kind,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            18.0, 5.0, 8.0, 0.0),
                                        width: cardWidth * 0.98,
                                        height: 60.0,
                                        child: Text(
                                          orgOffer.description,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                          ),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            18.0, 10.0, 8.0, 0.0),
                                        width: cardWidth * 0.98,
                                        child: Text(
                                          'Number of publishable conferences: ${orgOffer.publishable_conferences}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                          ),
                                          maxLines: 4,
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            18.0, 10.0, 8.0, 0.0),
                                        width: cardWidth * 0.98,
                                        child: Text(
                                          'Price: ${orgOffer.price}€',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                          ),
                                          maxLines: 4,
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubscriptionCreateScreen(
                                                          organizationsOfferId:
                                                              orgOffer.id),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.black,
                                              backgroundColor:
                                                  const Color(0xff1a1a1a),
                                              side: const BorderSide(
                                                color: Color(0xff4924b6),
                                                width: 2.0,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    15.0), // Ovdje postavite željeni radijus
                                              ),
                                            ),
                                            child: const Text(
                                              'Buy now!',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
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
