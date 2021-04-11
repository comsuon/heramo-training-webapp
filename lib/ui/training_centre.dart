import 'dart:developer';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:heramo_training_system/network/model/course.dart';
import 'package:heramo_training_system/utils/dimens.dart';
import 'package:heramo_training_system/viewmodels/CoursesViewModel.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../utils/strings.dart' as Strings;

class TrainingCentre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CoursesViewModel viewModel = context.watch<CoursesViewModel>();
    viewModel.courses.forEach((element) {
      print(element.coursename);
    });
    return Scaffold(
      body: Center(child: _buildTrainingCourses(context, viewModel.courses)),
    );
  }

  Widget _buildTrainingCourses(BuildContext context, List<Course> courses) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final course = courses[index];
        return TimelineTile(
          indicatorStyle: course.completed
              ? IndicatorStyle(
                  width: 30,
                  height: 30,
                  color: Colors.green,
                  iconStyle:
                      IconStyle(iconData: Icons.check, color: Colors.white))
              : IndicatorStyle(
                  width: 30,
                  height: 30,
                  color: Colors.blue,
                ),
          afterLineStyle: LineStyle(color: Colors.blue),
          beforeLineStyle: LineStyle(color: Colors.blue),
          isFirst: index == 0,
          isLast: index == courses.length - 1,
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          startChild: _buildCourseId(course.id.toString()),
          endChild: _buildCourseDetails(context, course),
        );
      },
      itemCount: courses.length,
    );
  }

  Widget _buildCourseId(String courseId) {
    return Container(
      alignment: const Alignment(0.8, 0.0),
      child: Text(
        courseId,
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
    );
  }

  Widget _buildCourseDetails(BuildContext context, Course course) {
    print(course.coursename);
    return Container(
        padding: EdgeInsetsDirectional.only(start: margin_4x),
        margin: EdgeInsets.symmetric(vertical: margin_2x),
        child: Column(children: <Widget>[
          Container(
            alignment: const Alignment(-1.0, 0.0),
            margin: EdgeInsets.only(bottom: margin_2x),
            child: Text(course.coursename,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 22)),
          ),
          Row(
            children: <Widget>[
              Container(
                height: 30,
                width: 120,
                margin: EdgeInsetsDirectional.only(end: margin_2x),
                child: ElevatedButton(
                  onPressed: () {
                    html.window.open(course.courseLink, 'new tab');
                  },
                  child: Text(Strings.button_see_content),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.amber[700]),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))),
                ),
              ),
              Visibility(
                child: Container(
                  height: 30,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(course.completed
                        ? Strings.button_test_done
                        : Strings.button_test_do_test),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            course.completed
                                ? Colors.green[300]
                                : Colors.amber[700]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ))),
                  ),
                ),
                visible: course.courseTestLink.isNotEmpty,
              )
            ],
          )
        ]));
  }
}
