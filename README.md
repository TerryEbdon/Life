# Life

This is John Conway's [Game of Life](http://www.conwaylife.com/wiki/Conway%27s_Game_of_Life), 
implemented in AWK. The initial game configuration is read from the text file named in the first 
parameter, or stdin if no file is specified. The script expects `clear` and `sleep` to be on 
the path. If you're using Git Bash then you have everything you need.

Run the game with the following command:
```
awk -f Life.awk blinker.txt
```

The script clears the console before displaying each step, and sleeps for one second
between each step.
