import 'package:bullion/core/models/base_model.dart';

class User extends BaseModel {
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? postedDate;
  bool? showAssets;
  int? orderCount;
  String? formattedRewardBalanceInCurrency;
  String? applyBullionUrl;
  bool? isGuestAccount;
  bool? showBullionCard;
  bool? showclubStatus;
  bool? isBullionCardMember;
  String? welcomeMessage;
  String? clubStatus;
  String? clubImage;

  String get fullName => "${firstName ?? '' + lastName!}";

  User(
      {this.userId,
      this.firstName,
      this.lastName,
      this.email,
      this.postedDate});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    postedDate = json['posted_date'];
    applyBullionUrl = json['apply_for_bullion_card_url'];
    formattedRewardBalanceInCurrency = json['formatted_reward_balance_in_currency'];
    showBullionCard = json['show_bullion_card'] ?? false;
    showclubStatus = json['show_club_status'] ?? false;
    isBullionCardMember = json['is_bullion_card_member'] ?? false;
    isGuestAccount = json['is_guest_account'] is String ? json['is_guest_account'] == "true" : json['is_guest_account'];

    welcomeMessage =  json['welcome_message'];
    clubStatus =  json['club_status'];
    clubImage = json['club_image'];
    showAssets = json['show_assets'];
    orderCount = json['order_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['posted_date'] = this.postedDate;
    data['is_guest_account'] = this.isGuestAccount;
    data['formatted_reward_balance_in_currency'] = this.formattedRewardBalanceInCurrency;
    data['apply_for_bullion_card_url'] = this.applyBullionUrl;
    data['show_bullion_card'] = this.showBullionCard;
    data['show_club_status'] = this.showclubStatus;

    data['welcome_message'] = this.welcomeMessage;
    data['club_status'] = this.clubStatus;
    data['club_image'] = this.clubImage;
    data['show_assets'] = this.showAssets;
    data['order_count'] = this.orderCount;
    return data;
  }

  @override
  String toString() {
    return 'User{userId: $userId, firstName: $firstName, lastName: $lastName, email: $email, postedDate: $postedDate, formattedRewardBalanceInCurrency: $formattedRewardBalanceInCurrency, isGuestAccount: $isGuestAccount, isBullionCardMember: $isBullionCardMember,welcome_message : $welcomeMessage, club_status : $clubStatus, club_image : $clubImage, show_assets : $showAssets, order_count : $orderCount}';
  }
}
