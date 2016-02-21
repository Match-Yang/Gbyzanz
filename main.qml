import QtQuick 2.2
import Material 0.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2 as QuickControls
import Material.ListItems 0.1 as ListItem
import Controller 1.0

ApplicationWindow {
    id: mainWin

    width: Units.dp(430)
    height: Units.dp(480)
    visible: true
    title: qsTr("Gbyzanz")

    theme {
        primaryColor: controller.getThemePColor()
        accentColor: controller.getThemeAColor()
        backgroundColor: controller.getThemeBColor()
        primaryDarkColor: Palette.colors["blue"]["700"]
        tabHighlightColor: "white"
    }

    function saveAllConfig() {
        controller.saveConfig(grabRectItem.getRect(),
                              fileNameItem.getFileFormat(),
                              durationField.useDuration,
                              durationField.getDuration(),
                              durationField.useCommand,
                              durationField.getCommand(),
                              audioCheckBox.checked,
                              cursorCheckBox.checked)
    }

    Controller {
        id:controller

        function getThemePColor() {
            var colorName = controller.getThemePrimaryColor();
            if (colorName == "") {
                return Palette.colors["blue"]["500"]
            }
            else {
                return colorName
            }
        }

        function getThemeAColor() {
            var colorName = controller.getThemeAccentColor();
            if (colorName == "") {
                return Palette.colors["red"]["A200"]
            }
            else {
                return colorName
            }
        }

        function getThemeBColor() {
            var colorName = controller.getThemeBackgroundColor();
            if (colorName == "") {
                return "white"
            }
            else {
                return colorName
            }
        }

        onRecordFinished: {
            if (exitCode == 0) {
                fileNameItem.regenerateName()
                progressBar.setValue(0)
            }
            else
                print ("Record error:", exitCode, errorString)

        }
    }

    initialPage: Page {
        id: page

        title: "Gbyzanz"

        actions: [
            Action {
                iconName: "file/folder"
                name: qsTr("Open the storage folder")
                onTriggered: {
                    Qt.openUrlExternally("file://" + controller.getSavePath())
                    print ("Open the storage folder")
                }
            },
            Action {
                iconName: "image/color_lens"
                name: qsTr("Style")
                onTriggered: colorPicker.show()
            }
        ]

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

                GrabRectItem {
                    id: grabRectItem
                }

                FileNameItem {
                    id: fileNameItem
                }

                DurationFiled {
                    id: durationField
                    width: parent.width
                }

                RowLayout {
                    Layout.preferredHeight: Units.dp(48)

                    anchors.left: parent.left
                    anchors.leftMargin: Units.dp(16)

                    CheckBox {
                        id: audioCheckBox
                        checked: controller.recordAudio()
                        text: qsTr("Record audio")
                        darkBackground: false
                        enabled: {
                            var ff = fileNameItem.getFileFormat()
                            return (ff == ".webm" || ff == ".ogg" || ff == ".ogv" || ff == ".byzanz")
                        }
                    }


                    CheckBox {
                        id: cursorCheckBox
                        checked: controller.recordCursor()
                        text: qsTr("Record mouse cursor")
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
                        text: qsTr("Cancel")
                        textColor: Theme.primaryColor
                        onClicked: {
                            saveAllConfig()
                            Qt.quit()
                        }
                    }

                    Button {
                        text: qsTr("Record")
                        textColor: Theme.primaryColor
                        onClicked: {
                            controller.recordScreen(Qt.rect(grabRectItem.getXValue(),
                                                            grabRectItem.getYValue(),
                                                            grabRectItem.getWidthValue(),
                                                            grabRectItem.getHeightValue()),
                                                    fileNameItem.getFileName(),
                                                    durationField.getDuration(),
                                                    durationField.getCommand(),
                                                    (audioCheckBox.checked && audioCheckBox.enabled),
                                                    cursorCheckBox.checked);
                            if (durationField.useDuration)
                                progressAnimation.start()

                            saveAllConfig()
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
                        duration: 1000 * durationField.getDuration()
                        from: 0
                        to: 1
                    }
                }
            }
        }
    }

    Dialog {
        id: colorPicker
        title: "Pick color"

        positiveButtonText: "Done"

        MenuField {
            id: selection
            model: ["Primary color", "Accent color", "Background color"]
            width: Units.dp(160)
        }

        Grid {
            columns: 7
            spacing: Units.dp(8)

            Repeater {
                model: [
                    "red", "pink", "purple", "deepPurple", "indigo",
                    "blue", "lightBlue", "cyan", "teal", "green",
                    "lightGreen", "lime", "yellow", "amber", "orange",
                    "deepOrange", "grey", "blueGrey", "brown", "black",
                    "white"
                ]

                Rectangle {
                    width: Units.dp(30)
                    height: Units.dp(30)
                    radius: Units.dp(2)
                    color: Palette.colors[modelData]["500"]
                    border.width: modelData === "white" ? Units.dp(2) : 0
                    border.color: Theme.alpha("#000", 0.26)

                    Ink {
                        anchors.fill: parent

                        onPressed: {
                            switch(selection.selectedIndex) {
                                case 0:
                                    theme.primaryColor = parent.color
                                    break;
                                case 1:
                                    theme.accentColor = parent.color
                                    break;
                                case 2:
                                    theme.backgroundColor = parent.color
                                    break;
                            }

                            controller.saveThemeColor(theme.primaryColor, theme.accentColor, theme.backgroundColor)
                        }
                    }
                }
            }
        }
    }

}
