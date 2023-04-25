# Architecture
Welcome to the architecture section of our **AdMob plugin** open source project. This folder contains detailed information about the design and implementation of our plugin.

## Navigation
- The [class-diagrams](class-diagrams.md) file contains class diagrams that show the relationships between different classes and components of the plugin.
- The [design-patterns](design-patterns.md) file contains a description of the design patterns used in the plugin.
- The [dependencies](dependencies.md) file contains a list of external libraries and frameworks used by the plugin.

## High Level Overview 
The plugin architecture is designed to make it easy to integrate AdMob into your app, while still providing flexibility and control. The main classes and components of the plugin include:

```mermaid
sequenceDiagram
    actor Android/iOS
    actor AdMobPlugin(Godot)
    actor GoogleAdsInventory(Cloud)
    
    
    Android/iOS->>AdMobPlugin(Godot) : Asks to Plugin an Ad
    activate AdMobPlugin(Godot)
    AdMobPlugin(Godot)->>GoogleAdsInventory(Cloud) : Asks Google an Ad
    activate GoogleAdsInventory(Cloud)
    GoogleAdsInventory(Cloud)->>AdMobPlugin(Godot) : Return an Ad to AdMobPlugin
    deactivate GoogleAdsInventory(Cloud)
    AdMobPlugin(Godot)->> Android/iOS : Shows the Ad received
    deactivate AdMobPlugin(Godot)
```
