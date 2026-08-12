import QtQuick
import QtQuick.Window
import com.pocketbook.controls
import "."

Window {
    id: root

    // Sized from InkView: the QPA plugin ignores a request for fullscreen visibility, and a
    // Window that only asks for it ends up 0x0.
    visible: true
    width: deviceInfo.screenWidth
    height: deviceInfo.screenHeight - deviceInfo.panelHeight
    color: Design.backgroundColor
    title: "PocketBook kitchen sink"

    AppHeader {
        id: appHeader

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        title: root.title
        onClose: Qt.quit()
    }

    FocusScope {
        id: page

        anchors.top: appHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        focus: true

        // The scroll view keeps the focus, so only the keys it ignores arrive here.
        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape
                    || event.key === Qt.Key_Home) {
                event.accepted = true;
                Qt.quit();
            }
        }

        ScrollableContentView {
            anchors.fill: parent
            focus: true

            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Design.viewSideMargin
                anchors.rightMargin: Design.viewSideMargin

                spacing: Design.spacing

                TypographySection {
                    width: parent.width
                }

                ButtonsSection {
                    width: parent.width
                }

                SelectionSection {
                    width: parent.width
                }

                TextInputSection {
                    width: parent.width
                }

                IndicatorsSection {
                    width: parent.width
                }

                DecorationSection {
                    width: parent.width
                }

                DialogsSection {
                    width: parent.width

                    onConfirmationRequested: confirmationDialog.visible = true
                    onMessageRequested: function (text) {
                        infoMessage.message = text;
                        infoMessage.visible = true;
                    }
                }

                DeviceSection {
                    width: parent.width
                }
            }
        }
    }

    ActionConfirmationDialog {
        id: confirmationDialog

        anchors.fill: parent
        visible: false

        title: "ActionConfirmationDialog"
        message: "Nothing happens either way — this is here to show the shape of the "
                 + "firmware's own confirmation."
        applyTitle: "Apply"
        cancelTitle: "Cancel"

        onApply: confirmationDialog.visible = false
        onCancel: confirmationDialog.visible = false
        onClose: confirmationDialog.visible = false
    }

    InfoMessage {
        id: infoMessage

        anchors.fill: parent
        visible: false

        onClose: infoMessage.visible = false
    }
}
