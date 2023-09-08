import 'dart:convert';

import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/organization.dart';
import 'package:conferences_mobile/model/partner_type.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/network/organization_service.dart';
import 'package:conferences_mobile/network/partner_type_service.dart';
import 'package:conferences_mobile/pages/conferences/offers_for_confeerences_create.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class PartnersAddScreen extends StatefulWidget {
  final int conferenceId;
  final int conferenceDayId;
  const PartnersAddScreen(
      {required this.conferenceId, required this.conferenceDayId});
  @override
  State<PartnersAddScreen> createState() => _PartnersAddScreenState();
}

class _PartnersAddScreenState extends State<PartnersAddScreen> {
  UserModel? user;
  bool isCreatorOfConference = false;
  List<PartnerType> _partnerType = [];
  List<Organization> _organizations = [];
  int? selectedPartnerType;
  List<int> selectedIds = [];
  TextEditingController descriptionContoller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIsAutor();
    _getPartnerType();
    _getOrganizations();
  }

  Future<int> _createPartners() async {
    try {
      final response = {
        "description": descriptionContoller.text,
        'organization_id': selectedIds,
        'partner_type_id': selectedPartnerType
      };
      final jsonData = jsonEncode(response);
      String result =
          await ConferenceServise.createPartners(widget.conferenceId, jsonData);

      if (result == '200') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Partners successfully added!'),
            backgroundColor: Color(0xff4a23b2),
          ),
        );
        return 1;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Try again!'),
          ),
        );
        return 0;
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  Future<void> _checkIsAutor() async {
    await Future.delayed(Duration.zero);
    user = await AuthModel().LoggedInUser();
    int creatorId =
        await ConferenceServise.getIdOfCreatorOfConference(widget.conferenceId);

    if (user!.id == creatorId) {
      setState(() {
        isCreatorOfConference = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be creator so you can edit conference.'),
          backgroundColor: Color(0xffbe2b61),
        ),
      );
      Navigator.of(context).pushNamed('/');
    }
  }

  _getPartnerType() {
    PartnerTypeService.getPartnerTypes().then((partnerType) {
      if (mounted) {
        setState(() {
          _partnerType = partnerType;
        });
      }
    });
  }

  _getOrganizations() {
    OrganizationService.getOrganizations().then((organizations) {
      if (mounted) {
        setState(() {
          _organizations = organizations;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<MultiSelectItem<Organization>> multiSelect = _organizations
        .map((organization) =>
            MultiSelectItem<Organization>(organization, '${organization.name}'))
        .toList();
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
          body: Stack(
            children: [
              BackgroundScrollView(),
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Add partners for conference!'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.83,
                          child: MultiSelectDialogField(
                            items: multiSelect,
                            listType: MultiSelectListType.CHIP,
                            onConfirm: (values) {
                              setState(() {
                                selectedIds = values.map((e) => e.id).toList();
                              });
                            },
                            buttonText: const Text(
                              'Select',
                              style: TextStyle(color: Color(0xffbe2b61)),
                            ),
                            selectedItemsTextStyle:
                                const TextStyle(color: Colors.white),
                            backgroundColor: const Color(0xff1a1a1a),
                            title: Text(
                              'Select days of conference You want to book!',
                              style: TextStyle(
                                  color: const Color(0xff4a23b2),
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0.50, 0.50),
                                      blurRadius: 0.80,
                                      color: Colors.white.withOpacity(0.3),
                                    )
                                  ],
                                  fontWeight: FontWeight.w900),
                            ),
                            selectedColor: const Color(0xff4a23b2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xff4a23b2), width: 2.0),
                              borderRadius: BorderRadius.circular(1.0),
                              color: const Color(0xff1a1a1a),
                            ),
                            buttonIcon: const Icon(
                              Icons.arrow_downward,
                              color: Color(0xff4a23b2),
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
                                value: selectedPartnerType,
                                hint: const Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                  child: Text(
                                    'Select partner type ',
                                    style: TextStyle(
                                      color: Color((0xffbe2b61)),
                                    ),
                                  ),
                                ),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedPartnerType = newValue!;
                                  });
                                },
                                items: _partnerType.map<DropdownMenuItem<int?>>(
                                    (PartnerType partnerType) {
                                  return DropdownMenuItem<int?>(
                                    value: partnerType.id,
                                    child: Text(
                                      partnerType.name,
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
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: descriptionContoller,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SizedBox(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffbe2b61),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Color(0xffbb2a5f),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () async {
                                  int res = await _createPartners();
                                  if (res == 1) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return PartnersAddScreen(
                                            conferenceId: widget.conferenceId,
                                            conferenceDayId:
                                                widget.conferenceDayId,
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Create more partners!',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SizedBox(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffbe2b61),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Color(0xffbb2a5f),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () async {
                                  int res = await _createPartners();
                                  if (res == 1) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return UsersOffersCreateScreen(
                                            conferenceDayId:
                                                widget.conferenceDayId,
                                            conferenceId: widget.conferenceId,
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Next! Create offers',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
