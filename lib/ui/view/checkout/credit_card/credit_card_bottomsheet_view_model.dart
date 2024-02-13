import 'package:bullion/helper/utils.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:credit_card_scanner/models/card_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';
import '../../../../../helper/card_utils.dart';

class CreditCardViewModel extends VGTSBaseViewModel {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CardType? _paymentCard = CardType.Others;

  CardType? get paymentCard => _paymentCard;

  set paymentCard(CardType? value) {
    _paymentCard = value;
  }

  int? get cvv => _paymentCard == CardType.AmericanExpress ? 4 : 3;
  String? get placeholderCvv => _paymentCard == CardType.AmericanExpress ? 'XXXX' : 'XXX';

  @override
  void dispose() {
    cardNumController.textEditingController.removeListener(_getCardTypeFrmNumber);
    cardNumController.dispose();
    notifyListeners();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(cardNumController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);

    if (cardType == CardType.AmericanExpress && _paymentCard != CardType.AmericanExpress) {
      cvvController = FormFieldController(
        const ValueKey("txtCVV"),
        validator: (value) => CardUtils.validateCVV(value, cardType == CardType.AmericanExpress ? 4 : 3),
        inputFormatter: [
          LengthLimitingTextInputFormatter(cardType == CardType.AmericanExpress ? 4 : 3),
          FilteringTextInputFormatter.deny(RegExp("[ ]{2}")),
          FilteringTextInputFormatter.deny(RegExp("[,]{2}")),
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        required: true,
        textCapitalization: TextCapitalization.sentences,
      );
    } else if (_paymentCard == CardType.AmericanExpress && cardType != CardType.AmericanExpress) {
      cvvController = FormFieldController(
        const ValueKey("txtCVV"),
        validator: (value) => CardUtils.validateCVV(value,cardType == CardType.AmericanExpress ? 4 : 3),
        inputFormatter: [
          LengthLimitingTextInputFormatter(cardType == CardType.AmericanExpress ? 4 : 3),
          FilteringTextInputFormatter.deny(RegExp("[ ]{2}")),
          FilteringTextInputFormatter.deny(RegExp("[,]{2}")),
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        required: true,
        textCapitalization: TextCapitalization.sentences,
      );
    }

    _paymentCard = cardType;
    print(cardType.name);
    notifyListeners();
  }

  void init() async {
    setBusy(true);
    cardNumController.textEditingController.addListener(_getCardTypeFrmNumber);
    setBusy(false);

    cvvController = FormFieldController(
      const ValueKey("txtCVV"),
      validator: (value) => CardUtils.validateCVV(value,cvv!),
      inputFormatter: [
        LengthLimitingTextInputFormatter(cvv),
        FilteringTextInputFormatter.deny(RegExp("[ ]{2}")),
        FilteringTextInputFormatter.deny(RegExp("[,]{2}")),
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      ],
      required: true,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  CardDetails? cardScanResponse;

  //
  FormFieldController cardNumController = FormFieldController(
    const ValueKey("txtCardNum"),
    inputFormatter: [
      FilteringTextInputFormatter.deny(RegExp("[ ]{2}")),
      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      LengthLimitingTextInputFormatter(19),
      FilteringTextInputFormatter.deny(RegExp("[,]{2}")),
      CardNumberInputFormatter(),
    ],
    required: true,
    textCapitalization: TextCapitalization.sentences,
    validator: (value) => CardUtils.validateCardNum(value),
  );

  FormFieldController expDateController = FormFieldController(
    const ValueKey("txtExpDate"),
    validator: (value) => CardUtils.validateDate(value),
    inputFormatter: [
      FilteringTextInputFormatter.deny(RegExp("[ ]{2}")),
      FilteringTextInputFormatter.deny(RegExp("[,]{2}")),
      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      LengthLimitingTextInputFormatter(6),
      CardMonthInputFormatter(),
    ],
    required: true,
    textCapitalization: TextCapitalization.sentences,
  );

  late FormFieldController cvvController;

  scanCard() async {
    cardScanResponse = await CardScanner.scanCard(
        scanOptions: const CardScanOptions(
          scanExpiryDate: true,
          enableDebugLogs: true,
          cardScannerTimeOut: 60,
        ));

    if(cardScanResponse != null){
      cardNumController.text = getCardNumber(cardScanResponse!.cardNumber);
      expDateController.text = cardScanResponse!.expiryDate;
    }

    notifyListeners();

    print(cardScanResponse.toString());
  }

  String getCardNumber(String number) {
    return "${number.substring(0,4)} ${number.substring(4, 8)} ${number.substring(8, 12)} ${number.substring(12, number.length)}";
   }

  save(BuildContext context) {
    if (formKey.currentState?.validate() != true) {
      return false;
    }

    CreditCard response = CreditCard(cardNumber: cardNumController.text,
      expirationMonth: expDateController.text.split('/')[0].toString(),
      expirationYear: expDateController.text.split('/')[1].toString(),
      cvv: cvvController.text
    );

    locator<DialogService>().dialogComplete(AlertResponse(data: response,status: true), key: const ValueKey("AddCreditCard"));
    notifyListeners();
    return true;
  }

}

class CreditCard {
  String? cardNumber;
  String? expirationMonth;
  String? expirationYear;
  String? cvv;

  CreditCard({
    this.cardNumber,
    this.expirationMonth,
    this.expirationYear,
    this.cvv
  });
}


