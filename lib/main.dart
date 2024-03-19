import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<Offset> listOfLocation = [];
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (details) {
            double loc =
                MediaQuery.of(context).size.height - constraints.maxHeight;
            listOfLocation.isEmpty
                ? setState(() {
                    isVisible = true;
                    listOfLocation.add(Offset(
                        details.globalPosition.dx, details.globalPosition.dy));
                    print("asdas");
                  })
                : null;
          },
          child: Stack(
            children: [
              Positioned(
                left: listOfLocation.isNotEmpty? listOfLocation.last.dx : 0,
                top: listOfLocation.isNotEmpty? listOfLocation.last.dy : 0,
                child: Draggable(
                    feedback: SvgPicture.asset('assets/svg/ic_cursor.svg'),
                    child: CustomPaint(
                      painter: LinePainter(loc: listOfLocation),
                      child: Visibility(
                          visible: isVisible,
                          child: SvgPicture.asset('assets/svg/ic_cursor.svg')),
                    ),
                    // onDragStarted: () {
                    //   setState(() {
                    //     isVisible = false;
                    //   });
                    // },
                    onDragEnd: (val) {
                      setState(() {
                        // double loc = MediaQuery.of(context).size.height -
                        //     constraints.maxHeight;
                        print("out painter ${val.offset.dx}");
                        listOfLocation
                            .add(Offset(val.offset.dx, val.offset.dy));
                      });
                    }),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<Offset> loc;

  LinePainter({required this.loc});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawPoints(PointMode.polygon, loc, paint);
    for(var item in loc){
      print("in painter ${item.dx}");
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
