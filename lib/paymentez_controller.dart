import 'package:paymentez_sdk/utils/utils_browser.dart';

export 'utils/utils_browser.dart';

class PaymentezController {
  PaymentezController({required this.isProd})
      : _utils = UtilsBrowser(isProd: isProd);

  final bool isProd;

  final UtilsBrowser _utils;
  void Function()? _onSave;
  void Function()? _onOther;

  UtilsBrowser get utils => _utils;

  void addListeners({
    void Function()? onSave,
    void Function()? onOther,
  }) {
    _onSave = onSave;
    _onOther = _onOther;
  }

  void onSave() {
    _onSave?.call();
  }

  void onOther() {
    _onOther?.call();
  }
}
