import 'package:flutter/material.dart';
import 'package:trainer_app_flutter/app.dart';
import 'package:trainer_app_flutter/models/user_request.dart';
import '../../components/custom_text_field.dart';
import '../../components/custom_flat_button.dart';
import '../../variables.dart' as global;

class Login extends StatelessWidget {
  final List<TextEditingController> controllers = [
    new TextEditingController(),
    new TextEditingController()
  ];
  @override
  Widget build(BuildContext context) {
    final List<String> labelTitles = ['Email', 'Password'];
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            ...textFields(labelTitles, controllers),
            CustomFlatButton(
              labelTitle: 'Login',
              horizontalPadding: 10.0,
              onTap: () =>
                _onLoginTap(context, controllers)
              ,
            ),
          ],
        ),
      ),
    );
  }

  _onLoginTap(
    BuildContext context,
    List<TextEditingController> controllers,
  ) async {
    User response;
    try {
      response =
          (await UserRequest.fetchUserId(controllers.first.text)).data.first;
      global.userId = response.sId;
      Navigator.pushNamed(context, SyncingRoute);
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('The email you used does not exist'),
        ),
      );
    }
  }

  List<Widget> textFields(
    List<String> labelTitles,
    List<TextEditingController> controllers,
  ) {
    return labelTitles
        .asMap()
        .map(
          (index, labelTitle) => MapEntry(
            index,
            CustomTextField(
              labelTitle: labelTitle,
              controller: controllers[index],
            ),
          ),
        )
        .values
        .toList();
  }
}
