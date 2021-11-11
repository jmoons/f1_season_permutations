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
POINTS_PER_POSITION = { 1 => 25, 2 => 18, 3 => 15, 4 => 12, 5 => 10, 6 => 8, 7 => 6, 8 => 4, 9 => 2, 10 => 1, 11 => 0 }
POINTS_FOR_FASTEST_LAP = 1
MAX_STARTING_POINTS = 312.5
LEWIS_STARTING_POINTS = 293.5

RACE_POSITIONS_TO_SIMULATE = (1..POINTS_PER_POSITION.length)
QUALIFYING_POSITIONS_TO_SIMULATE = (1..QUALIFYING_POINTS.length)


class RacePermutations

  attr_reader :results

  def initialize( initial_points_hash )
    @max_initial_points = initial_points_hash[MAX_INITIAL_POINTS]
    @lewis_initial_points = initial_points_hash[LEWIS_INITIAL_POINTS]
    @results = execute_permutations
  end

  def self.analyze_results( race_results, display_text = "No Display Text Defined" )
    max_leading_instances = 0
    lewis_leading_instances = 0
    tied_number_instances = 0
    total_number_of_instances = 0
    race_results.flatten.each do | race_result |

      total_number_of_instances += 1
      max_leading_instances += 1 if race_result[(MAX_NAME + POINTS_NAME)] > race_result[(LEWIS_NAME + POINTS_NAME)]
      lewis_leading_instances += 1 if race_result[(MAX_NAME + POINTS_NAME)] < race_result[(LEWIS_NAME + POINTS_NAME)]
      tied_number_instances += 1 if race_result[(MAX_NAME + POINTS_NAME)] == race_result[(LEWIS_NAME + POINTS_NAME)]
    end
    puts "===================#{display_text}==================="
    puts "Total Number of Instances: #{total_number_of_instances}"
    puts "Max Leading: #{max_leading_instances} (#{((max_leading_instances.to_f / total_number_of_instances) * 100).round(5)})"
    puts "Lewis Leading: #{lewis_leading_instances} (#{((lewis_leading_instances.to_f / total_number_of_instances) * 100).round(5)})"
    puts "Tied!: #{tied_number_instances} (#{( (tied_number_instances.to_f / total_number_of_instances) * 100).round(5)})"
    puts "========================================================="
  end

  private

  def execute_permutations

    results = []

    RACE_POSITIONS_TO_SIMULATE.each do | max_position |
      RACE_POSITIONS_TO_SIMULATE.each do | lewis_position |
        next if ( (max_position == lewis_position) && (max_position < 11) && (lewis_position < 11) )

        [ MAX_NAME, LEWIS_NAME, NEITHER_NAME ].each do | fastest_lap_winner |
          # Here is a race result, record Max and Lewis's finishing position
          individual_result = { (MAX_NAME + POSTION_NAME) => max_position }
          individual_result.store( (LEWIS_NAME + POSTION_NAME), lewis_position )

          # Record who won the fastest lap
          individual_result.store( FASTEST_LAP_NAME, fastest_lap_winner )

          # Update Max point total including fastest lap if applicable
          individual_result.store( (MAX_NAME + POINTS_NAME), ( @max_initial_points + POINTS_PER_POSITION[max_position] ) )
          individual_result[ (MAX_NAME + POINTS_NAME) ] += 1 if ( fastest_lap_winner == MAX_NAME && max_position <= 10 )

          # Update Lewis point total including fastest lap if applicable
          individual_result.store( (LEWIS_NAME + POINTS_NAME), ( @lewis_initial_points + POINTS_PER_POSITION[lewis_position] ) )
          individual_result[ (LEWIS_NAME + POINTS_NAME) ] += 1 if ( fastest_lap_winner == LEWIS_NAME && lewis_position <= 10 )

          results << individual_result
        end
      end
    end

    results
  end
end

# Work through possible Brazil outcomes. 
# Brazil has a Sprint Qualifying format which awards points to the 1st, 2nd, and 3rd places.
# Because of this, there are 13 possible permutations of the points that Max and Lewis will respectively
# start the race with.
brazil_results = []
QUALIFYING_POSITIONS_TO_SIMULATE.each do | max_qualifying_result |
  QUALIFYING_POSITIONS_TO_SIMULATE.each do | lewis_qualifying_result |
    next if ( (max_qualifying_result == lewis_qualifying_result) && (max_qualifying_result < 4) && (lewis_qualifying_result < 4) )
    # Get possible results from this starting Position
    brazil_results << RacePermutations.new( { MAX_INITIAL_POINTS => (MAX_STARTING_POINTS + QUALIFYING_POINTS[max_qualifying_result]),
                                              LEWIS_INITIAL_POINTS => (LEWIS_STARTING_POINTS + QUALIFYING_POINTS[lewis_qualifying_result])
                                            } ).results
  end
end

puts RacePermutations.analyze_results(brazil_results, "Brazil Results")

abu_dhabi_results = []
brazil_results.flatten.each do | brazil_result |
  # Get possible results from this starting Position
  abu_dhabi_results << RacePermutations.new( { MAX_INITIAL_POINTS => brazil_result[(MAX_NAME + POINTS_NAME)],
                                              LEWIS_INITIAL_POINTS => brazil_result[(LEWIS_NAME + POINTS_NAME)]
                                            } ).results
end

puts RacePermutations.analyze_results(abu_dhabi_results, "Season Results")