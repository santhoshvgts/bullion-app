class Endpoints {
  // Order
  static const getAllOrders = "/order/get-all";
  static const getOrderDetails = "/order/get/<orderId>";

  // Address
  static const getAddress = "/address/get";
  static const deleteAddress = "/address/remove";
  static const addAddress = "/address/save";

  // Location
  static const getCountries = "/address/add";
  static const getStates = "/address/states";

  // Google APIs
  static const googleAutocomplete =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=<input>&key=<key>";
  static const googlePlaceDetails =
      "https://maps.googleapis.com/maps/api/place/details/json?place_id=<placeId>&key=<key>";

  //Spot Price Alerts
  static const getMarketAlertOperators = "/market-alerts/operators";
  static const addMarketAlert = "/market-alerts/add";
  static const getMarketAlerts = "/market-alerts/alerts";
  static const editMarketAlert = "/market-alerts/edit";
  static const removeSpotPriceAlert = "/market-alerts/remove?alertId=<alertId>";

  //Product Price Alerts
  static const getProductPriceAlerts =
      "/product-alerts/get-all-product-price-alerts";
  static const editPriceAlert =
      "/product-alerts/save-product-price-alert?productId=<productId>&targetPrice=<targetPrice>";
  static const removePriceAlert =
      "/product-alerts/remove-product-price-alert?productId=<productId>";

  //Alert Me
  static const getAlertMeProductAlerts =
      "/product-alerts/get-all-product-alerts";
  static const editAlertMe =
      "/product-alerts/save-product-alert?productId=<productId>&qty=<quantity>";
  static const removeAlertMe =
      "/product-alerts/remove-product-alert?productId=<productId>";

  //Favorites
  static const getFavorites = "/product-alerts/get-all-wish-lists";
  static const addFavorite = "/product-alerts/save-wish-list?productId=<productId>";
  static const removeFavorite = "/product-alerts/remove-wish-list?productId=<productId>";
}
