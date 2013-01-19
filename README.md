# Slingball for iPad

![Screenshot of the game.](https://raw.github.com/novasa/slingball-ios/master/slingball-screenshot.jpg)

If you have an iPad handy and don't feel like booting up Xcode, you can download the game for free from [iTunes](https://itunes.apple.com/us/app/slingball-for-ipad/id364576589?mt=8).

## What's in here

This game was built in **C/Objective-C** using a component-based strategy for entities, and among other features, it has a neat and tiny rendering system that sorts based on shared states.

There's no awkward dependencies, and all rendering is straight-up fixed-pipeline **OpenGL ES 1.1**.

## Building this thing

Xcode 4.4 should be able to compile the project just fine for devices, though you might need to make sure that it uses the LLVM GCC compiler rather than the default LLVM.

![logo](https://raw.github.com/novasa/slingball-ios/master/slingball-logo.png)