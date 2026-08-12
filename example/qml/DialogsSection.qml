import QtQuick
import com.pocketbook.controls
import "."

/** Openers for the modal surfaces, which main.qml owns because they cover the whole window. */
DemoSection {
    id: root

    title: "Dialogs and messages"

    signal confirmationRequested()
    signal messageRequested(string text)

    Row {
        width: parent.width
        spacing: Design.spacing

        RoundedCornerTextButton {
            width: Design.buttonWidth
            height: Design.textButtonHeight
            title: "Confirm"
            radius: Design.elementBorderRadius
            border.width: Design.borderThickness
            border.color: Design.borderColor
            onClicked: root.confirmationRequested()
        }

        RoundedCornerTextButton {
            width: Design.buttonWidth
            height: Design.textButtonHeight
            title: "Notify"
            radius: Design.elementBorderRadius
            border.width: Design.borderThickness
            border.color: Design.borderColor
            onClicked: root.messageRequested("InfoMessage — hides itself after two seconds")
        }
    }

    StyledText {
        width: parent.width
        styledFont: FontStyles.BodyS
        color: Design.disabledTextColor
        wrapMode: Text.Wrap
        text: "ActionConfirmationDialog dims the screen behind it and reports apply or cancel; "
              + "InfoMessage floats above the content and autohides."
    }
}
