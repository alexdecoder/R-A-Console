import 'package:flutter/material.dart';

class ClientHeader extends StatelessWidget {
  final void Function(String) textChangedCallback;
  final bool isSearching;

  ClientHeader({required this.textChangedCallback, required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            'Clients',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ClientHeaderSearch(
            textChangedCallback: textChangedCallback, isSearching: isSearching),
      ],
    );
  }
}

class ClientHeaderSearch extends StatelessWidget {
  final Function(String) textChangedCallback;
  final bool isSearching;

  ClientHeaderSearch(
      {required this.textChangedCallback, required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 45.0, top: 7.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 11.0),
                  hintText: 'Search client directory',
                  hintStyle: TextStyle(
                      color: Colors.white38, fontWeight: FontWeight.w400),
                ),
                style: TextStyle(
                    color: Colors.white.withOpacity(.7),
                    fontWeight: FontWeight.w500),
                cursorColor: Theme.of(context).primaryColor,
                onChanged: textChangedCallback,
              ),
            ),
            Visibility(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 24.0,
                  width: 24.0,
                ),
              ),
              visible: isSearching,
            ),
            Padding(
              padding: EdgeInsets.only(right: 25.0),
              child: Icon(
                Icons.search,
                size: 30.0,
                color: Colors.white38,
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.05),
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
      ),
    );
  }
}
