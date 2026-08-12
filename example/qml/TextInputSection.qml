import QtQuick
import com.pocketbook.controls
import "."

/** The firmware's text fields, which are TextInput subclasses rather than wrappers. */
DemoSection {
    title: "Text input"

    FramedTextInput {
        width: parent.width
        height: Design.listItemHeight
        placeholderText: "FramedTextInput — rounded frame"
        color: Design.textColor
    }

    FramedTextInput {
        width: parent.width
        height: Design.listItemHeight
        placeholderText: "FramedTextInput — password, with the reveal button"
        roundedFrame: false
        showPasswordEye: true
        color: Design.textColor
    }

    AdvancedTextInput {
        width: parent.width
        height: Design.listItemHeight
        placeholderText: "AdvancedTextInput — a placeholder and nothing else"
        color: Design.textColor
    }
}
