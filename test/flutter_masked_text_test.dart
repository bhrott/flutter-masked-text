import 'package:test/test.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

void main() {
  group('masked text', (){
    test('12345678901 with mask 000.000.000-00 resunts 123.456.789-01', () {
      var cpfController = new MaskedTextController(text: '12345678901', mask: '000.000.000-00');

      expect(cpfController.text, '123.456.789-01');
    });

    test('abc123 with mask AAA results abc', (){
      var controller = new MaskedTextController(text: 'abc123', mask: 'AAA');

      expect(controller.text, 'abc');
    });

    test('update text to 123456 and mask 000-000 results on 123-456', (){
      var controller = new MaskedTextController(text: '', mask: '000-000');
      controller.updateText('123456');

      expect(controller.text, '123-456');
    });

    test('* must accept all characters', (){
      var controller = new MaskedTextController(text: 'a0&#', mask: '****');

      expect(controller.text, 'a0&#');
    });

    test('@ must accept only letters and numbers', (){
      var controller = new MaskedTextController(text: 'a0&#', mask: '@@@');

      expect(controller.text, 'a0');
    });

    test('remove * translator must keep * in the mask', (){
      var translator = MaskedTextController.getDefaultTranslator();
      translator.remove('*');

      var controller = new MaskedTextController(mask: '0000 **** **** 0000', translator: translator);
      controller.updateText('12345678');

      expect(controller.text, '1234 **** **** 5678');
    });

    test('remove * translator must keep * in the mask', (){
      var translator = MaskedTextController.getDefaultTranslator();
      translator.remove('*');

      var controller = new MaskedTextController(mask: '0000 **** **** 0000', translator: translator);
      controller.updateText('12345678');

      expect(controller.text, '1234 **** **** 5678');
    });
  });

  group('money mask', (){
    test('0.01 results 0,01', (){
      var controller = new MoneyMaskedTextController();
      controller.updateValue(0.01);

      expect(controller.text, '0,01');
    });

    test('1234.56 results 1.234,56', (){
      var controller = new MoneyMaskedTextController();

      controller.updateValue(1234.56);

      expect(controller.text, '1.234,56');
    });

    test('123123.0 results 123.123,00', () {
      var controller = new MoneyMaskedTextController();
      controller.updateValue(123123.0);

      expect(controller.text, '123.123,00');
    });

    test('1231231.0 results 1.231.231,00', () {
      var controller = new MoneyMaskedTextController();
      controller.updateValue(1231231.0);

      expect(controller.text, '1.231.231,00');
    });

    test('custom decimal and thousando separator results in 1,234.00', () {
      var controller = new MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
      controller.updateValue(1234.0);

      expect(controller.text, '1,234.00');
    });
  });
}
