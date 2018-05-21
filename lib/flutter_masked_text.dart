library flutter_masked_text;

import 'package:flutter/material.dart';

class MaskedTextController extends TextEditingController {

  MaskedTextController({ String text, this.mask }): super(text: text) {
    this.addListener((){
      this.updateText(this.text);
    });

    this.updateText(this.text);
  }

  final String mask;

  void updateText(String text) {
    this.text = this._applyMask(this.mask, text);
  }

  @override
  void set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
    }
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

      if(maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
      }
      else if (maskChar == '0') {
        if (new RegExp(r'[0-9]').hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
      }
      else if (maskChar == 'A') {
        if (new RegExp(r'[A-Za-z]').hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
      }
      else if (maskChar == '@') {
        if (new RegExp(r'[A-Za-z0-9]').hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
      }
      else if (maskChar == '*') {
        result += valueChar;
        maskCharIndex += 1;
        valueCharIndex += 1;
      }
      else {
        // not masked value, fixed char on mask
        result += maskChar;
        maskCharIndex += 1;
        continue;
      }
    }

    return result;
  }
}
