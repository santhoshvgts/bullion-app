
import 'package:bullion/locator.dart';
import 'package:bullion/services/appconfig_service.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/payment/payment_gateway_service.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

class PlaidService {

  Function(LinkSuccess)? onSuccessCallback;
  Function(LinkEvent)? onEventCallback;
  Function(LinkExit)? onExitCallback;

  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final AppConfigService _appConfigService = locator<AppConfigService>();
  final PaymentGatewayService _paymentGatewayApi = locator<PaymentGatewayService>();

  Plaid? get plaid => _appConfigService.config!.plaid;

  LinkEnvironment get _linkEnvironment {
    switch(plaid!.environment){
      case "sandbox":
        return LinkEnvironment.sandbox;
      case "development":
        return LinkEnvironment.development;
      case "production":
        return LinkEnvironment.production;
      default:
        return LinkEnvironment.production;
    }
  }

  PlaidService({this.onSuccessCallback, this.onEventCallback, this.onExitCallback});

  openPublicKey(){
    PlaidLink _plaidPublicKey;

    LegacyLinkConfiguration publicKeyConfiguration = LegacyLinkConfiguration(
      clientName: "Apmex",
      publicKey: _appConfigService.config!.plaid!.publicKey!,
      environment: _linkEnvironment,
      products: <LinkProduct>[
        LinkProduct.auth,
      ],
      language: "en",
      countryCodes: ['US'],
      accountSubtypes: <LinkAccountSubtype>[
        const LinkAccountSubtype(type: "depository",subtype: "checking"),
        const LinkAccountSubtype(type: "depository",subtype: "savings"),
      ],
      userLegalName: _authenticationService.getUser!.firstName,
      userEmailAddress: _authenticationService.getUser!.email,
    );

    PlaidLink.onSuccess.listen(onSuccessCallback!);
    PlaidLink.onEvent.listen(onEventCallback!);
    PlaidLink.onExit.listen(onExitCallback!);
    PlaidLink.open(configuration: publicKeyConfiguration);
  }

  openLinkToken() async {
    String token = await _paymentGatewayApi.getPlaidLinkToken();

    LinkConfiguration linkTokenConfiguration = LinkTokenConfiguration(
      token: token,
    );

    PlaidLink.onSuccess.listen(onSuccessCallback!);
    PlaidLink.onEvent.listen(onEventCallback!);
    PlaidLink.onExit.listen(onExitCallback!);
    PlaidLink.open(configuration: linkTokenConfiguration);
  }

}