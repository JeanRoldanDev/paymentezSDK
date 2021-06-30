import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MaskedTextInputFormatter extends TextInputFormatter {
  MaskedTextInputFormatter({
    @required this.mask,
    @required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }
  final String mask;
  final String separator;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }

  static String applyFormat(String value,
      {@required String mask, @required String separator, bool force = false}) {
    var val = '';
    var newMask = mask;
    for (var i = 0; i < value.length; i++) {
      if (i < newMask.length) {
        if (newMask[i].toString() == separator.toString()) {
          newMask = newMask.replaceFirst(separator.toString(), '');
          val += separator.toString() + value[i].toString();
        } else {
          val += value[i].toString();
        }
      } else {
        if (force) {
          break;
        } else {
          val += value[i].toString();
        }
      }
    }
    return val;
  }
}

class UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
