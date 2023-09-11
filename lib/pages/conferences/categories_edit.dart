import 'dart:convert';

import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/category.dart';
import 'package:conferences_mobile/model/conference_day.dart';
import 'package:conferences_mobile/network/category_service.dart';
import 'package:conferences_mobile/network/conference_day_service.dart';
import 'package:conferences_mobile/network/conference_service.dart';
import 'package:conferences_mobile/pages/conferences/conference_day_detail_for_creator.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class EditCategoriesOfConferenceDay extends StatefulWidget {
  final int conferenceId;
  final int conferenceDayId;
  const EditCategoriesOfConferenceDay(
      {super.key, required this.conferenceId, required this.conferenceDayId});

  @override
  State<EditCategoriesOfConferenceDay> createState() =>
      _EditCategoriesOfConferenceDayState();
}

class _EditCategoriesOfConferenceDayState
    extends State<EditCategoriesOfConferenceDay> {
  bool isCreatorOfConference = false;
  bool _loading = true;
  List<int> selectedIds = [];
  UserModel? user;
  List<Category> _categories = [];
  late ConferenceDay _conferenceDay;
  @override
  void initState() {
    super.initState();
    _checkIsAutor();
    _getCategories();
    _getConferenceDayDetails(widget.conferenceDayId);
  }

  void _getConferenceDayDetails(int id) {
    ConferenceDayService.getConferenceDayDetail(id).then((conferenceDay) {
      setState(() {
        _conferenceDay = conferenceDay;
        _loading = false;
      });
    });
  }

  _editCategoryInConferenceDay() async {
    try {
      final response = {'categories': selectedIds};
      final jsonData = jsonEncode(response);
      String result = await ConferenceDayService.addCategoryToConferenceDay(
          jsonData, widget.conferenceDayId);
      if (result == '200') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categories successfully added!'),
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

  _getCategories() {
    CategoryService.getCategory().then((category) {
      if (mounted) {
        setState(() {
          _categories = category;
          _loading = false;
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    List<MultiSelectItem<Category>> multiSelect = _categories
        .map((category) => MultiSelectItem<Category>(category, category.name))
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
          body: Stack(children: [
            const BackgroundScrollView(),
            _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Edit categories for conference day!'
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
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
                                    selectedIds =
                                        values.map((e) => e.id).toList();
                                  });
                                },
                                buttonText: const Text(
                                  'Select categories',
                                  style: TextStyle(color: Colors.white),
                                ),
                                selectedItemsTextStyle:
                                    const TextStyle(color: Colors.white),
                                backgroundColor: const Color(0xff1a1a1a),
                                title: Text(
                                  'Select categories for conference day!',
                                  style: TextStyle(
                                      color: const Color(0xffbe2b61),
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
                                      color: const Color(0xffbe2b61),
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(1.0),
                                  color: const Color(0xff1a1a1a),
                                ),
                                buttonIcon: const Icon(
                                  Icons.arrow_downward,
                                  color: Color(0xffbe2b61),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.83,
                                height: 50.0,
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
                                    int res =
                                        await _editCategoryInConferenceDay();
                                    if (res == 1) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ConferencesDayShowDetails(
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
                                    '  Add categories!  ',
                                  ),
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
