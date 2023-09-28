
import 'package:bullion/services/shared/api_model/request_settings.dart';
import 'package:bullion/services/shared/request_method.dart';

class SpotPriceRequest {

  static RequestSettings fetchSpotPrice() {
    return RequestSettings("/spot-prices/spot-prices", RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings fetchSpotPriceDayChart() {
    return RequestSettings("/spot-prices/spot-prices-with-day-chart", RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings fetchSpotPricePortfolioDayChart() {
    return RequestSettings("/spot-prices/spot-prices-with-day-chart-and-portfolio", RequestMethod.GET, params: null, authenticated: true);
  }

}

