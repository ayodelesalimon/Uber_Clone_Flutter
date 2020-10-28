import 'package:flutter/material.dart';
import 'package:uber_clone/resources/brand_colors.dart';

class TaxiButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPressed;

  const TaxiButton({Key key, this.title, this.color, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        height: 50,
        minWidth: 300,
        child: Text(
          title,
          style: TextStyle(color: BrandColors.colorAccent1),
        ),
        color: color,
       onPressed: onPressed,);
  }
}
