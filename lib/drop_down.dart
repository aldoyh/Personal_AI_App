import 'package:flutter/material.dart';
import 'package:personal_ai_app/constants/constants.dart';
import 'package:personal_ai_app/services/api_service.dart';
import 'package:personal_ai_app/widgets/text_widget.dart';

class ModelDropDownWidget extends StatefulWidget {
  @override
  State<ModelDropDownWidget> createState() => _ModelDropDownWidgetState();
}

class _ModelDropDownWidgetState extends State<ModelDropDownWidget> {
  String currentModel = 'Model1';

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
        return SizedBox(
          width: 100,
          child: DropdownButton(
            dropdownColor: kScaffoldBackgroundColor,
            iconEnabledColor: Colors.white,
            items: getModelsItem,
            value: currentModel,
            onChanged: (value) {
              setState(() {
                currentModel = value.toString();
              });
            },
          ),
        );
      },
    );
  }
}
