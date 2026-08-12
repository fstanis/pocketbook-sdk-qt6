import QtQuick
import QtQuick.Layouts
import com.pocketbook.controls
import "."

/** Progress and activity. */
DemoSection {
    id: root

    title: "Indicators"

    readonly property int progressStep: 10

    RowLayout {
        width: parent.width
        spacing: Design.spacing

        ProgressBar {
            id: progressBar

            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            // ProgressBar is a bare Rectangle, so a layout has nothing else to size it by.
            Layout.preferredHeight: Design.progressBarHeight

            value: 40
        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            styledFont: FontStyles.BodyS
            color: Design.disabledTextColor
            text: `${progressBar.value}%`
        }
    }

    Row {
        spacing: Design.spacing

        RoundedCornerTextButton {
            width: Design.buttonWidth
            height: Design.textButtonHeight
            title: "Less"
            radius: Design.elementBorderRadius
            border.width: Design.borderThickness
            border.color: Design.borderColor
            onClicked: progressBar.value = Math.max(progressBar.minValue,
                                                    progressBar.value - root.progressStep)
        }

        RoundedCornerTextButton {
            width: Design.buttonWidth
            height: Design.textButtonHeight
            title: "More"
            radius: Design.elementBorderRadius
            border.width: Design.borderThickness
            border.color: Design.borderColor
            onClicked: progressBar.value = Math.min(progressBar.maxValue,
                                                    progressBar.value + root.progressStep)
        }
    }

    RowLayout {
        width: parent.width
        spacing: Design.spacing

        BusyIndicator {
            Layout.alignment: Qt.AlignVCenter
        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            styledFont: FontStyles.Body
            color: Design.textColor
            text: "BusyIndicator — one frame every 700 ms while it is visible"
        }
    }
}
