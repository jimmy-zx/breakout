# Breakout

A breakout game implementation using MIPS

## Platform

- MARS emulator
- `qemu-user` emulator with `marsemu` toolchain

## Versions

Three versions are provided:

- `qemu` development version, to be run on `qemu-user` emulator
- `nomacro` generated from `qemu` without macro
- `mars` to be run on the MARS emulator, ported from `nomacro`

## Features

- E1 multiple lives
- E2 game over
- E5 pause
- H1 score display
- H2 max score display
