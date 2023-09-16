class AppFontSize {
  static const double smallest = 10;
  static const double small = 12;
  static const double normal = 14;
  static const double large = 15;
  static const double medium = 16;
  static const double largest = 18;
  static const double  xlarge= 17;
  static const double xLargest = 19;

  static const double dp10 = 10;
  static const double dp12 = 12;
  static const double dp14 = 14;
  static const double dp16 = 16;
  static const double dp18 = 18;
  static const double dp20 = 20;

  static double titleByValue(String type){
    switch(type){
      case "mini":
        return dp14;
      case "small":
        return dp16;
      case "large":
        return dp20;
      case "medium":
        return dp18;
      default:
        return dp18;
    }
  }

  static double subtitleByValue(String type){
    switch(type){
      case "mini":
        return dp12;
      case "small":
        return dp14;
      case "large":
        return dp18;
      case "medium":
        return dp16;
      default:
        return dp16;
    }
  }

  static double bodyTitleByValue(String type){
    switch(type){
      case "mini":
        return dp12;
      case "small":
        return dp14;
      case "large":
        return dp18;
      case "medium":
        return dp16;
      default:
        return dp16;
    }
  }

  static double bodyContentByValue(String type){
    switch(type){
      case "mini":
        return dp10;
      case "small":
        return dp12;
      case "large":
        return dp16;
      case "medium":
        return dp14;
      default:
        return dp14;
    }
  }
}
