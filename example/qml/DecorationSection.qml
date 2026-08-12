import QtQuick
import QtQuick.Layouts
import com.pocketbook.controls
import "."

/** The components that carry no behaviour: rules, outlines and counters. */
DemoSection {
    title: "Decoration"

    TitledSeparator {
        width: parent.width
        title: "TitledSeparator"
    }

    Item {
        width: parent.width
        height: framedText.height + 2 * Design.spacing

        StyledText {
            id: framedText

            anchors.centerIn: parent
            width: parent.width - 2 * Design.spacing

            styledFont: FontStyles.Body
            color: Design.textColor
            wrapMode: Text.Wrap
            text: "Frame — four hairline rectangles around whatever it is anchored to"
        }

        Frame {
            anchors.fill: parent
            thickness: Design.separatorThickness
        }
    }

    RowLayout {
        width: parent.width
        spacing: Design.spacing

        Badge {
            Layout.alignment: Qt.AlignVCenter
            value: 7
        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            styledFont: FontStyles.Body
            color: Design.textColor
            text: "Badge — the unread counter the firmware puts on library covers"
        }
    }
}
