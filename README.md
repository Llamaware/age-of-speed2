# Age of Speed 2

Age of Speed 2 was a racing game made with Macromedia Director. This page documents a decompilation and build process for the game.

### Programs used

[ProjectorRays](https://github.com/ProjectorRays/ProjectorRays) - to decompile original `.dcr` -> `.dir`

[Macromedia Director MX 2004](https://archive.org/details/DirectorMX) - to compile the game

[DirectorCastRipper](https://github.com/n0samu/DirectorCastRipper) (optional) - get assets from `.dir`

[Shockwave3DWorldConverter](https://github.com/tomysshadow/Shockwave-3D-World-Converter) (optional) - convert `.w3d` -> `.obj` for use in Blender, etc.

### Build

1. Clone the repo.
2. Open `src/age_of_speed2.dir` in Macromedia Director MX 2004.
3. Set image compression to Standard in Publish Settings.
4. File > Publish
5. Place the `.exe` file in a directory with all the files in `/levels`.
6. Run the game.

### Decompilation

1. Decompile `age_of_speed2.dcr` using ProjectorRays. Make sure that `--dump-scripts` is enabled.

```
./projectorrays-0.2.0 decompile age_of_speed2.dcr --dump-scripts
```

2. Use `rename.py` to create a new folder with the scripts renamed to their proper names.
3. Patch `Movie.ls` with this code to allow the game to run offline:

```
on validDomainSBS
  return 1
end
```

### Disclaimer

I don't own any of the code here. The code belongs to Silent Bay Studios (now defunct).