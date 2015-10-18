import QtQuick 2.2
import Material 0.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2 as QuickControls
import Material.ListItems 0.1 as ListItem
import Controller 1.0

ApplicationWindow {
    id: demo

    width: 300
    height: 320
    visible: true
    title: qsTr("Gbyzanz")

    theme {
        primaryColor: Palette.colors["blue"]["500"]
        primaryDarkColor: Palette.colors["blue"]["700"]
        accentColor: Palette.colors["red"]["A200"]
        tabHighlightColor: "white"
    }

    Controller {
        id:controller
        onRecordFinished: {
            if (exitCode == 0) {
                fileNameField.regenerateName()
                progressBar.setValue(0)
                controller.saveConfig()
            }
            else
                print ("Record error:", exitCode, errorString)

        }
    }

    initialPage: Page {
        id: page

        title: qsTr("Gbyzanz")

        backAction: Action {
            iconName: "image/dehaze"
            name: qsTr("Specification")
            onTriggered: print("Show specification...")
        }


        Item {
            anchors.fill: parent

            ColumnLayout {
                id: column

                anchors {
                    fill: parent
                    topMargin: Units.dp(16)
                    bottomMargin: Units.dp(16)
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Units.dp(8)
                }

                ListItem.Standard {
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
                            placeholderText: "X"

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
                            placeholderText: "Y"

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
                            placeholderText: "Width"

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
                            placeholderText: "Height"


                            function getValue() {
                                if (text == "")
                                    return 0;
                                else
                                    return Number(text)
                            }
                        }
                    }
                }

                ListItem.Standard {
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

                QuickControls.ExclusiveGroup { id: durationGroup }

                ListItem.Standard {
                    implicitHeight:Units.dp(70)
                    action: RadioButton {
                        id: durationRadio
                        checked: true
                        text: "Duration(Second)"
                        canToggle: true
                        exclusiveGroup: durationGroup
                    }

                    content: TextField {
                        id: durationTextField
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
                    }
                }

                RowLayout {
                    Layout.preferredHeight: Units.dp(48)

                    anchors.left: parent.left
                    anchors.leftMargin: Units.dp(16)

                    CheckBox {
                        id: audioCheckBox
                        checked: true
                        text: "Record audio"
                        darkBackground: false
                        enabled: {
                            var ff = fileFormatMenu.selectedText
                            return (ff == ".webm" || ff == ".ogg" || ff == ".ogv" || ff == ".byzanz")
                        }
                    }


                    CheckBox {
                        id: cursorCheckBox
                        checked: true
                        text: "Record mouse cursor"
                        darkBackground: false
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Units.dp(8)
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: Units.dp(8)

                    anchors {
                        right: parent.right
                        margins: Units.dp(16)
                    }

                    Button {
                        text: "Cancel"
                        textColor: Theme.primaryColor
                        onClicked: Qt.quit()
                    }

                    Button {
                        text: "Record"
                        textColor: Theme.primaryColor
                        onClicked: {
                            controller.recordScreen(Qt.rect(xField.getValue(),
                                                            yField.getValue(),
                                                            widthField.getValue(),
                                                            heightField.getValue()),
                                                    fileNameField.text + fileFormatMenu.selectedText,
                                                    durationTextField.getValue(),
                                                    commTextField.text,
                                                    (audioCheckBox.checked && audioCheckBox.enabled),
                                                    cursorCheckBox.checked);
                            if (durationRadio.checked)
                                progressAnimation.start()
                        }
                    }
                }
            }

            ProgressBar {
                id: progressBar
                width: parent.width
                anchors.bottom: parent.bottom
                color: theme.accentColor

                SequentialAnimation on value {
                    running: false
                    id: progressAnimation

                    NumberAnimation {
                        duration: 1000 * durationTextField.getValue()
                        from: 0
                        to: 1
                    }
                }
            }
        }
    }

}
