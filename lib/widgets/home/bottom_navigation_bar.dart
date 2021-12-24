import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int pageOverride;
  final Function(int) pageChangeCallback;
  BottomNavBar(this.pageChangeCallback, {required this.pageOverride});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentSelection = 0;

  bool _firstBuild = true;

  void _callback(int index) {
    _firstBuild = false;

    setState(() => _currentSelection = index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageOverride != _currentSelection) {
      _callback(widget.pageOverride);
    }

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: <Widget>[
            BottomNavigationBarTab(
                0, _currentSelection, _callback, widget.pageChangeCallback,
                title: 'Home', icon: Icons.home, isInitial: _firstBuild),
            BottomNavigationBarTab(
                1, _currentSelection, _callback, widget.pageChangeCallback,
                title: 'Clients', icon: Icons.people),
            BottomNavigationBarTab(
                2, _currentSelection, _callback, widget.pageChangeCallback,
                title: 'Revenue', icon: Icons.attach_money),
            BottomNavigationBarTab(
                3, _currentSelection, _callback, widget.pageChangeCallback,
                title: 'Schedule', icon: Icons.schedule),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
      color: Theme.of(context).cardColor,
    );
  }
}

class BottomNavigationBarTab extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool? isInitial;
  final int index;
  final int currentSelection;
  final Function(int) callback;
  final Function(int) pageChangeCallback;
  BottomNavigationBarTab(
    this.index,
    this.currentSelection,
    this.callback,
    this.pageChangeCallback, {
    required this.title,
    required this.icon,
    this.isInitial,
  });

  @override
  _BottomNavigationBarTabState createState() => _BottomNavigationBarTabState();
}

class _BottomNavigationBarTabState extends State<BottomNavigationBarTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _backgroundColor;
  late Animation<Color?> _foreColor;
  late Animation<double> _widthFactor;
  late Animation<Color?> _iconColor;
  late Animation<double> _iconSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 150,
      ),
    );

    _backgroundColor = ColorTween(
            begin: Colors.transparent,
            end: Theme.of(context).primaryColor.withOpacity(.5))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
          ..addListener(() => setState(() {}));

    _widthFactor = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _foreColor = ColorTween(
            begin: Color(0xffc4c4c4), end: Theme.of(context).primaryColor)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _iconSize = Tween<double>(begin: 26.0, end: 20.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _iconColor = ColorTween(
            begin: Color(0xffc4c4c4), end: Theme.of(context).primaryColor)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.isInitial != null) {
      if (widget.isInitial == true) {
        _controller.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentSelection != widget.index && _controller.value != 0) {
      _controller.reverse();
    } else if (widget.currentSelection == widget.index &&
        _controller.value == 0) {
      _controller.forward();
    }
    return GestureDetector(
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  widget.icon,
                  color: _iconColor.value,
                  size: _iconSize.value,
                ),
              ),
              ClipRect(
                child: Align(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: _foreColor.value,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  widthFactor: _widthFactor.value,
                ),
              ),
            ],
          ),
        ),
        height: 50.0,
        decoration: BoxDecoration(
          color: _backgroundColor.value,
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onTap: () => widget.pageChangeCallback(widget.index),
    );
  }
}
