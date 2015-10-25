import QtQuick 2.0
import Material 0.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0
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

    property var _formatList: [".gif", ".flv", ".ogg", ".ogv", ".webm", ".byzanz"]
    property string _savePath: ""

    Component.onCompleted: {
        var tmpIndex = _formatList.indexOf(controller.getFileFormat())
        if (tmpIndex != -1)
            fileFormatMenu.selectedIndex = tmpIndex
        fileDialog.folder = "file://" + controller.getSavePath()
    }

    Controller {id: controller}

    FileDialog {
        id: fileDialog
        title: qsTr("Please choose a folder")
        selectExisting: true
        selectFolder: true
        selectMultiple: false
        onAccepted: {
            controller.saveFilePath(fileDialog.folder.toString().replace("file:///", "/"))
            visible = false
        }
        onRejected: {
            visible = false
        }
    }

    action: IconButton {
        id: fileNameButton

        action: Action {
            iconName: "content/save"
            name: qsTr("Change storage folder")
            onTriggered: fileDialog.visible = true
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

            model: _formatList
        }
    }
}

