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

class RacePermutations

  MAX_NAME = "Max"
  LEWIS_NAME = "Lewis"
  POSTION_NAME = "Position"
  NEITHER_NAME = "Neither"
  POINTS_NAME = "Points"
  FASTEST_LAP_NAME = "FastestLap"
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

puts race_one_permutations.inspect
