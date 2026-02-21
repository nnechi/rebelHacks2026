
# The House Always Wins  
*A Blackjack Simulator About Probability, Not Luck*
> “You’re not unlucky. You’re just playing long enough.”
---
## Overview

**The House Always Wins** is a satirical blackjack simulator that uses real-time graphs and sarcastic dealer dialogue to demonstrate the statistical reality of gambling, especially the **Law of Large Numbers**.
	This is not a traditional casino game.  
	This is a probability lesson disguised as one.
The longer you play, the clearer the math becomes.

---
## Purpose

This project was built to:
- Address the gambling and gambling addiction in Vegas
- Demonstrate how the **Law of Large Numbers** works in real time
- Visualize cumulative profit/loss over time
- Includes humor and satire to undermine the gambler mindset
- Show how short-term wins do not override long-term expected loss
- End the myth that luck beats math.

---
##  Core Concept: Law of Large Numbers
In blackjack, a player may win several hands in a row.  
But over time:
- The expected value per hand trends negative (due to house edge)
- Variance smooths out
- The cumulative graph trends toward the statistical expectation
This simulator visually proves:
> The more you play, the closer you get to the expected loss.

---
## Gameplay

This simulator blends blackjack mechanics with statistical visualization and reactive satire to demonstrate how probability unfolds over time.
### What Happens When You Play
1. You start with a bankroll.
2. Each hand simulates a blackjack round.
3. The result is recorded:
   - `+1` for win  
   - `0` for push  
   - `-1` for loss  
4. Your cumulative total updates instantly.
5. The graph adjusts in real time.
6. The dealer comments on your decisions and streaks.
Short sessions may feel exciting, long sessions feel… educational.
### Live Statistical Feedback
#### Addiction Awareness Through Visualization
Instead of lecturing, the game:
- Reveals statistical patterns
- Displays long-term loss progression
- Uses satire to challenge the illusion of control
- Encourages reflection through data, not shame
#### Cumulative Profit Graph
- Tracks every hand played
- Displays net gain/loss over time
- Gradually trends toward expected value
- Visually demonstrates convergence predicted by the Law of Large Numbers
#### Win/Loss History Tracking
- Stores complete result history
- Highlights streaks
- Shows how streaks shrink in meaning over larger sample sizes

### Reactive Dealer Commentary
Dialogue responds dynamically to your behavior:
- Win streak?  
  > “Feeling lucky? Let’s see how long that lasts.”
- Big loss?  
  > “BUSTED!”
The commentary doesn’t de-moralize, it reflects what the math is already showing.

---
## Educational Disclaimer
This simulator exists to demonstrate:
- Gambling is mathematically negative expectation.
- Winning streaks do not change expected value.
- The longer you play, the closer you get to the house edge.
It is designed as a **learning tool**, not encouragement to gamble.

---
## References
- COMP359. *Godot Blackjack AI*.  
  https://github.com/COMP359/Godot-Blackjack-AI
- Nevada Council on Problem Gambling – *When the Fun Stops*:  
  https://www.nevadacouncil.org/understanding-problem-gambling/when-the-fun-stops/
