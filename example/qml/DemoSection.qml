import QtQuick
import com.pocketbook.controls
import "."

/** One titled group of firmware components, sized to whatever is placed inside it. */
Item {
    id: root

    default property alias content: body.data
    property string title: ""

    // ScrollableContentView takes its content height from childrenRect, so sections have to
    // report a height rather than fill their parent.
    implicitHeight: header.height + body.height + 2 * Design.spacing

    SectionHeader {
        id: header

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        title: root.title
    }

    Column {
        id: body

        anchors.top: header.bottom
        anchors.topMargin: Design.spacing
        anchors.left: parent.left
        anchors.right: parent.right

        spacing: Design.spacing
    }

    CommonSeparator {}
}
