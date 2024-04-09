# MIPS Blackjack Gamble Game

## Overview
This MIPS assembly language program implements a blackjack gamble game for the MIPS architecture. It offers users the classic blackjack experience with the added thrill of placing bets on each round. The game includes basic graphics to enhance the user interface.

## Features
- **Classic Blackjack Gameplay**: Experience the timeless game of blackjack with all its rules and strategies.
- **Gamble System**: Place bets before each round to add excitement and challenge.
- **Basic Graphics**: The game features simple graphical elements to improve the user experience.
- **Five-Card Charlie Rule**: Players can win if they collect five cards without exceeding 21 before the dealer does.
- **Billiards Table Interface**: The game's display resembles a billiards table, providing a unique visual experience.

## Gameplay Details
- **Objective**: The player aims to obtain a hand total as close to 21 as possible without exceeding it. The dealer's hand must also be beaten.
- **Initial Cards**: The player and dealer receive two cards each. One dealer card and one player card are face up, while the rest remain face down.
- **Betting**: Players start with $100 and must place bets before each round begins.
- **Card Generation**: Cards are randomly drawn from a deck of four suits (hearts, diamonds, clubs, and spades) without replacement. Duplicate cards cannot be drawn for both the player and dealer.
- **Game Progression**: Players can choose to "hit" (receive another card) or "stand" (keep their current hand). The dealer will draw cards until their total is 17 or higher.
- **Winning Conditions**: The player wins if their hand total exceeds the dealer's without exceeding 21 or if the dealer's hand exceeds 21. The player also wins if they achieve a five-card Charlie before the dealer.
- **Hidden Cards**: The second dealer card remains hidden until the player's turn is complete.

## Requirements
- MIPS Architecture Emulator or Hardware
- Compatible Operating System
- Input/Output System (e.g., keyboard and display)

## Instructions for Running
1. **Load the Program**: Clone or download the repository containing the MIPS assembly code.
2. **Assemble**: Assemble the code using a compatible MIPS assembler.
3. **Execute**: Run the assembled code on your MIPS architecture emulator or hardware.

## Acknowledgements
This project was developed as part of CMPEN351 Mircroprocessor course at PSU. 
