import 'package:flutter/material.dart';
import 'package:personal_ai_app/constants/constants.dart';
import 'package:personal_ai_app/widgets/drop_down.dart';
import 'package:personal_ai_app/widgets/text_widget.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: kScaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TextWidget(
                  label: "Chosen Model:",
                ),
              ),
              Flexible(
                flex: 2,
                child: ModelDropDownWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}
