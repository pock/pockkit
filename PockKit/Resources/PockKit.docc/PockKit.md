# ``PockKit``

Display custom widgets inside MacBook Pro’s Touch Bar.

## Overview

Thanks to PockKit, [Pock](https://pock.app) can give macOS the ability to display custom widgets inside your MacBook's Touch Bar.

In this documentation, we will cover all the steps required to build a widget for Pock, starting from the foundation until covering more advanced scenarios, including adding a custom preference pane with ``PockKit/PKWidgetPreference`` and integrating ``PockKit/PKScreenEdgeMouseDelegate`` to allow the cursor to interact with our widget.

![From left to right: Swift file icon, Xcode icon and the Pock Widget bundle icon](swift-xcode-widget.png)

The first step to start creating a widget is to follow the instructions included in the <doc:Install-Developer-Kit> section. 
The Developer Kit consists of a widget template that can be easily installed inside Xcode.

If you have already installed the Developer Kit, you can jump directly into the <doc:Getting-Started-with-Pock-Widget> part.

## Topics

### Essentials

- <doc:Install-Developer-Kit>
- <doc:Getting-Started-with-Pock-Widget>
- ``PKWidget``

### Default Elements

- ``PKView``
- ``PKButton``
- ``PKDetailView``

### Preference Pane

- <doc:Create-Preferences-Pane>
- ``PKWidgetPreference``

### Cursor Integration

- <doc:Learn-Cursor-Integration>
- ``PKScreenEdgeMouseDelegate``
- ``PKTouchBarMouseController``
- ``PKDraggingInfoView``

### Advanced Topics

- <doc:Interact-With-Navigation-Controller>
- ``PKTouchBarController``
- ``PKTouchBarNavigationController``

### Internal Symbols

- ``PKScreenEdgeController``
- ``PKScreenEdgeBaseController``
- ``ScrollingTextView``
