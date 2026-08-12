import QtQuick
import com.pocketbook.controls
import "."

/** Device facts, from InkView through the `deviceInfo` context property and from DeviceInfoProvider. */
DemoSection {
    title: "Device"

    Repeater {
        model: [
            { name: "model", value: `${deviceInfo.model} (${deviceInfo.hardwareType})` },
            { name: "firmware", value: deviceInfo.softwareVersion },
            { name: "panel", value: `${deviceInfo.screenWidth}x${deviceInfo.screenHeight}, `
                                    + `status bar ${deviceInfo.panelHeight}px` },
            { name: "qt", value: `${deviceInfo.qtVersion} on the ${deviceInfo.platformName} platform` },
            { name: "font", value: deviceInfo.fontFamily },
            { name: "dpi", value: `${DeviceInfoProvider.screenDpi}, scale factor `
                                  + `${DeviceInfoProvider.screenScaleFactor}` },
            { name: "touch", value: DeviceInfoProvider.isTouchDevice ? "yes" : "no" }
        ]

        StyledText {
            required property var modelData

            width: parent.width
            styledFont: FontStyles.BodyS
            color: Design.textColor
            elide: Text.ElideRight
            text: `${modelData.name}: ${modelData.value}`
        }
    }
}
