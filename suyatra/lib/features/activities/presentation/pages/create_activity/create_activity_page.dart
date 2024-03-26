import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/utils/date_formats.dart';
import 'package:suyatra/widgets/card_widget.dart';
import 'package:suyatra/widgets/custom_list_tile.dart';

class CreateActivityPage extends StatefulWidget {
  const CreateActivityPage({super.key});

  @override
  State<CreateActivityPage> createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  late final TextEditingController _activityNameController;
  late final TextEditingController _destinationController;
  late final TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _activityNameController = TextEditingController();
    _destinationController = TextEditingController();
    _budgetController = TextEditingController();
  }

  @override
  void dispose() {
    _activityNameController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create an activity"),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {

            },
            child: const Text(
              "Save",
              style: TextStyle(
                fontSize: h8,
                fontWeight: FontWeight.w600,
                color: grey70,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 80.0,
                  width: 80.0,
                  decoration: const BoxDecoration(
                    color: grey30,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/camera_add.svg",
                    height: 48.0,
                    width: 48.0,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                const SizedBox(width: 16.0),
                Flexible(
                  child: TextField(
                    controller: _activityNameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter activity name",
                      hintStyle: TextStyle(
                        fontSize: h7,
                        fontWeight: FontWeight.w600,
                        color: grey40,
                      )
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            CardWidget(
              hasMargin: false,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0
                    ),
                    decoration: const BoxDecoration(
                      color: whiteColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Destination",
                          style: TextStyle(
                            fontSize: h9,
                            color: grey70,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        IntrinsicWidth(
                          child: TextField(
                            controller: _destinationController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Destination",
                              hintStyle: TextStyle(
                                fontSize: h9,
                                fontWeight: FontWeight.w500,
                                color: lightGrey,
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  _customListTile(
                    onTap: () {

                    },
                    headingText: "Category",
                    trailingText: "Arts & Culture"
                  ),
                  const SizedBox(height: 2.0),
                  _customListTile(
                    onTap: () {
                      
                    },
                    headingText: "Activity type",
                    trailingText: "Group"
                  ),
                  const SizedBox(height: 2.0),
                  _customListTile(
                    onTap: () {
                      
                    },
                    headingText: "Currency",
                    trailingText: "USD"
                  ),
                  const SizedBox(height: 2.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0
                    ),
                    decoration: const BoxDecoration(
                      color: whiteColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Budget (optional)",
                          style: TextStyle(
                            fontSize: h9,
                            color: grey70,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        IntrinsicWidth(
                          child: TextField(
                            controller: _budgetController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "0.00",
                              hintStyle: TextStyle(
                                fontSize: h9,
                                fontWeight: FontWeight.w500,
                                color: lightGrey,
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            CardWidget(
              hasMargin: false,
              child: Column(
                children: [
                  _customListTile(
                    headingText: "Start",
                    trailingText: formatDateInLanguageOnlyMonth(DateTime.now().toLocal().toString()),
                    onTap: () {

                    }
                  ),
                  _customListTile(
                    headingText: "End",
                    trailingText: formatDateInLanguageOnlyMonth(DateTime.now().toLocal().toString()),
                    onTap: () {
                      
                    }
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _customListTile({
    required String headingText,
    String? trailingText,
    void Function()? onTap,
  }) {
    return CustomListTile(
      hasRadius: false,
      title: Text(
        headingText,
        style: const TextStyle(
          fontSize: h9,
          color: grey70,
        ),
      ),
      trailingText: trailingText,
      trailingTextStyle: const TextStyle(
        fontSize: h9,
        fontWeight: FontWeight.w500,
        color: grey90,
      ),
      trailingIconColor: grey90,
      onTap: onTap,
    );
  }
}