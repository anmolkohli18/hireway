import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DocumentStructure extends StatelessWidget {
  DocumentStructure({Key? key}) : super(key: key);

  final List<String> folderNames = ["Product", "Sales", "Marketing", "General"];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [for (var name in folderNames) folderWidget(name)],
    );
  }

  Widget folderWidget(String name) {
    const String folderSvgName = "assets/colored_folder.svg";
    final Widget folderSvg = SvgPicture.asset(folderSvgName);

    return Column(
      children: [
        SizedBox(width: 200, height: 120, child: folderSvg),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        )
      ],
    );
  }
}
