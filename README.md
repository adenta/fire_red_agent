# Fire Red Agent

## Overview

This is my attempt at getting a large language model to play Pokémon FireRed autonomously. My bot has rudementery capabilities to play the game, explore, battle, and respond to game events.

To me, this is the future of TV. While building the bot, I felt like I was producing television more than I was programming a computer. Ultimately, I ran into some technical hurdles around programmatic input control, which led me to pause development.

## How It Works

1. Emulator Integration

I used [RetroArch](https://www.retroarch.com) to run Pokémon FireRed. I struggled with sending inputs programmatically. RetroArch has a UDP-based input system ([RetroPad](https://docs.libretro.com/library/remote_retropad/)), but I couldn't get it to work reliably.

Instead, I resorted to using [OSA Script (AppleScript)](https://ss64.com/mac/osascript.html) to send keyboard events to the emulator, which meant the game had to be in focus. This was a huge limitation because it took over my entire computer, making background work impossible.

2. Game Memory Management

I stored game state in a database, treating it like a diary of the AI’s experiences. The system recorded actions the AI attempted, what worked, what didn’t, and adjusted accordingly.

There were four different types of memories, and the AI pulled the most recent 250 to maintain context. If an action failed—like trying to walk somewhere and hitting an obstacle—the AI would remember and avoid making the same mistake.

3. Navigation & Pathfinding

The AI needed to figure out where to go in the game world. I extracted map data by reading game memory from RetroArch. I then used a pathfinding algorithm to determine the best route. The AI only considered valid movement options based on tiles and available paths. If stuck, it defaulted to trying adjacent moves (e.g., "walk south", "walk east", etc.).

4. Game Text Parsing

To understand the game, the AI needed to read in-game text. Since I wasn’t using direct memory extraction for text (as advised by [PRET](https://pret.github.io)), I took screenshots at key points and processed them with OCR.

This allowed the AI to understand NPC conversations, menu prompts, and other critical game events. This was super important, as it guided the LLM to know what to do next.

5. LLM Integration

I used OpenAI’s GPT-4o to process all the gathered information and make decisions.System prompts guided the AI to avoid repeated actions (e.g., trying to pick Charmander before meeting Professor Oak multiple times). The model received structured data about current location, possible actions, game memories, and navigation options. I experimented with frequency and presence penalties to encourage varied behavior and prevent getting stuck in loops.

6. Battle Handling

The battle handler was quite naive. All it was doing was pressing A. if the battle lasted longer than a minute, we began sending some random inputs to get out of the battle. This was an area I wanted to improve, but my priority was getting the AI to navigate the world first.

7. Interaction & Conversation Handling

When talking to NPCs, the AI needed to determine if it should continue the conversation or move on. The conversation handler took screenshots, extracted text, and checked whether dialogue was still ongoing.

If the AI detected text, it continued pressing A. If no new text appeared, it moved on to the next part of the script.

## Challenges & Why I Paused Development

The biggest hurdle was sending inputs to the emulator.

RetroArch’s UDP input (RetroPad) didn’t work for me.

Keyboard-based input (OSA Script) required focus, making automation impractical.

Python-based solutions (like PiBoy) exist, but I prefer Ruby and struggled with existing Python tools freezing up.

## Final Thoughts

This project was both a nightmare and a ton of fun. As LLMs get better this is only going to get easier. I believe that Claude Plays Pokemon isn't doing any of the memory parsing I spent a ton of time, they are just streaming the memory directly to Claude 3.7 and it is figuring it out 🤯. If you find this work interesting, feel free to fork it, modify it, and build something even better!

## Special Thanks

Griffin R. – Huge help on reading game memory.

[Graham Seamens](https://www.linkedin.com/in/graham-seamans-374baa61/) & [Parth Patil](https://www.linkedin.com/in/p4r7h/) – Assistance with AI logic.

[The Pokémon ROM hacking/decompilation community](https://pret.github.io) – Without them, this wouldn’t have been possible.

Contact

You can find me on [LinkedIn](linkedin.com/in/adenta/) and [Hacker News](https://news.ycombinator.com/user?id=adenta).
