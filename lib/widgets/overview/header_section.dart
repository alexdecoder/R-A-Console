import 'package:flutter/material.dart';
import 'package:ra_console/models/general_info.dart';

class OverviewHeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: Column(
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: 'Hello there, ',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white38
                    : Colors.black38,
                fontSize: 24.0,
                fontWeight: FontWeight.w300,
                fontFamily: 'Montserrat',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: firstName! + '!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'The revenue over the last seven days was',
                    style: TextStyle(
                      color: Colors.white38,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '\$' + previousSeven!.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 50.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
