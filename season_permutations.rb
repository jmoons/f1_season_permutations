# Data Model
# {
#   1 => {
#     "MaxPosition" => 1,
#     "LewisPosition" => 2,
#     "FastestLap" => "Max",
#     "MaxPoints" => 1,
#     "LewisPoints" => 1,
#   },
#   2 => {
#     "MaxPosition" => 1,
#     "LewisPosition" => 2,
#     "FastestLap" => ""Lewis",
#     "MaxPoints" => 1,
#     "LewisPoints" => 1,
#   }
#   3 => {
#     "MaxPosition" => 1,
#     "LewisPosition" => 2,
#     "FastestLap" => "Neither",
#     "MaxPoints" => 1,
#     "LewisPoints" => 1,
#   }
# }

# New Data Model - array of hashes, each hash containing a race outcome
# [
#   {
#     "MaxPosition" => 1,
#     "LewisPosition" => 2,
#     "FastestLap" => "Max",
#     "MaxPoints" => 1,
#     "LewisPoints" => 1,
#   }
# ]

MAX_INITIAL_POINTS = "MaxInitialPoints"
LEWIS_INITIAL_POINTS = "LewisInitialPoints"
MAX_NAME = "Max"
LEWIS_NAME = "Lewis"
POSTION_NAME = "Position"
NEITHER_NAME = "Neither"
POINTS_NAME = "Points"
FASTEST_LAP_NAME = "FastestLap"
QUALIFYING_POINTS = {1 => 3, 2 => 2, 3 => 1, 4 => 0}
MAX_STARTING_POINTS = 312.5
LEWIS_STARTING_POINTS = 293.5
RACE_POSITIONS_TO_SIMULATE = (1..11)


class RacePermutations

  POINTS_PER_POSITION = { 1 => 25, 2 => 18, 3 => 15, 4 => 12, 5 => 10, 6 => 8, 7 => 6, 8 => 4, 9 => 2, 10 => 1 }
  POINTS_FOR_FASTEST_LAP = 1

  def initialize( initial_points_hash )
    @max_initial_points = initial_points_hash[MAX_INITIAL_POINTS]
    @lewis_initial_points = initial_points_hash[LEWIS_INITIAL_POINTS]
  end

  def execute_permutations

    results = {}
    result_count = 0

    RACE_POSITIONS_TO_SIMULATE.each do | max_position |
      RACE_POSITIONS_TO_SIMULATE.each do | lewis_position |
        next if ( (max_position == lewis_position) && (max_position < 11) && (lewis_position < 11) )

        [ MAX_NAME, LEWIS_NAME, NEITHER_NAME ].each do | fastest_lap_winner |
          # Here is a race result, record Max and Lewis's finishing position
          result_count += 1
          results[result_count] = { (MAX_NAME + POSTION_NAME) => max_position }
          results[result_count][ (LEWIS_NAME + POSTION_NAME) ] = lewis_position

          # Record who won the fastest lap
          results[result_count].store( FASTEST_LAP_NAME, fastest_lap_winner)

          # Update Max point total including fastest lap if applicable
          if max_position <= 10
            results[result_count][ (MAX_NAME + POINTS_NAME) ] = ( @max_initial_points + POINTS_PER_POSITION[max_position] )
            results[result_count][ (MAX_NAME + POINTS_NAME) ] += 1 if fastest_lap_winner == MAX_NAME
          else
            results[result_count][ (MAX_NAME + POINTS_NAME) ] = @max_initial_points
          end

          # Update Lewis point total including fastest lap if applicable
          if lewis_position <=10
            results[result_count][ (LEWIS_NAME + POINTS_NAME) ] = ( @lewis_initial_points + POINTS_PER_POSITION[lewis_position] )
            results[result_count][ (LEWIS_NAME + POINTS_NAME) ] += 1 if fastest_lap_winner == LEWIS_NAME
          else
            results[result_count][ (LEWIS_NAME + POINTS_NAME) ] = @lewis_initial_points
          end

        end
      end
    end

    results
  end
end

qualifying_permutations = {}
qualifying_permutation  = 0
(1..4).each do | max_qualifying_result |
  (1..4).each do | lewis_qualifying_result |
    next if ( (max_qualifying_result == lewis_qualifying_result) && (max_qualifying_result < 4) && (lewis_qualifying_result < 4) )
    qualifying_permutation += 1
    qualifying_permutations[qualifying_permutation]= {(MAX_NAME + POSTION_NAME) => max_qualifying_result, (LEWIS_NAME + POSTION_NAME) => lewis_qualifying_result}
    qualifying_permutations[qualifying_permutation].store(MAX_INITIAL_POINTS, (MAX_STARTING_POINTS + QUALIFYING_POINTS[max_qualifying_result]))
    qualifying_permutations[qualifying_permutation].store(LEWIS_INITIAL_POINTS, (LEWIS_STARTING_POINTS + QUALIFYING_POINTS[lewis_qualifying_result]))
  end
end

race_one_permutations = {}
race_one_permutation_count = 0
qualifying_permutations.each_pair do |qualifying_permutation_number, qualifying_permutation|
  race_one_permutation_count += 1
  race_one_permutations[race_one_permutation_count] = RacePermutations.new( {MAX_INITIAL_POINTS => qualifying_permutation[MAX_INITIAL_POINTS], LEWIS_INITIAL_POINTS => qualifying_permutation[LEWIS_INITIAL_POINTS]} ).execute_permutations
end

# Now we have race one - 13 possible starting points for Lewis and max, each producing 330 race finishing point totals

race_two_results = {}
race_two_count = 0
race_one_permutations.each_value do | race_one_permutation |
  race_one_permutation.each_value do | race_one_result |
    race_two_count += 1
    race_two_results[race_two_count] = RacePermutations.new( {MAX_INITIAL_POINTS => race_one_result[ (MAX_NAME + POINTS_NAME) ], LEWIS_INITIAL_POINTS => race_one_result[ (LEWIS_NAME + POINTS_NAME) ]} ).execute_permutations
  end
end

total_number_of_samples = 0
max_wins = 0
lewis_wins = 0
tie_wins = 0
race_two_results.each_pair do | permutation, result |

  result.each_pair do | per, res |
    total_number_of_samples += 1
    max_wins += 1 if res[ (MAX_NAME + POINTS_NAME) ] > res[ (LEWIS_NAME + POINTS_NAME) ]
    lewis_wins += 1 if res[ (LEWIS_NAME + POINTS_NAME) ] > res[ (MAX_NAME + POINTS_NAME) ]
    tie_wins += 1 if res[ (MAX_NAME + POINTS_NAME) ] == res[ (LEWIS_NAME + POINTS_NAME) ]
    # puts res.inspect if res[ (MAX_NAME + POINTS_NAME) ] == res[ (LEWIS_NAME + POINTS_NAME) ]
  end
end

puts "total_number_of_samples: #{total_number_of_samples}"
puts "Max Wins Championship: #{max_wins}, (#{( (max_wins.to_f / total_number_of_samples) * 100 ).round(5)}%)"
puts "Lewis Wins Championship: #{lewis_wins}, (#{( (lewis_wins.to_f / total_number_of_samples) * 100 ).round(5)}%)"
puts "Tied Championship Points: #{tie_wins}, (#{( (tie_wins.to_f / total_number_of_samples) * 100 ).round(5)}%)"