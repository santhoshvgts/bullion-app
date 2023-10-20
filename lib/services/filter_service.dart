class FilterService {
  String? _spotPriceTag;
  String? _marketNewsTag;
  String? _dealsTag;
  String? _alertMetal;

  String? get marketNewsTag {
    alertMetal = _marketNewsTag;
    return _marketNewsTag ?? "all";
  }

  String? get spotPriceTag {
    alertMetal = _spotPriceTag;
    return _spotPriceTag ?? "gold";
  }

  String get dealsTag {
    alertMetal = _dealsTag;
    return _dealsTag ?? "all";
  }

  String get alertMetal => _alertMetal ?? "gold";

  set marketNewsTag(String? value) {
    _marketNewsTag = value;
    alertMetal = value;
  }

  set spotPriceTag(String? value) {
    _spotPriceTag = value;
    alertMetal = value;
  }

  set dealsTag(String value) {
    _dealsTag = value;
    alertMetal = value;
  }

  set alertMetal(String? value) =>
      _alertMetal = value == "all" ? "gold" : value;
}
