import 'package:flutter/material.dart';
import 'package:masked_text_sample/flutter_masked_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SafeArea(
        child: new Scaffold(
          body: new Column(
            children: <Widget>[
              _brPhoneInput(),
              _moneyInput()
            ],
          ),
        ),
      ),
    );
  }

  Widget _brPhoneInput() {
    var controller = new MaskedTextController(mask: '(00) 0000-0000');

    controller.beforeChange = (String previous, String next) {
      if (next.length > 14) {
        controller.updateMask('(00) 00000-0000');
      }
      else {
        controller.updateMask('(00) 0000-0000');
      }

      return true;
    };

    controller.afterChange = (String previous, String next) {
      print("$previous | $next");
    };

    return new TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: 'Phone'
        )
    );
  }

  Widget _moneyInput() {
    var controller = new MoneyMaskedTextController();

    controller.afterChange = (String masked, double raw) {
      print("$masked | $raw");
    };

    return new TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: 'Money'
        )
    );
  }
}
