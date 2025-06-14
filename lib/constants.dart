import 'package:flutter/material.dart';
import 'package:personal_ai_app/widgets/text_widget.dart';

const Color kScaffoldBackgroundColor = Color(0xFF343541);
const Color kCardColor = Color(0xFF444654);

List<DropdownMenuItem<String>> get getModelsItem {
  List<DropdownMenuItem<String>> modelsItemList = [
    DropdownMenuItem(
      value: "Model1",
      child: TextWidget(
        label: "Model1",
      ),
    ),
    DropdownMenuItem(
      value: "Model2",
      child: TextWidget(
        label: "Model2",
      ),
    ),
    DropdownMenuItem(
      value: "Model3",
      child: TextWidget(
        label: "Model3",
      ),
    ),
    DropdownMenuItem(
      value: "Model4",
      child: TextWidget(
        label: "Model4",
      ),
    ),
  ];
  return modelsItemList;
}
