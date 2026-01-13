# Ruby Mastermind Game

A console based game of Mastermind written in Ruby. The game utilizes the rainbow gem to create colourful output in the terminal.

Learn how to play mastermind click [here](https://www.wikihow.com/Play-Mastermind).  
For those who would rather prefer a TikTok brainrot video version click [here](https://www.youtube.com/watch?v=EF2oeSnTYgY) to learn more.

## Running the Game

```bash
# Make sure required gems are installed on your system
bundle install

# Run the project
bundle exec bin/mastermind
```

Information about the dependencies can be found in the `Gemfile`.

## Running with Docker (Cross-Platform)

The project is dockerized and works on Windows, Linux, and macOS. Make sure you have [Docker](https://www.docker.com/get-started) installed.

```bash
# Build the Docker image
docker build -t ruby-mastermind .

# Run the game interactively (one-off container)
docker run -it --rm ruby-mastermind

# Or run with docker-compose (one-off container)
docker-compose run --rm mastermind
```

**Note:** The `-it` flags are required for interactive terminal input/output, which the game needs.

(Note: Without Docker, running the project requires a Unix-based operating system or WSL)

## Running the Tests

The project uses RSpec for testing. To run the test suite:

```bash
# Run all tests
bundle exec rspec

# Run tests with documentation format
bundle exec rspec --format documentation

# Run a specific test file
bundle exec rspec spec/mastermind/game_spec.rb
```

### Running Tests with Docker

```bash
# Run tests in Docker
docker run -it --rm ruby-mastermind bundle exec rspec

# Or with docker-compose
docker-compose run --rm mastermind bundle exec rspec
```

All test files are located in the `spec/` directory, mirroring the structure of the `lib/` directory.

## Project Structure

```text
ruby-mastermind/
├── bin/
│   └── mastermind      # Executable entry point for the game
├── lib/
│   ├── mastermind.rb   # Main module file
│   └── mastermind/     # Core game classes
│       ├── board.rb            # Board class - manages game board and moves
│       ├── code.rb             # Code class - represents a code with 4 colors
│       ├── code_generator.rb   # CodeGenerator class - generates random codes
│       ├── computer_player.rb  # ComputerPlayer class - computer-controlled player
│       ├── game_display.rb     # GameDisplay module - generates messages into the CLI
│       ├── game.rb             # Game class - main game logic and flow
│       ├── human_player.rb     # HumanPlayer class - human-controlled player
│       ├── pins.rb             # Pins module - generates feedback pins
│       ├── player.rb           # Player class - abstract base class for players
│       └── secret_code.rb      # SecretCode class - handles secret code generation
├── spec/
│   ├── mastermind/     # Test files for game classes
│   │   ├── board_spec.rb
│   │   ├── code_generator_spec.rb
│   │   ├── code_spec.rb
│   │   ├── computer_player_spec.rb
│   │   ├── game_display_spec.rb
│   │   ├── game_spec.rb
│   │   ├── human_player_spec.rb
│   │   ├── pins_spec.rb
│   │   ├── player_spec.rb
│   │   └── secret_code_spec.rb
│   └── spec_helper.rb  # RSpec configuration
├── Gemfile             # Ruby dependencies
├── Gemfile.lock        # Locked dependency versions
├── Dockerfile          # Docker configuration for cross-platform support
├── docker-compose.yml  # Docker Compose configuration
├── .dockerignore       # Files to exclude from Docker build
└── README.md           # Project documentation
```

## Classes Overview

### Board

Manages the game board state, tracking all moves made by the code breaker and the corresponding pins. Provides functionality to check if the code breaker has won by verifying if all pins are red (correct color in correct position).

### Code

Represents a code consisting of 4 colors. Handles colorization using the rainbow gem for terminal output. Provides methods to create new codes and display them in a formatted way.

### Game

The main game controller that orchestrates the entire Mastermind game. Handles game initialization, round management, game mode selection (Human vs Human, Computer vs Human, Computer vs Computer), and determines win/loss conditions. Manages the interaction between the code maker and code breaker.

### Pins (Module)

Contains logic for generating feedback pins based on the secret code and the player's guess. Generates red pins for correct colors in the correct position, and silver pins for correct colors in the wrong position. Provides formatted display of pins.

### CodeGenerator

Generates random 4-color codes for computer players. Contains the color palette and provides a single method for random code generation, following the Single Responsibility Principle.

### Player

Abstract base class that defines the player interface with `make_guess` and `create_secret_code` methods. Uses polymorphism to allow different player types (human vs computer) to be used interchangeably in the game.

### HumanPlayer

Subclass of `Player` that handles human input. Prompts users for guesses and secret code creation through the terminal. Manages name collection for human players.

### ComputerPlayer

Subclass of `Player` that implements computer-controlled gameplay. Generates random guesses and secret codes automatically using `CodeGenerator`. Includes a 0.5s delay in guesses for a more natural feel.

### SecretCode

Inherits from the `Code` class and specializes in secret code management. Handles code input for human code makers and uses `CodeGenerator` for random code generation. Manages the available color palette (red, green, blue, yellow, black, silver, magenta, cyan).
