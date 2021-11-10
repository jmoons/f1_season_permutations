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

RACE_PERMUTATION_INITIALIZATION_MAX_POINTS_KEY = "max_initial_points"
RACE_PERMUTATION_INITIALIZATION_LEWIS_POINTS_KEY = "lewis_initial_points"
MAX_NAME = "Max"
LEWIS_NAME = "Lewis"
POSTION_NAME = "Position"
NEITHER_NAME = "Neither"
POINTS_NAME = "Points"
FASTEST_LAP_NAME = "FastestLap"

class RacePermutations

  POINTS_PER_POSITION = { 1 => 25, 2 => 18, 3 => 15, 4 => 12, 5 => 10, 6 => 8, 7 => 6, 8 => 4, 9 => 2, 10 => 1 }
  POINTS_FOR_FASTEST_LAP = 1

  def initialize( initial_points_hash )
    @max_initial_points = initial_points_hash[RACE_PERMUTATION_INITIALIZATION_MAX_POINTS_KEY]
    @lewis_initial_points = initial_points_hash[RACE_PERMUTATION_INITIALIZATION_LEWIS_POINTS_KEY]
  end

  def execute_permutations

    results = {}
    result_count = 0

    (1..11).each do | max_position |
      (1..11).each do | lewis_position |
        next if max_position == lewis_position
        (1..3).each do | fastest_lap_winner |
          # Here is a race result, record Max and Lewis's finishing position
          result_count += 1
          results[result_count] = { (MAX_NAME + POSTION_NAME) => max_position }
          results[result_count][ (LEWIS_NAME + POSTION_NAME) ] = lewis_position

          # Update Max point total
          if max_position <= 10
            results[result_count][ (MAX_NAME + POINTS_NAME) ] = ( @max_initial_points + POINTS_PER_POSITION[max_position] )
          else
            results[result_count][ (MAX_NAME + POINTS_NAME) ] = @max_initial_points
          end

          # Update Lewis point total
          if lewis_position <=10
            results[result_count][ (LEWIS_NAME + POINTS_NAME) ] = ( @lewis_initial_points + POINTS_PER_POSITION[lewis_position] )
          else
            results[result_count][ (LEWIS_NAME + POINTS_NAME) ] = @lewis_initial_points
          end

          case fastest_lap_winner
          when 1
            # Max won the fastest lap!
            results[result_count].store( FASTEST_LAP_NAME, MAX_NAME)

            # And gets a bonus point!
            results[result_count][ (MAX_NAME + POINTS_NAME) ] += 1 if max_position <= 10

          when 2
            # Lewis won the fastest lap!
            results[result_count].store( FASTEST_LAP_NAME, LEWIS_NAME)

            # And gets a bonus point!
            results[result_count][ (LEWIS_NAME + POINTS_NAME) ] += 1 if lewis_position <= 10

          when 3
            # Neither Max nor Lewis won the fastest lap!
            results[result_count].store( FASTEST_LAP_NAME, NEITHER_NAME)
          end
        end
      end
    end

    results
  end
end

race_one_permutations = RacePermutations.new( {RACE_PERMUTATION_INITIALIZATION_MAX_POINTS_KEY => 312.5, RACE_PERMUTATION_INITIALIZATION_LEWIS_POINTS_KEY => 293.5} ).execute_permutations

race_two_results = {}
race_two_count = 0
race_one_permutations.each_pair do | permutation, result |
  race_two_count += 1
  race_two_results[race_two_count] = RacePermutations.new( {RACE_PERMUTATION_INITIALIZATION_MAX_POINTS_KEY => result[ (MAX_NAME + POINTS_NAME) ], RACE_PERMUTATION_INITIALIZATION_LEWIS_POINTS_KEY => result[ (LEWIS_NAME + POINTS_NAME) ]} ).execute_permutations
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