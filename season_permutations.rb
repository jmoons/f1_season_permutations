# Data Model
# {
#   1 => {
#     "MaxPosition" => 1,
#     "LewisPosition" => 1,
#     "FastestLap" => "Max" | "Lewis" | "Neither",
#     "MaxPoints" => 1,
#     "LewisPoints" => 1,
#   }
# }

MAX_NAME = "Max"
LEWIS_NAME = "Lewis"
POSTION_NAME = "Position"
NEITHER_NAME = "Neither"
POINTS_NAME = "Points"
FASTEST_LAP_NAME = "FastestLap"
POINTS_PER_POSITION = { 1 => 25, 2 => 18, 3 => 15, 4 => 12, 5 => 10, 6 => 8, 7 => 6, 8 => 4, 9 => 2, 10 => 1 }

results = {}
result_count = 1

(1..11).each do | max_position |
  (1..11).each do | lewis_position |
    next if ( max_position < 11 && lewis_position < 11 && max_position == lewis_position )
    (1..3).each do | fastest_lap_winner |
      case fastest_lap_winner
      when 1
        results[result_count] = { (MAX_NAME + POSTION_NAME) => max_position,
                                  (LEWIS_NAME + POSTION_NAME) => lewis_position,
                                  FASTEST_LAP_NAME => MAX_NAME,
                                  (MAX_NAME + POINTS_NAME) => 1,
                                  (LEWIS_NAME + POINTS_NAME) => 1
                                }
      when 2
        results[result_count] = { (MAX_NAME + POSTION_NAME) => max_position,
                                  (LEWIS_NAME + POSTION_NAME) => lewis_position,
                                  FASTEST_LAP_NAME => LEWIS_NAME,
                                  (MAX_NAME + POINTS_NAME) => 1,
                                  (LEWIS_NAME + POINTS_NAME) => 1
                                }
      when 3
        results[result_count] = { (MAX_NAME + POSTION_NAME) => max_position,
                                  (LEWIS_NAME + POSTION_NAME) => lewis_position,
                                  FASTEST_LAP_NAME => NEITHER_NAME,
                                  (MAX_NAME + POINTS_NAME) => 1,
                                  (LEWIS_NAME + POINTS_NAME) => 1
                                }
      end
      result_count += 1
    end
  end
end

puts results.inspect