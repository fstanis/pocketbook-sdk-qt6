pragma Singleton

// For the colour value type.
import QtQuick
import com.pocketbook.controls

/**
 * This app's design tokens, taken from the firmware's GlobalValues so they follow the device's dpi,
 * scale factor and inversion mode. Typography is absent because a FontStyles style already carries
 * it.
 */
QtObject {
    readonly property color textColor: GlobalValues.defaultTextColor
    readonly property color backgroundColor: GlobalValues.defaultBackgroundColor
    readonly property color disabledTextColor: GlobalValues.defaultDisabledTextColor
    readonly property color borderColor: GlobalValues.defaultBorderColor

    readonly property real viewSideMargin: GlobalValues.defaultViewSideMargin
    readonly property real textButtonHeight: GlobalValues.defaultTextButtonHeight
    readonly property real listItemHeight: GlobalValues.defaultListItemHeight
    readonly property real elementBorderRadius: GlobalValues.defaultElementBorderRadius
    readonly property real borderThickness: GlobalValues.defaultPressedFrameBorderWidth
    readonly property real separatorThickness: GlobalValues.defaultSolidSeparatorThickness

    // The three with no counterpart in GlobalValues; the firmware sizes each view by hand.
    readonly property real spacing: Global.dp(12)
    readonly property real buttonWidth: Global.dp(150)
    readonly property real progressBarHeight: Global.dp(12)
}
