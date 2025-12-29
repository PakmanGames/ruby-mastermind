# Ruby Mastermind Game

A console based game of Mastermind written in Ruby. The game utilizes the rainbow gem to create colourful output in the terminal.

Learn how to play mastermind click [here](https://www.wikihow.com/Play-Mastermind).  
For those who would rather prefer a TikTok brainrot video version click [here](https://www.youtube.com/watch?v=EF2oeSnTYgY) to learn more.

## Running the Game

```bash
# Make sure required gems are installed on your system
bundle install

# After gem dependencies are installed run:
ruby main.rb
```

Information about the dependencies can be found in the `Gemfile`.

## Project Structure

```text
ruby-mastermind/
├── main.rb              # Entry point for the game
├── lib/                 # Core game classes
│   ├── board.rb        # Board class - manages game board and moves
│   ├── code.rb         # Code class - represents a code with 4 colors
│   ├── game.rb         # Game class - main game logic and flow
│   ├── pins.rb         # Pins module - generates feedback pins
│   ├── player.rb       # Player class - represents a player (human/computer)
│   └── secret_code.rb  # SecretCode class - handles secret code generation
├── Gemfile             # Ruby dependencies
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

### Player

Represents a player in the game, which can be either human or computer-controlled. Stores the player's name and role (code maker or code breaker). Handles name input for human players.

### SecretCode

Inherits from the `Code` class and specializes in secret code management. Handles random code generation for computer players and code input for human code makers. Manages the available color palette (red, green, blue, yellow, black, silver, magenta, cyan).
