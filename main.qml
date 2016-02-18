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
        primaryColor: Palette.colors["blue"]["500"]
        primaryDarkColor: Palette.colors["blue"]["700"]
        accentColor: Palette.colors["red"]["A200"]
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
            }
        ]

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
                        text: "Record audio"
                        darkBackground: false
                        enabled: {
                            var ff = fileNameItem.getFileFormat()
                            return (ff == ".webm" || ff == ".ogg" || ff == ".ogv" || ff == ".byzanz")
                        }
                    }


                    CheckBox {
                        id: cursorCheckBox
                        checked: controller.recordCursor()
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
                        onClicked: {
                            saveAllConfig()
                            Qt.quit()
                        }
                    }

                    Button {
                        text: "Record"
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

}
