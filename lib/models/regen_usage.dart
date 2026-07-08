const int dailyRegenCreditLimit = 5;

class RegenUsage {
  final int creditsUsed;
  final bool profileBonusUsed;

  const RegenUsage({this.creditsUsed = 0, this.profileBonusUsed = false});

  int get creditsRemaining =>
      (dailyRegenCreditLimit - creditsUsed).clamp(0, dailyRegenCreditLimit);

  bool get hasCredits => creditsUsed < dailyRegenCreditLimit;

  RegenUsage copyWith({int? creditsUsed, bool? profileBonusUsed}) => RegenUsage(
        creditsUsed: creditsUsed ?? this.creditsUsed,
        profileBonusUsed: profileBonusUsed ?? this.profileBonusUsed,
      );

  Map<String, dynamic> toJson() => {
        'creditsUsed': creditsUsed,
        'profileBonusUsed': profileBonusUsed,
      };

  factory RegenUsage.fromJson(Map<String, dynamic> json) => RegenUsage(
        creditsUsed: json['creditsUsed'] as int? ?? 0,
        profileBonusUsed: json['profileBonusUsed'] as bool? ?? false,
      );
}
