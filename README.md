# Birdle

Hey! This is my project, Birdle. It's a bird version of the popular word game *Wordle*.

**The aim is to guess the mystery bird, which is 5 letters long.** To play, use the on-screen keyboard or the computer keyboard to enter letters. Every guess must be 5 letters long, and must be a bird in the bird list stored in the game. Then click enter (->).
* If a letter is yellow, it means that it's in the name of the mystery bird, but not in the right spot.
* If it's green, it's in the word and in the right spot. 
* Gray is not in the word at all.

For example, say the guess is **"crane"**, and the boxes turn `gray`, `gray`, `gray`, `yellow`, `green`
Then there's a chance that the mystery bird is **"snipe"**, because it contains an n that's not in the fourth spot, and it ends with an e.

Original bird list adapted from [here.](https://gist.github.com/jason-kane/a12aba88f84cf84906344f5fac6b33b7#file-list_of_birds-txt)

All code written by me, with periodic aid from stack overflow :)
© androidkn on github, 2022