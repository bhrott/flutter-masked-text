import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

void main() {
  group('masked text', () {
    test('12345678901 with mask 000.000.000-00 results 123.456.789-01', () {
      var cpfController =
          new MaskedTextController(text: '12345678901', mask: '000.000.000-00');

      expect(cpfController.text, '123.456.789-01');
    });

    test(
        '12345678901 with mask 000.000.000-00 and changed results 123.456.789.01',
        () {
      var cpfController =
          new MaskedTextController(text: '12345678901', mask: '000.000.000-00');

      expect(cpfController.text, '123.456.789-01');

      cpfController.updateMask('000.000.0000-0');

      expect(cpfController.text, '123.456.7890-1');
    });

    test('abc123 with mask AAA results abc', () {
      var controller = new MaskedTextController(text: 'abc123', mask: 'AAA');

      expect(controller.text, 'abc');
    });

    test('update text to 123456 and mask 000-000 results on 123-456', () {
      var controller = new MaskedTextController(text: '', mask: '000-000');
      controller.updateText('123456');

      expect(controller.text, '123-456');
    });

    test('* must accept all characters', () {
      var controller = new MaskedTextController(text: 'a0&#', mask: '****');

      expect(controller.text, 'a0&#');
    });

    test('@ must accept only letters and numbers', () {
      var controller = new MaskedTextController(text: 'a0&#', mask: '@@@');

      expect(controller.text, 'a0');
    });

    test('remove * translator must keep * in the mask', () {
      var translator = MaskedTextController.getDefaultTranslator();
      translator.remove('*');

      var controller = new MaskedTextController(
          mask: '0000 **** **** 0000', translator: translator);
      controller.updateText('12345678');

      expect(controller.text, '1234 **** **** 5678');
    });

    test('remove * translator must keep * in the mask', () {
      var translator = MaskedTextController.getDefaultTranslator();
      translator.remove('*');

      var controller = new MaskedTextController(
          mask: '0000 **** **** 0000', translator: translator);
      controller.updateText('12345678');

      expect(controller.text, '1234 **** **** 5678');
    });
  });

  group('money mask', () {
    test('0.01 results 0,01', () {
      var controller = new MoneyMaskedTextController();
      controller.updateValue(0.01);

      expect(controller.text, '0,01');
    });

    test('1234.56 results 1.234,56', () {
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
      var controller = new MoneyMaskedTextController(
          decimalSeparator: '.', thousandSeparator: ',');
      controller.updateValue(1234.0);

      expect(controller.text, '1,234.00');
    });

    test('number value for 0,10 must be 0.1', () {
      var controller = new MoneyMaskedTextController(
          decimalSeparator: '.', thousandSeparator: ',');
      controller.updateValue(0.1);

      expect(controller.numberValue, 0.1);
    });

    test('rightSymbol " US\$" and value 99.99 must resut in 99,99 US\$', () {
      var controller = new MoneyMaskedTextController(rightSymbol: ' US\$');
      controller.updateValue(99.99);

      expect(controller.text, '99,99 US\$');
    });

    test('rightSymbol with number must raises an error.', () {
      Function executor = () {
        new MoneyMaskedTextController(rightSymbol: ' U4');
      };

      expect(executor, throwsArgumentError);
    });

    test(
        'rightSymbol " US\$" with 12345678901234 must results in 123.456.789.012,34 US\$',
        () {
      var controller = new MoneyMaskedTextController(rightSymbol: ' US\$');
      controller.updateValue(123456789012.34);

      expect(controller.text, '123.456.789.012,34 US\$');
    });

    test('leftSymbol "R\$ " and value 123.45 results in "R\$ 123,45"', () {
      var controller = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
      controller.updateValue(123.45);

      expect(controller.text, 'R\$ 123,45');
    });

    test('precision 3 and value 123.45 results in "123,450"', () {
      var controller = new MoneyMaskedTextController(precision: 3);
      controller.updateValue(123.45);

      expect(controller.text, '123,450');
    });

    test('empty value should return 0', () {
      var controller = new MoneyMaskedTextController();
      var value = controller.numberValue;
      expect(value, 0.0);

      controller = new MoneyMaskedTextController(leftSymbol: '\$');
      value = controller.numberValue;
      expect(value, 0.0);

      controller = new MoneyMaskedTextController(rightSymbol: '\$');
      value = controller.numberValue;
      expect(value, 0.0);

      controller = new MoneyMaskedTextController(rightSymbol: '\$', leftSymbol: '\$');
      value = controller.numberValue;
      expect(value, 0.0);

    });
  });
}
