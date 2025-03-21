# Password Application for Apple Devices

This application is a simple password manager that runs on macOS and iPadOS.

## Requirements

You must sign the application with a valid Apple Developer account to build and run it properly.

### Supported Devices

| Device            | OS Version          |
|-------------------|---------------------|
| Mac with Apple Silicon | macOS 15.3.1 or later |
| iPad              | iPadOS 18.2 or later |

### Xcode

Xcode version 16.2

## Architecture

The app uses the MVVM pattern with SwiftUI and SwiftData.  
It also uses **NavigationSplitView** for hierarchical view organization.

## Future Improvements

- Remove all Bindings and use only `@Published` properties or other alternatives  
- Add unit tests  
- Include timestamp for each password access
