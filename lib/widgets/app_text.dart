import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  String? data;
  double? size;
  FontWeight? fw;
  Color? color;
  TextAlign? align;

  AppText({super.key, required this.data, this.size, this.color, this.fw, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(data.toString(),
      textAlign: align,
      style: TextStyle(color: color,
        fontSize: size,
        fontWeight: fw,
      ),
    );
  }
}
