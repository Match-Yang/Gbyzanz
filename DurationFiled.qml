import QtQuick 2.0
import Material 0.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2 as QuickControls
import Material.ListItems 0.1 as ListItem
import Controller 1.0

ColumnLayout {
    Layout.preferredWidth: parent.width

    property alias useDuration: durationRadio.checked
    property alias useCommand: commandRadio.checked

    function getDuration() {
        return durationTextField.getValue()
    }

    function getCommand() {
        return commTextField.getValue()
    }

    Component.onCompleted: {
        durationRadio.checked = controller.useDuration()
        durationTextField.text = controller.duration()
        commandRadio.checked = controller.useCommand()
        commTextField.text = controller.command()
    }

    Controller {id: controller}

    QuickControls.ExclusiveGroup { id: durationGroup }

    ListItem.Standard {
        implicitHeight:Units.dp(70)
        action: RadioButton {
            id: durationRadio
            text: "Duration(Second)"
            canToggle: true
            exclusiveGroup: durationGroup
        }

        content: TextField {
            id: durationTextField
            validator: IntValidator {}
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - durationRadio.width
            text: "10"
            horizontalAlignment: Qt.AlignHCenter

            function getValue() {
                if (!durationRadio.checked || text == "")
                    return 0;
                else
                    return Number(text)
            }
        }
    }

    ListItem.Standard {
        action: RadioButton {
            id:commandRadio
            text: "Command"
            canToggle: true
            exclusiveGroup: durationGroup
        }

        content: TextField {
            id: commTextField
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - commandRadio.width
            helperText: "Record untill the command exit."

            function getValue() {
                if (!commandRadio.checked)
                    return ""
                else
                    return text
            }
        }
    }
}

