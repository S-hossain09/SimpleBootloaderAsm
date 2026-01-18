# SimpleBootloaderAsm

---

## Assemble and Run

### Prerequisites
- **FASM** (Flat Assembler)
- **QEMU**

Assemble
```
fasm bootloader.asm bootloader.bin
```

To Run
```
qemu-system-x86_64 -drive file=bootloader.bin,format=raw
```

## How a Bootloader Works (In Simple Terms)

When you power on a computer, the **BIOS** looks for a bootable device (like a hard drive or USB).  
If it finds one, it loads **exactly 512 bytes** (one sector) from that device into memory at a fixed address: **0x7C00**.  
Execution starts from there.

A basic bootloader usually does the following:

- **Runs in 16-bit mode** because that’s how the BIOS starts the CPU.
- **Assumes it lives at 0x7C00**, since the BIOS always loads it there.
- **Initializes memory segments and the stack** so the program behaves predictably.
- **Uses BIOS services (interrupts)** to do simple tasks like clearing the screen or printing text.
- **Executes its main job** (for example: showing a message or loading the next stage of an OS).
- **Stops or loops forever** once its job is done.

To be recognized as bootable:
- The code must be **exactly 512 bytes** long.
- The last two bytes must be the **boot signature `0xAA55`**.

In short:  
A bootloader is a tiny program that the BIOS runs first, whose job is to set things up and either show something simple or load the operating system.

