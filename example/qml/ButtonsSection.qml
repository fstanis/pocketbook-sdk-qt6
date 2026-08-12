import QtQuick
import com.pocketbook.controls
import "."

/** The firmware's button family, which reports taps as `action` or `clicked` by vintage. */
DemoSection {
    id: root

    title: "Buttons"

    property int pressCount: 0

    Flow {
        width: parent.width
        spacing: Design.spacing

        TextButton {
            width: Design.buttonWidth
            height: Design.textButtonHeight
            text: "TextButton"
            onAction: root.pressCount++
        }

        RoundedCornerTextButton {
            width: Design.buttonWidth
            height: Design.textButtonHeight
            title: "RoundedCorner"
            radius: Design.elementBorderRadius
            border.width: Design.borderThickness
            border.color: Design.borderColor
            onClicked: root.pressCount++
        }

        RoundedTextButton {
            text: "RoundedTextButton"
            onClicked: root.pressCount++
        }

        RoundTextButton {
            text: "RoundTextButton"
            onAction: root.pressCount++
        }

        Hyperlink {
            text: "Hyperlink"
            onClicked: root.pressCount++
        }
    }

    StyledText {
        width: parent.width
        styledFont: FontStyles.BodyS
        color: Design.disabledTextColor
        text: `pressed ${root.pressCount} times`
    }
}
