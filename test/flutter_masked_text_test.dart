import 'package:test/test.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

void main() {
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
}
