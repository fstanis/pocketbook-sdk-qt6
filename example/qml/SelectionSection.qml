import QtQuick
import QtQuick.Layouts
import com.pocketbook.controls
import "."

/** The two selection controls, neither of which changes its own state on a tap. */
DemoSection {
    id: root

    title: "Selection"

    readonly property var checkBoxStateNames: ["unchecked", "checked", "partially checked"]
    property int selectedChoice: 0

    RowLayout {
        width: parent.width
        spacing: Design.spacing

        CheckBox {
            id: checkBox

            Layout.alignment: Qt.AlignVCenter
            onClicked: checkBox.checked = (checkBox.checked + 1) % root.checkBoxStateNames.length
        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            styledFont: FontStyles.Body
            color: Design.textColor
            text: `CheckBox — ${root.checkBoxStateNames[checkBox.checked]}, tap to cycle`
        }
    }

    Repeater {
        model: ["RadioButton — first choice", "RadioButton — second choice",
                "RadioButton — third choice"]

        RadioButton {
            required property string modelData
            required property int index

            width: parent.width
            height: Design.listItemHeight
            title: modelData
            checked: index === root.selectedChoice
            onCheck: root.selectedChoice = index
        }
    }
}
