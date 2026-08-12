# Device components

What an app on this device can import, and what each thing is. Everything below already exists on
the reader — nothing here ships with the app.

The library is `com.pocketbook.controls`, the QML module the firmware's own apps are built from. It
lives at `/ebrmain/qml/com/pocketbook/controls`, so an app has to put that directory on the engine's
import path (`engine.addImportPath("/ebrmain/qml")`) before loading its scene.

```qml
import com.pocketbook.controls
```

Conventions that hold across the whole library:

* **Two versions.** Nearly every type is exported as both `1.0` and `2.0`. For most they are the
  same file; for eight of them — `AppHeader`, `BottomActionButton`, `Breadcrumbs`, `ContextMenu`,
  `Hyperlink`, `InstallationProgressBar`, `ScrollAssistant`, `DialogContainer`, `Fade` — `2.0` is a
  different, newer implementation. A plain `import com.pocketbook.controls` gets `2.0`.
* **Icons come from the firmware**, through the `image://resource/<name>`,
  `image://resource_inv/<name>` (inverted) and `image://resource_cached/<name>` providers. There are
  no image files to ship.
* **Press feedback is inversion**, because a greyscale panel has nothing else. Older controls signal
  `action()`, newer ones `clicked()`.
* **Controls do not change their own state.** `CheckBox`, `RadioButton` and friends report the tap
  and leave the value to the caller.
* **Metrics are computed, not fixed.** `Global.dp()` and `Global.pixelsFromDesign()` scale by the
  panel's real dpi and the user's scale factor; `GlobalValues` holds every metric and colour the
  firmware uses.

## Singletons

| Type | What it is |
|---|---|
| `Global` | `dp(v)`, `pixelsFromDesign(px)`, `fontPointSizeFromDesign(px)`, plus helpers for scrolling a `Flickable`/`ListView` by pages and for opening and closing every dialog and popup type (`openActionConfirmationDialog`, `openPopupMenu`, …). |
| `GlobalValues` | Every metric and colour the firmware lays out with: `defaultTextColor`, `defaultBackgroundColor`, `defaultBorderColor`, `defaultViewSideMargin`, `defaultTextButtonHeight`, `defaultListItemHeight`, `listElementHeight`, `dialogBorderWidth`, `defaultDialogWidth`, the font size and line height table, and about two hundred more. |
| `FontStyles` | The type scale. `StyledFont` enum: `Heading1`…`Heading5`, `Caption1`/`2`, `BodyL`, `BodyLBold`, `Body`, `BodyBold`, `BodyItalic`, `BodyS`, `BodySBold`, `BodyXS`, `BodyLink`, `BodyHint`, `BodyInputError`, `BodySComment`, `TextInIcons1`/`2`, and the `Cover*Title`/`Cover*Author` set. Also `fontScale` and `lineHeightScale` from the accessibility settings. |
| `ScaledValues` | The few margins that shrink as the accessibility text scale grows. |
| `ButtonState` | The three state name strings — `normal`, `pressed`, `disabled` — that the button types use in their `states` lists. |
| `DeviceInfoProvider` | The device itself: `screenWidth`, `screenHeight`, `panelHeight`, `screenDpi`, `screenScaleFactor`, `isTouchDevice`, `defaultFontFamily`, `userRootFolder`, the accessibility flags, `doNotSleep(ms)`, `enterA2onFlick(...)`, `updatePanelTransparent(...)`. Registered by the plugin, not a QML file. |

## Text and decoration

| Type | Base | What it is |
|---|---|---|
| `StyledText` | `Text` | The text element. `styledFont` picks a `FontStyles` style, which carries size, weight, line height and the accessibility scale; `ignoreDeviceFontScaling` and `ignoreDeviceFontBold` opt out. |
| `FontStyle` | `QtObject` | One resolved entry of the type scale — `styledFont`, `defaultFontPointSize`, `defaultLineHeightProportion`. What `FontStyles.fontStyle()` returns. |
| `SectionHeader` | `Rectangle` | A list section title, one `listElementHeight` tall, optionally faded at either end. |
| `TitledSeparator` | `Item` | A dotted rule with a centred title cut into it. Self-sizing. |
| `CommonSeparator` | `DottedSeparator` | The dotted rule the firmware puts between list rows; anchors itself to the bottom of its parent. |
| `TreeLineElement` | `Rectangle` | The connector line and marker drawn beside tree rows. |
| `Frame` | `Item` | Four hairline rectangles around whatever it fills. `thickness`, `color`. |
| `Fade` | `Rectangle` | A gradient mask over the edge of clipped content. `2.0` takes a `direction`; `1.0` a `vertical` flag. |
| `FocusElement` | `Item` | The focus outline drawn around `target` on non-touch devices. `borderThickness`, `visibleParts`. |
| `SlimFocusElement` | `FocusElement` | The same, one pixel thick. |
| `NosedImageTextLabel` | `Item` | An icon-and-text label with a pointing nose, used for callouts. |
| `Badge` | `Item` | A small circled counter. `value`, `hovered`. |
| `NoRadiusCorner` | `Item` | One square corner patched over a rounded dialog edge. |
| `DebugLabel` | `Text` | Dumps its `target`'s object info; visible only when the firmware's debug flag is on. |

## Buttons

| Type | Base | What it is |
|---|---|---|
| `TextButton` | `Rectangle` | The plain text button. `text`, `styledFont`, `pushable`, `noInvertOnPress`; signals `action`. |
| `RoundedCornerTextButton` | `AdvancedRectangle` | Text button with a rounded, per-side-controllable outline. `title`, `icon`, `backgroundColor`, `hoveredColor`; signals `clicked`, `pressedAndHold`. |
| `RoundedTextButton` | `Item` | Pill-shaped text button, sized to its text plus `horizontalMargin`/`verticalMargin`. Signals `clicked`. |
| `RoundTextButton` | `Rectangle` | Filled pill button with an optional icon. `text`, `normalColor`, `pressed_color`; signals `action`. |
| `RoundedCornerButtonContainer` | `AdvancedRectangle` | The same rounded surface with no content of its own — put anything inside. Signals `clicked`, `pressedAndHold`. |
| `RoundedCornerBitmapButton` | `AdvancedRectangle` | Icon-only variant. `icon`, `disabledIcon`. |
| `RoundedCornerBusyTextButton` | `Item` | Text button that swaps its label for a spinner while `busy`. |
| `RoundButtonBusyIndicator` | `Rectangle` | Pill button with a spinner beside the text. `busy_visible`. |
| `BitmapButton` | `Rectangle` | Icon-only button. `icon`, `pressedIcon`, `disabledIcon`, `pushable`, `holdInterval`; signals `action`, `hold(counter)`. |
| `BitmapTextButton` | `Rectangle` | Icon plus text plus optional subtext, with `leftItem`/`rightItem` slots. The firmware's standard list-row button. |
| `SimpleBitmapTextButton` | `Rectangle` | The cut-down version: one icon name, one label, `change_place` to swap their order. |
| `AdvancedBitmapTextButton` | `Rectangle` | Icon-and-text button with an exposed `focusElement` and dark mode. |
| `BadgeBitmapButton` | `Item` | `BitmapButton` with a `Badge` pinned to a corner. `badgeValue`, `badgePosition`. |
| `BadgeBitmapTextButton` | `Item` | The same with a label; `iconPosition` and `contentAlign` place the two. |
| `BottomActionButton` | `BitmapTextButton` (2.0) | The wide button in a bottom action bar, with a busy state and a long-press subtitle. |
| `BottomActionBitmapTextSubTextButton` | `Item` | Bottom-bar button stacking icon, text and subtext. |
| `MenuItemTextButton` | `Item` | One row of a menu, driven by a `MenuItemInfo`. |
| `SettingsBitmapTextTextButton` | `Rectangle` | Settings row: title on the left, current value on the right. Signals `action`, `pressAndHold`. |
| `SettingsBitmapTextSwitcher` | `Rectangle` | Settings row ending in an on/off switch. `switch_value`. |
| `CollapsibleTabButton` | `Item` | Tab-bar button that drops its label when space runs out. |
| `TextPusher` | `Item` | The "More" link that expands truncated text. |
| `Hyperlink` | `Item` | Tappable link text; `hoverEffect` inverts or bolds. `2.0` renders real rich-text links. |
| `Switcher` | `Image` | A bare two-image toggle. `icon`, `pressedIcon`; signals `action`. |
| `LoginVariantActionCard` | `Item` | The card offering one sign-in method: image, title, description, action. |

## Selection and input

| Type | Base | What it is |
|---|---|---|
| `CheckBox` | `Item` | Three-state checkbox — `checked` is `CheckBoxStateUnchecked`/`Checked`/`PartiallyChecked`, not a bool. Signals `clicked`, `pressedAndHold`. |
| `AdvancedCheckBox` | `Rectangle` | Checkbox whose six state icons are all supplied by the caller. |
| `CheckBoxImage` | `Image` | Just the checkbox glyph, with the firmware's inversion modes. |
| `RadioButton` | `Rectangle` | Radio row: icon plus `title`, `checked`, signal `check`. |
| `RadioButtonTextButton` | `Rectangle` | Radio row with a subtitle and a trailing action button. |
| `GroupSelectionPanel` | `FocusScope` | The multi-select header — "n of m selected", select all, cancel. |
| `ComboBox` | `Rectangle` | Drop-down over a `ListModel` of `text_` entries; opens a `PopupMenu`. Signals `choosed(uid)`, `close`. |
| `AdvancedTextInput` | `TextInput` | `TextInput` plus a styled `placeholderText`. |
| `FramedTextInput` | `TextInput` | The framed field: `showFrame`, `roundedFrame`, `placeholderText`, `showPasswordEye`. |
| `TextScroller` | `Rectangle` | A long single-line value with its own scroller and focus outline. |

## Headers and navigation

| Type | Base | What it is |
|---|---|---|
| `AppHeader` | `FocusScope` (2.0) | The title bar every app carries. `title`, `canClose`/`canBack`/`canMinimize`, signals `close`, `back`, `minimize`; children go into the right-hand button row. |
| `AppHeaderText` | `Item` | Just the header's title area, with the same alignment and elide options. |
| `ViewHeader` | `FocusScope` | In-app section header with a title, subtitle and a left icon button. |
| `BinaryHeader` | `Rectangle` | Header split into a left and a right component slot. |
| `WizardHeader` / `WizardFooter` | `Item` / `FocusScope` | Onboarding step title, and the Back/Next pair (`canNext`, `canBack`, `onlyNext`). |
| `Breadcrumbs` | `Rectangle` / `FocusScope` (2.0) | The path trail, with an ellipsis when it does not fit. Signals `clicked(index)`. |
| `TabsView` | `Rectangle` | Tab bar plus content: each child with a `title` becomes a tab. `selectedIndex`. |
| `TabView` / `TabPanel` / `Tab` | `Item` / `Item` / `LoaderNoSleep` | The newer, lazily loaded tab set — `TabView` takes a list of `Tab`s and a delegate for the bar. |
| `TabPanelInject` | — | Injection point that lets a nested scene push buttons into an ancestor's tab panel. |
| `DoubleFocusRow` | `Item` | A row of two delegates that share one focus position, for the non-touch key navigation. |

## Lists, menus and popups

| Type | Base | What it is |
|---|---|---|
| `TextList` | `Item` | A bulleted or prefixed text list from a model. |
| `BookElement` | `Item` | A library row: cover icon, title, author, plus caller-supplied trailing items. |
| `CachedListView` | `ListView` | `ListView` that keeps `maxScreenCount` screens of delegates alive, which is what makes long lists usable on e-ink. |
| `ContextMenu` | `FocusScope` / `Rectangle` (2.0) | The menu anchored to a `transparentRect`. `menuItems` `ListModel`, signals `choosed(uid)`, `close`. |
| `ContextMenu2Inner` | `Rectangle` | One level of a nested context menu; opens further levels through `openNewContextMenu`. |
| `AdvancedContextMenu` | `FocusScope` | Context menu whose items are arbitrary components (`ObjectModel`) rather than model rows. |
| `PopupMenu` | `FocusScope` | The menu that positions itself around `targetItem`/`targetRect` and picks a delegate from its `state` — `TextButton`, `ImageTextButton` or `RadioTextButton`. Accepts `text_`/`text` and `uid_` roles. |
| `MenuItemInfo` | `QtObject` | One menu entry: `uid`, `title`, `icon`, `type`, `isVisible`, `isSelected`, `showSeparator`. |
| `ListPopup` | `Item` | A framed popup list with an optional per-row hidden sibling panel. Signals `clicked(data, index)`. |
| `ListPopupWithPointer` | `ListPopup` | The same with a triangular pointer at a chosen row. |
| `TreePopup` | `Item` | A cascading `ListPopupWithPointer` tree driven by `sublist()`/`sublistLen()` callbacks. |
| `SortModelElement` / `TipModelElement` | `QtObject` | Model rows for the sort menu and for the tip dialog sequence. |
| `Edges` | `QtObject` | A four-sided on/off set (`left`/`right`/`top`/`bottom`, or `all`), used for borders and focus outlines. |

## Dialogs

`DialogContainer` is the base for most of them: it dims the screen, draws the framed panel with a
`DialogHeader`, and emits `close`, `apply`, `cancel`, `outerClick` and `back`. Every dialog is shown
by setting `visible` — `Global.open*` / `Global.close*` do exactly that and fill in the texts.

| Type | Base | What it is |
|---|---|---|
| `DialogContainer` | `FocusScope` / `Item` (2.0) | The modal shell. `title`, `dialogWidth`, `verticalOffset`, `closeOnOuterClick`, `headless`, `closeInterceptor`, `backgroundImage`. |
| `Dialog` (2.0) | `Item` | The newer bare dialog surface; `CenteredDialogContainer` and `DialogContainer2` place it, `MenuDialog` adds a title and body. |
| `DialogHeader` / `DialogFooter` / `DialogBackActionHeader` | | The title row with a close button, the apply/cancel row (`applyTitle`, `cancelTitle`, `canApply`, `canCancel`), and the back-plus-action header. |
| `DialogShadow` | `Item` | The dimmed backdrop, optionally with a hole punched at `transparentRect`. |
| `ActionConfirmationDialog` | `DialogContainer` | Title, `message`, apply and cancel. |
| `ConfirmationDialog` | `DialogContainer` | The same with an icon and optional apply/cancel callbacks. |
| `InformationConfirmationDialog` | `DialogContainer` | Icon, scrolling message, one dismiss button. |
| `InfoMessage` | `FocusScope` | The floating toast: `message`, `icon` (`InformationIcon`, `DoneIcon`, `QuestionIcon`, `WarningIcon`, `ErrorIcon`, `WifiIcon`), `autohideInterval`. |
| `InputDialog` | `DialogContainer` | One text field. `promptText`, `placeholderText`, signal `submit(text)`. |
| `TextEditDialog` | `DialogContainer` | Multi-line editor, with an `onlyView` mode. |
| `PasswordDialog` / `LoginPasswordDialog` | `DialogContainer` | Password, and username-plus-password. Signal `choosed(...)`. |
| `SelectFileDialog` / `ListViewSelectFileDialog` | `DialogContainer` | File and folder pickers over the user partition. Signal `fileSelected(path)`. |
| `ListViewSelectFileProcess` | `FocusScope` | The same picker as a full-screen flow rather than a dialog. |
| `TreeViewFileSelectDialog` / `TreeViewFilesSelectDialog` / `TreeViewFileSystem` | | Tree pickers for one file, several files, and the tree widget behind them. |
| `AutoShutdownDialog` | `DialogContainer` | The timeout list from the power settings. |
| `NosedDialog` / `NosedDialogContainer` / `ThinDialogContainer` | `Item` | Popovers with a pointing nose at a `targetRect`, and the thin variant without a header. |
| `TipDialogContainer` / `LazyTipDialogGroup` | | One onboarding tip bubble, and a sequence of them shown once per `tipId`. |

## Sliders and scrolling

| Type | Base | What it is |
|---|---|---|
| `Slider` | `Item` | The dotted-track slider. `value`, `minValue`, `maxValue`, `stepValue`, `orientation`, `direction`, `showStepIndicators`; signals `movementStarted`, `moving`, `movementEnded`. |
| `ProxySlider` | `Slider` | A `Slider` bound to a `PropertyProxy` instead of a value. |
| `ListSlider` | `Slider` | A `Slider` that scrolls a `ListView` and hides itself when everything fits. |
| `VerticalSlider` | `Rectangle` | The older vertical slider with start and finish markers. |
| `Scroller` | `Item` | The horizontal value scroller with repeat-accelerating end buttons. |
| `ContinuousScroller` / `GradationScroller` | `Item` | Draggable value tracks, smooth and stepped. |
| `ScrollerSubmitPanel` / `TallScrollerSubmitPanel` | `Rectangle` | A scroller flanked by minus/plus buttons and a submit row. |
| `ScrollableContentView` | `Item` | The standard scrolling page: a `Flickable` plus `ScrollAssistant` and `ScrollIndicator`. Content goes in as children; height comes from `childrenRect`. |
| `ScrollAssistant` | `Item` | The page-up/page-down buttons in the bottom corners. `2.0` adds jump-to-start/end. |
| `ScrollIndicator` | `Item` | The thin position bar down the edge. |
| `ScrollBar` | `Item` | A draggable bar bound to a `Flickable`. |
| `ListViewHardScrolling` | `Item` | Turns a `ListView` into whole-page steps, which is what e-ink wants. |
| `ListColumnFocusSaver` | `Item` | Keeps the focused column steady while a list scrolls under key navigation. |
| `ProxyPinchArea` | `PinchArea` | Pinch-to-zoom bound to a `PropertyProxy` over a `Flickable`. |

## Progress and activity

| Type | Base | What it is |
|---|---|---|
| `ProgressBar` | `Rectangle` | A plain bar. `minValue`, `maxValue`, `value`. Has no implicit height. |
| `InstallationProgressBar` | `Rectangle` / `Item` (2.0) | Progress with a title, a right-hand caption and a close button. |
| `CancelableProgressIndicator` | `Item` | Progress text plus a cancel action. |
| `BusyIndicator` | `Image` | The spinner: one cached firmware bitmap every 700 ms while visible. |
| `BusyResource` | `AdvancedObject` | The frame source behind it — `currentIndex`, `inverted`, `margined`, `timer` — for driving a spinner drawn elsewhere. |

## Media, device and legal

| Type | Base | What it is |
|---|---|---|
| `MediaControl` | `Rectangle` | Transport bar: play/pause, previous, next, hold-to-rewind. |
| `VolumeControl` | `Rectangle` | Stepped volume bars. Signal `volumeChanged(volume)`. |
| `Frontlight` | `Column` | The frontlight panel, bound to the `PBFrontlight` singleton — brightness, warmth, and their auto modes. |
| `FrontlightMenuItem` | `Item` | One minus/plus frontlight row with an auto toggle. |
| `AgreeElement` | `FocusScope` | One consent row: document name, checkbox, link to open it. |
| `ServiceAgreeElement` / `ServiceAgreeList` | `FocusScope` | Terms-of-use and privacy consent for a named service. |

## Behaviour and helpers

| Type | Base | What it is |
|---|---|---|
| `AdvancedRectangle` | `Item` | A rectangle whose border can be switched off per side (`visibleBorders`), which is how the firmware butts controls together. |
| `DelayedMouseArea` | `Item` | A mouse area that reports `pressStarted` after a `delay`, so a flick does not read as a tap. |
| `LoaderNoSleep` | `Loader` | A `Loader` that keeps the device awake while it loads. |
| `AutoImplicitSizeRepeater` | `Repeater` | A `Repeater` that sums and maxes its delegates' implicit sizes, for laying rows out by hand. |
| `Fmt`, `Str`, `StringList` | — | String formatting and list helpers registered by the plugin. |
| `Fs`, `SimpleFileSystemModel`, `FilesSelectModel` | — | Filesystem access and the models behind the file pickers. |
| `SortFilterProxyModel`, `ObjectListModel`, `ModelCounter` | — | Model plumbing; `SortReceipt`/`FilterReceipt` and their `ComplexSortReceipt`, `FilterByRoleReceipt`, `FilterByPredicateReceipt`, `SortByComparatorReceipt` variants describe one sort or filter step. |
| `PropertyProxy`, `ValueHoldProxy`, `PropertyProxyPlug` | — | Indirection objects the sliders and pinch areas bind to. |
| `AnyNavigation`, `LongKeyNavigation`, `RecursiveKeyNavigation`, `CloseKeyNavigation`, `StatusPanelNavigation`, `KeyHolder`, `KeyReplacer`, `StackFocus` | — | Key handling for the non-touch models and for the status panel. |
| `DeviceEvents`, `WindowEvents`, `StatusPanel`, `PBFrontlight`, `Process` | — | Device signals, the system status panel, the frontlight, and process launching. |
| `Triangle`, `DottedSeparator`, `DottedRectangle`, `RoundedFrame`, `StyledRect`, `AnchoredBorder`, `AnchoredBorderItem`, `GraphicalEffectImage`, `ImagePainter`, `AutoReloadImage` | — | Drawing primitives implemented in C++ because the scene graph is software-rasterised. |
| `Lazy`, `SrcLoader`, `DynamicPlaced`, `Union`, `Case`, `Reseter`, `CountingTimer`, `OrientationToParent`, `MapToGlobal`, `MapFromGlobal`, `MapParentFromGlobal`, `ListViewDimensions`, `AdditionalMath`, `LinearAlgebra`, `Meta`, `DebugInfo` | — | Assorted utility objects; `NosedDialogUtils`, `TreePopupUtils` and `TabUtils` carry the placement maths for the popovers and tabs. |

## Qt modules on the device

Present under `/ebrmain/qml`, so importable without shipping anything: `QtQml`, `QtQuick` (with
`Controls` — Basic, Fusion, Imagine, Material, Universal, FluentWinUI3 — plus `Layouts`, `Window`,
`Shapes`, `Effects`, `Particles`, `Dialogs`, `Templates`, `LocalStorage`, `VectorImage`, `Pdf`),
`QtCore`, `QtNetwork`, `QtWebSockets`, `QtWebChannel`, `QtWebEngine`, `QtWebView`, `QtTest`,
`Qt5Compat`, `Qt.labs` (`platform`, `settings`, `folderlistmodel`, `qmlmodels`, `animation`,
`sharedimage`, `wavefrontmesh`) and `Assets.Downloader`.

Anything imported at runtime still has to have its library linked or resolvable — an import that
pulls in a Qt module the app does not link will fail at scene load, not at build.

## Where this came from

The device's `/ebrmain/qml` tree, firmware 6.8.x on a PB743K3. The module's QML sources are readable
on the device itself; they are not vendored here.
