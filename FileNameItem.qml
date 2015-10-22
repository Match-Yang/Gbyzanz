import QtQuick 2.0
import Material 0.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2 as QuickControls
import Material.ListItems 0.1 as ListItem
import Controller 1.0

ListItem.Standard {

    function getFileName() {
        return controller.getSavePath() + "/" + fileNameField.text + fileFormatMenu.selectedText
    }

    function getFileFormat() {
        return fileFormatMenu.selectedText
    }

    function regenerateName() {
        fileNameField.regenerateName()
    }

    Controller {
        id: controller
    }

    action: IconButton {
        id: fileNameButton

        action: Action {
            iconName: "content/save"
            name: qsTr("Regenerate the file name")
            onTriggered: fileNameField.regenerateName()
        }

        hoverAnimation: true
        color: Theme.light.iconColor
        size: Units.dp(24)
        anchors.centerIn: parent
    }

    content: RowLayout {
        anchors.centerIn: parent
        width: parent.width

        TextField {
            id: fileNameField
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 0.7 * parent.width

            function regenerateName() {
                text = "Gbyzanz" + new Date().toLocaleString( Qt.locale(), "yyyyMMddhhmmss")
            }

            Component.onCompleted: regenerateName()
        }

        MenuField {
            id: fileFormatMenu
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 0.3 * parent.width

            model: [".gif", ".flv", ".ogg", ".ogv", ".webm", ".byzanz"]
        }
    }
}

