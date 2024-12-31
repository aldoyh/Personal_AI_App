import 'package:flutter/material.dart';
import 'package:personal_ai_app/constants.dart';
import 'package:personal_ai_app/api_service.dart';
import 'package:personal_ai_app/text_widget.dart';

class ModelDropDownWidget extends StatefulWidget {
  const ModelDropDownWidget({super.key});

  @override
  State<ModelDropDownWidget> createState() => _ModelDropDownWidgetState();
}

class _ModelDropDownWidgetState extends State<ModelDropDownWidget> {
  String currentModel = 'Model 1';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiService.getModels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextWidget(
                label: snapshot.error.toString(),
              ),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? SizedBox.shrink()
              : DropdownButton(
                  dropdownColor: kScaffoldBackgroundColor,
                  iconEnabledColor: Colors.white,
                  items: getModelsItem,
                  value: currentModel,
                  onChanged: (value) {
                    setState(() {
                      currentModel = value.toString();
                    });
                  },
                );
        });
  }
}
