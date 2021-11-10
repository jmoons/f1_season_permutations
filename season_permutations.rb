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
POINTS_FOR_FASTEST_LAP = 1

results = {}
result_count = 0

(1..11).each do | max_position |
  (1..11).each do | lewis_position |
    next if ( max_position < 11 && lewis_position < 11 && max_position == lewis_position )
    (1..3).each do | fastest_lap_winner |
      # Here is a race result, record Max and Lewis's finishing position
      result_count += 1
      results[result_count] = { (MAX_NAME + POSTION_NAME) => max_position }
      results[result_count].store( (LEWIS_NAME + POSTION_NAME), lewis_position )
      case fastest_lap_winner
      when 1
        # Max won the fastest lap!
        results[result_count].store( FASTEST_LAP_NAME, MAX_NAME)
        # Now update point totals (TBD)
        results[result_count].store( (MAX_NAME + POINTS_NAME), 1 )
        results[result_count].store( (LEWIS_NAME + POINTS_NAME), 1 )

      when 2
        # Lewis won the fastest lap!
        results[result_count].store( FASTEST_LAP_NAME, LEWIS_NAME)
        # Now update point totals (TBD)
        results[result_count].store( (MAX_NAME + POINTS_NAME), 1 )
        results[result_count].store( (LEWIS_NAME + POINTS_NAME), 1 )

      when 3
        # Neither Max nor Lewis won the fastest lap!
        results[result_count].store( FASTEST_LAP_NAME, NEITHER_NAME)
        # Now update point totals (TBD)
        results[result_count].store( (MAX_NAME + POINTS_NAME), 1 )
        results[result_count].store( (LEWIS_NAME + POINTS_NAME), 1 )
      end
    end
  end
end

puts results.inspect