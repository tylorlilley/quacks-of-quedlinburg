# Run Simulation Game

Launch irb with the necessary classes required:

```
irb -r ./app/game.rb
```

Then, set up and run a simulation by creating an ingredient set and one or more players, like this:

```
player = SetOneRedPlayer.new(1.0)
player2 = SetOneRedPlayer.new(5.0)
player3 = SetOneRedPlayer.new(20.0)
player4 = SetOneRedPlayer.new(50.0)
ingredient_set = IngredientSetOne.new
```

Then, run through a game like this:

```
Game.new(ingredient_set, [player, player2, player3, player4]).run
```

Or, to run multiple games and get statistics about the results, do this:

```
Simulation.new(ingredient_set, [player, player2, player3, player4], 10).run
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
