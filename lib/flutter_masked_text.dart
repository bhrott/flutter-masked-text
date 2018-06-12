library flutter_masked_text;

import 'package:flutter/material.dart';
import 'dart:math';

class MaskedTextController extends TextEditingController {

  MaskedTextController({ String text, this.mask, Map<String, RegExp> translator }): super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    this.addListener((){
      this.updateText(this.text);
    });

    this.updateText(this.text);
  }

  final String mask;

  Map<String, RegExp> translator;

  void updateText(String text) {
    this.text = this._applyMask(this.mask, text);
  }

  @override
  void set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      this.selection = new TextSelection.fromPosition(new TextPosition(offset: (newText ?? '').length));
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return {
      'A': new RegExp(r'[A-Za-z]'),
      '0': new RegExp(r'[0-9]'),
      '@': new RegExp(r'[A-Za-z0-9]'),
      '*': new RegExp(r'.*')
    };
  }

  String _applyMask(String mask, String value) {
    String result = '';

    var maskCharIndex = 0;
    var valueCharIndex = 0;

    while(true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      var maskChar = mask[maskCharIndex];
      var valueChar = value[valueCharIndex];

      // value equals mask, just set
      if(maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (this.translator.containsKey(maskChar)) {
        if (this.translator[maskChar].hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}

class MoneyMaskedTextController extends TextEditingController {

  MoneyMaskedTextController({ double initialValue = 0.0, this.decimalSeparator = ',', this.thousandSeparator = '.' }) {
    this.addListener((){
      this.updateValue(this.numberValue);
    });

		this.updateValue(initialValue);
  }

  final String decimalSeparator;
  final String thousandSeparator;

  final int _maxLength = 19;

  void updateValue(double value) {
  	String masked = this._applyMask(value);

  	if (masked != this.text) {
  		this.text = masked;
		}
  }

  double get numberValue =>
  	double.parse(
			_getSanitizedText(this.text)
		) / 100.0;

	@override
  set text(String newText) {
    if (newText.length <= this._maxLength) {
      super.text = newText;
    }
    else {
      super.text = newText.substring(0, this._maxLength);
    }

    this.selection = new TextSelection.fromPosition(new TextPosition(offset: super.text.length));
  }

  String _getSanitizedText(String text) {
	  String cleanedText = text;

	  var valuesToSanitize = [
	    this.thousandSeparator,
      this.decimalSeparator
    ];

	  valuesToSanitize.forEach((val){
	    cleanedText = cleanedText.replaceAll(val, '');
    });

    var onlyNumbersRegex = new RegExp(r'[^\d]');

    cleanedText = cleanedText.replaceAll(onlyNumbersRegex, '');

    return cleanedText;
  }

  String _applyMask(double value) {
    String textRepresentation = value.toStringAsFixed(2).replaceAll('.', this.decimalSeparator);

    List<String> numberParts = [];

    for(var i = 0; i < textRepresentation.length; i++) {
      numberParts.add(textRepresentation[i]);
    }

    const lengthsWithThousandSeparators = [6, 10, 14, 18];

    for (var i = 0; i < lengthsWithThousandSeparators.length; i++) {
      var l = lengthsWithThousandSeparators[i];

      if (numberParts.length > l) {
        numberParts.insert(numberParts.length - l, this.thousandSeparator);
      }
      else {
        break;
      }
    }

    return numberParts.join('');
  }
}
