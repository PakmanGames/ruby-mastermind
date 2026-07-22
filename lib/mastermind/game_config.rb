# frozen_string_literal: true

# Immutable value object describing the dimensions of a single game:
# how many pegs the secret code has and how many turns the code breaker
# gets. It is passed into Game so that every collaborator (Board, the code
# generators, and the players) agrees on the same code length.
#
# The bounds exist to keep a game *completable*: codes shorter than
# MIN_CODE_LENGTH are trivial to brute-force, and codes longer than
# MAX_CODE_LENGTH (the size of the colour palette) get unwieldy to display.
# The turn bounds keep even the hardest allowed code winnable without making
# short codes tediously forgiving.
class GameConfig
  MIN_CODE_LENGTH = 4
  MAX_CODE_LENGTH = 8
  MIN_TURN_LIMIT = 8
  MAX_TURN_LIMIT = 14
  DEFAULT_CODE_LENGTH = 4
  DEFAULT_TURN_LIMIT = 12

  attr_reader :code_length, :turn_limit

  # @param code_length [Integer] pegs per code, within MIN/MAX_CODE_LENGTH
  # @param turn_limit [Integer] guesses allowed, within MIN/MAX_TURN_LIMIT
  # @raise [ArgumentError] if either value falls outside its allowed range
  def initialize(code_length: DEFAULT_CODE_LENGTH, turn_limit: DEFAULT_TURN_LIMIT)
    validate!('Code length', code_length, MIN_CODE_LENGTH, MAX_CODE_LENGTH)
    validate!('Turn limit', turn_limit, MIN_TURN_LIMIT, MAX_TURN_LIMIT)
    @code_length = code_length
    @turn_limit = turn_limit
  end

  # Advisory floor on turns for a given code length. Longer codes need more
  # deductions to crack, so the suggestion scales with length while staying
  # inside the allowed turn range. Purely a hint: any in-range turn limit is
  # still permitted.
  #
  # @param code_length [Integer]
  # @return [Integer] the recommended minimum number of turns
  def self.suggested_min_turns(code_length)
    (code_length + 4).clamp(MIN_TURN_LIMIT, MAX_TURN_LIMIT)
  end

  # Interactively collects a code length and turn limit from the player,
  # each validated against its allowed range.
  #
  # @return [GameConfig] the configuration chosen by the player
  def self.collect
    code_length = collect_code_length
    turn_limit = collect_turn_limit(code_length)
    new(code_length:, turn_limit:)
  end

  # @return [Integer] the chosen code length, within the allowed range
  def self.collect_code_length
    prompt_in_range(
      "\nHow many colors long should the secret code be?",
      MIN_CODE_LENGTH,
      MAX_CODE_LENGTH
    )
  end

  # Surfaces a non-binding suggestion so a player does not pick a turn limit
  # that leaves the chosen code length effectively unwinnable.
  #
  # @param code_length [Integer] the already-chosen code length
  # @return [Integer] the chosen turn limit, within the allowed range
  def self.collect_turn_limit(code_length)
    suggested = suggested_min_turns(code_length)
    puts "\nFor a code length of #{code_length}, we suggest at least #{suggested} turns to keep it winnable."
    prompt_in_range('How many turns should the code breaker get?', MIN_TURN_LIMIT, MAX_TURN_LIMIT)
  end

  # Prompts until the player enters an integer within [min, max].
  # On end-of-input (gets returns nil) it falls back to min rather than
  # looping forever, so a closed stdin can never hang the game.
  #
  # @param question [String] the prompt shown to the player
  # @param min [Integer] the lowest accepted value
  # @param max [Integer] the highest accepted value
  # @return [Integer] the chosen value
  def self.prompt_in_range(question, min, max)
    loop do
      puts "#{question} (#{min}-#{max})"
      input = gets
      return min if input.nil?

      choice = input.strip.to_i
      return choice if choice.between?(min, max)

      puts "Please enter a number between #{min} and #{max}."
    end
  end

  private

  def validate!(label, value, min, max)
    return if value.is_a?(Integer) && value.between?(min, max)

    raise ArgumentError, "#{label} must be an integer between #{min} and #{max} (got #{value.inspect})"
  end
end
