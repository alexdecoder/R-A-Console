import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final String label;
  final Function onTap;
  final bool? disabled;
  LargeButton(this.label, {required this.onTap, this.disabled});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Material(
        child: InkWell(
          child: Container(
            child: Row(
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: disabled ?? false
                        ? Colors.white38
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          onTap: disabled ?? false ? null : onTap as void Function()?,
        ),
        color: disabled ?? false
            ? Colors.white10
            : Theme.of(context).primaryColor.withOpacity(.5),
      ),
      borderRadius: BorderRadius.circular(15.0),
    );
  }
}
