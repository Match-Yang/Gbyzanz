import QtQuick 2.0
import Material 0.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2 as QuickControls
import Material.ListItems 0.1 as ListItem
import Controller 1.0

ListItem.Standard {

    function getRect() {
        return Qt.rect(getXValue(), getYValue(), getWidthValue(), getHeightValue())
    }

    function getXValue() {
        return xField.getValue()
    }

    function getYValue() {
        return yField.getValue()
    }

    function getWidthValue() {
        return widthField.getValue()
    }

    function getHeightValue() {
        return heightField.getValue()
    }

    Component.onCompleted: {
        xField.text = controller.getRecordRect().x
        yField.text = controller.getRecordRect().y
        widthField.text = controller.getRecordRect().width
        heightField.text = controller.getRecordRect().height
    }

    Controller {id: controller}

    action: IconButton {
        id: grabScreenButton

        action: Action {
            iconName: "image/transform"
            name: qsTr("Click to select the region that will be recorded")
            onTriggered: print("grab the screen area...")
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
            id: xField
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.25 * parent.width

            floatingLabel: true
            placeholderText: qsTr("X")

            function getValue() {
                if (text == "")
                    return 0;
                else
                    return Number(text)
            }
        }

        TextField {
            id: yField
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.25 * parent.width

            floatingLabel: true
            placeholderText: qsTr("Y")

            function getValue() {
                if (text == "")
                    return 0;
                else
                    return Number(text)
            }
        }

        TextField {
            id: widthField
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.25 * parent.width

            floatingLabel: true
            placeholderText: qsTr("Width")

            function getValue() {
                if (text == "")
                    return 0;
                else
                    return Number(text)
            }
        }

        TextField {
            id: heightField
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.25 * parent.width

            floatingLabel: true
            placeholderText: qsTr("Height")


            function getValue() {
                if (text == "")
                    return 0;
                else
                    return Number(text)
            }
        }
    }
}

