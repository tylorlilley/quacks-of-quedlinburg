# Run Simulation Game

Launch irb with the necessary classes required:

```
irb -r ./app/game.rb
```

Then, set up and run a simulation by creating an ingredient set and one or more players to start the game with:

```
traits = [:vocal, :buys_red_chips, :buys_orange_chips, :never_rolls_die, :buys_multiple_if_able]
player = Player.new(1.0, traits)
ingredient_set = IngredientSetOne.new
game = Game.new(ingredient_set, [player])
game.run
```

To run multiple games and get statistics about the results, do this:

```

```

# Usage
Run the app entry point script:
```
repo=octokit.py bin/app.rb
```

Run the guard dev env tool:
```
guard
```
It will run rubocop on start, will run rubocop inspections on changed files and will re-run all RSpecs and rubocop
inspections if you hit Enter in guard window.
