# The Legends of Owlia

**The Legends of Owlia** is a fantasy action-adventure game for the Nintendo Entertainment System (NES), featuring heroine Adlanniel and her faithful owl companion, Tyto.

## Story

Once upon a time, on a world far beyond imagining, six great owls brought forth a land called **Owlia**. Together, they reigned in peace and wisdom for eighty thousand years.

However, their pride in the beautiful land and sky of Owlia led them to forget the vast seas below.

There dwelled **Mermon, King of the Mermen**, who often rose to the surface to gaze upon the forests, sunlight, and skies of Owlia. Over time, his longing for the world above grew until the seas were no longer enough for him.

One by one, Mermon summoned the six great owls and began stealing their powers of flight. As their strength faded, his minions gained the ability to float toward the Land of Owlia and claim it for their king.

Only one great owl escaped his grasp: **Silmaran, the White King**.

Soaring high above the land as Mermon's forces gathered strength, Silmaran searched for a hero who might answer his call, rescue the great owls, and restore peace to Owlia.

Guide heroine **Adlanniel** and her owl friend **Tyto** as they journey across Owlia, free the great owls, and confront Mermon, King of the Mermen!

## Features

- 12 unique enemy types
- 5 fierce bosses
- 7 fully scrolling overworld maps
- 5 puzzle-filled dungeons
- 8 special owl techniques for Tyto to perform
- Sword-based combat against monsters and enemies
- Password system to save your progress
- Large world to explore and uncover

## Building From Source

### Dependencies

The build process has only two requirements:

- **cc65** (must be available in your system PATH)
- **Python 3** (must be available in your system PATH)

### Verify Installation

Linux:

```bash
cc65 --version
python3 --version
```

Windows:

```cmd
cc65 --version
python3 --version
```

### Build

From the root of the repository:

```bash
python3 build.py
```

This will compile the game and generate a playable `.nes` ROM image.

### Clean

Either of the following commands may be used to remove generated build files:

```bash
python3 build.py clean
```

or

```bash
python3 clean.py
```

### Running

The generated ROM can be played in any NES emulator or on compatible NES hardware using a flash cartridge.
