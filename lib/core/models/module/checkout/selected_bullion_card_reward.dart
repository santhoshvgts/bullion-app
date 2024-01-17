class SelectedBullionCardReward {
  String? formattedRewardBalanceInPoints;
  String? formattedRewardBalanceInCurrency;
  int? rewardBalanceInCurrency;
  double? estRewardsOnOrder;
  String? formattedEstRewardsOnOrder;
  bool? isBullionCardCustomer;
  bool? isBullionCardSelected;
  bool? showRewardsSection;

  SelectedBullionCardReward(
      {this.formattedRewardBalanceInPoints,
        this.formattedRewardBalanceInCurrency,
        this.rewardBalanceInCurrency,
        this.estRewardsOnOrder,
        this.formattedEstRewardsOnOrder,
        this.isBullionCardCustomer,
        this.isBullionCardSelected,
        this.showRewardsSection});

  SelectedBullionCardReward.fromJson(Map<String, dynamic> json) {
    formattedRewardBalanceInPoints = json['formatted_reward_balance_in_points'];
    formattedRewardBalanceInCurrency =
    json['formatted_reward_balance_in_currency'];
    rewardBalanceInCurrency = json['reward_balance_in_currency'];
    estRewardsOnOrder = json['est_rewards_on_order'];
    formattedEstRewardsOnOrder = json['formatted_est_rewards_on_order'];
    isBullionCardCustomer = json['is_bullion_card_customer'];
    isBullionCardSelected = json['is_bullion_card_selected'];
    showRewardsSection = json['show_rewards_section'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formatted_reward_balance_in_points'] =
        this.formattedRewardBalanceInPoints;
    data['formatted_reward_balance_in_currency'] =
        this.formattedRewardBalanceInCurrency;
    data['reward_balance_in_currency'] = this.rewardBalanceInCurrency;
    data['est_rewards_on_order'] = this.estRewardsOnOrder;
    data['formatted_est_rewards_on_order'] = this.formattedEstRewardsOnOrder;
    data['is_bullion_card_customer'] = this.isBullionCardCustomer;
    data['is_bullion_card_selected'] = this.isBullionCardSelected;
    data['show_rewards_section'] = this.showRewardsSection;
    return data;
  }
}
