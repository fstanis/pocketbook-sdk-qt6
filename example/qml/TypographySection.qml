import QtQuick
import com.pocketbook.controls
import "."

/** The firmware's text styles, each of which StyledText resolves from one FontStyles name. */
DemoSection {
    title: "Typography — StyledText"

    Repeater {
        model: [
            { name: "Heading2", style: FontStyles.Heading2 },
            { name: "Heading4", style: FontStyles.Heading4 },
            { name: "BodyL", style: FontStyles.BodyL },
            { name: "Body", style: FontStyles.Body },
            { name: "BodyBold", style: FontStyles.BodyBold },
            { name: "BodyItalic", style: FontStyles.BodyItalic },
            { name: "BodyS", style: FontStyles.BodyS },
            { name: "Caption1", style: FontStyles.Caption1 }
        ]

        StyledText {
            required property var modelData

            width: parent.width
            styledFont: modelData.style
            color: Design.textColor
            elide: Text.ElideRight
            text: `${modelData.name} — pack my box with five dozen liquor jugs`
        }
    }
}
