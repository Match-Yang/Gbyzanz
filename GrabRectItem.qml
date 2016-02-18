import QtQuick 2.0
import Material 0.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2 as QuickControls
import Material.ListItems 0.1 as ListItem
import Controller 1.0

ListItem.Standard {

    function setRect(x, y, w, h) {
        xField.text = x
        yField.text = y
        widthField.text = w
        heightField.text = h
    }

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

    Loader {
        id: capturerLoader
        property bool initFlag: true
        sourceComponent: ScreenCapturer {
            onConfirm: {
                setRect(pos.x, pos.y, w, h)
                mainWin.show()
                capturerLoader.active = false
            }
            onCancel: {
                mainWin.show()
                capturerLoader.active = false
            }
            Component.onCompleted: {
                showFullScreen()
            }
        }
        //fixme: ScreenCapturer's background can not be transparent if showFullScreen() not call at initialization
        Timer {
            interval: 1
            repeat: false
            onTriggered: capturerLoader.active = false
            Component.onCompleted: start()
        }
    }

    Controller {id: controller}

    action: IconButton {
        id: grabScreenButton

        action: Action {
            iconName: "image/transform"
            name: qsTr("Click to select the region that will be recorded")
            onTriggered: {
                print("grab the screen area...")
                mainWin.hide()
                capturerLoader.active = true
            }
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
            validator: IntValidator {}

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
            validator: IntValidator {}

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
            validator: IntValidator {}

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
            validator: IntValidator {}

            function getValue() {
                if (text == "")
                    return 0;
                else
                    return Number(text)
            }
        }
    }
}

