# DhikrUnlock

Perform your daily dhikr to unlock your apps. An iOS app that uses Apple's Screen Time API to block selected apps until you complete 6 dhikr phrases.

## Setup

1. Install [XcodeGen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`
2. Generate the Xcode project: `xcodegen generate`
3. Open `DhikrUnlock.xcodeproj` in Xcode
4. Configure signing & capabilities (requires Apple Developer Program for Family Controls entitlement)
5. Build and run on a physical device (Screen Time APIs don't work in Simulator)

## Requirements

- iOS 17.0+
- Xcode 15+
- Physical device for Screen Time features
- Apple Developer Program membership (for Family Controls provisioning)
