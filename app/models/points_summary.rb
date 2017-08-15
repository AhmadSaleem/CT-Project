class PointsSummary < ApplicationRecord
  validates :format, :scoring_area, presence: true, uniqueness: { scope: [:format, :scoring_area], message: "Points are already assigned to this field"}
  validates :points, presence: true
  enum format: {
    T20: 1,
    ODI: 2,
    Test: 3,
  }

  enum scoring_area: {
    run:                       1,
    strike_rate_200:           2,
    strike_rate:               3,
    duck:                      4,
    golden_duck:               5,
    diamond_duck:              6,
    wicket:                    7,
    maiden_over:               8,
    run_out:                   9,
    stump:                     10,
    catch:                     11,
    wk_catck:                  12,
    retired_hurt:              13,
    fifty:                     14,
    hundred:                   15,
    hundred_fifty:             16,
    double_hundred:            17,
    two_hundred_fifty:         18,
    four_wickets:              19,
    five_wickets:              20,
    six_wickets:               21,
    seven_wickets:             22,
    four_wk_dismissals:        23,
    fielding_dismissals:       24,
    man_of_the_match:          25,
    strike_rate_200_or_more:   26,
    strike_rate_150_199:       27,
    strike_rate_125_149:       28,
    strike_rate_100_124:       29,
    strike_rate_80_99:         30,
    rpo_3_or_Less:             31,
    rpo_3_to_4:                32,
    rpo_O_4_to_6:              33,
    rpo_O_6_to_7:              34,
    rpo_O_7_to_10:             35,
    rpo_10_or_greater:         36

  }
end
