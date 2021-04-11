import 'dart:html';

import 'package:flutter/material.dart';
import 'package:heramo_training_system/ui/training_centre.dart';
import 'package:heramo_training_system/viewmodels/CoursesViewModel.dart';
import 'package:heramo_training_system/viewmodels/UserViewModel.dart';
import 'package:provider/provider.dart';
import 'utils/constant.dart';
import 'utils/strings.dart' as Strings;
import 'utils/dimens.dart' as Dimens;
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..backgroundColor = Colors.amber
    ..indicatorColor = Colors.brown
    ..textColor = Colors.brown
    ..maskColor = Colors.amber.withOpacity(0.5)
    ..userInteractions = true
    ..errorWidget = Icon(Icons.error_sharp)
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserViewModel()),
          ChangeNotifierProvider(create: (_) => CoursesViewModel(),)
        ],
        child: MaterialApp(
          title: Strings.app_title,
          theme: ThemeData(
            primarySwatch: Colors.amber,
          ),
          home: MyHomePage(title: Strings.app_title),
          builder: EasyLoading.init(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  TextEditingController nameEt = new TextEditingController();
  TextEditingController refEt = new TextEditingController();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Role _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          titleTextStyle: Theme.of(context).textTheme.headline6,
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(minWidth: 250, maxWidth: 800),
            margin: EdgeInsets.all(Dimens.margin_8x),
            padding: EdgeInsets.all(Dimens.margin_8x),
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.circular(Dimens.margin_3x)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTextField(
                    key: "name",
                    label: Strings.label_name,
                    hint: Strings.label_name_hint),
                _buildTextField(
                    key: "ref",
                    label: Strings.label_ref,
                    hint: Strings.label_ref_hint),
                _buildRoleSelector(),
                _buildSubmitButton()
              ],
            ),
          ),
        ));
  }

  Widget _buildTextField({String key, String label, String hint}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimens.margin_x),
      child: TextFormField(
          controller: key.compareTo('name') == 0 ? widget.nameEt : widget.refEt,
          key: Key(key),
          decoration: InputDecoration(labelText: label, hintText: hint)),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: Dimens.margin_3x),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Text(Strings.label_roles,
                  style: TextStyle(fontWeight: FontWeight.w500)),
              flex: 2,
              fit: FlexFit.tight,
            ),
            Flexible(
                flex: 8,
                child: DropdownButton<Role>(
                  value: _selectedRole,
                  onChanged: (newSelected) {
                    setState(() {
                      _selectedRole = newSelected;
                    });
                  },
                  hint: Text(Strings.label_roles_hint),
                  items: Role.values.map((Role role) {
                    return DropdownMenuItem(
                        value: role, child: Text(role.name));
                  }).toList(),
                ))
          ],
        ));
  }

  Widget _buildSubmitButton() {
    return Consumer<UserViewModel>(
      builder: (context, model, child) {
        if (model.isLoading) {
          EasyLoading.show(status: Strings.submit_loading);
        } else if (model.error.isNotEmpty) {
          EasyLoading.showError(model.error);
        } else {
          EasyLoading.dismiss();
        }

        return Container(
            width: Dimens.widget_width,
            margin: EdgeInsets.symmetric(vertical: Dimens.margin_2x),
            child: ElevatedButton(
                onPressed: model.isLoading
                    ? null
                    : () => _onSubmitButtonClicked(context),
                child: Text(
                  Strings.button_submit,
                  style: Theme.of(context).textTheme.button,
                )));
      },
    );
  }

  void _onSubmitButtonClicked(BuildContext context) async {
    final result = await context
        .read<UserViewModel>()
        .login(widget.nameEt.text, widget.refEt.text, _selectedRole.id);
    if (result != null && result.isNotEmpty) {
      context.read<CoursesViewModel>().addCourses(result);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>TrainingCentre()));
    }
  }
}
