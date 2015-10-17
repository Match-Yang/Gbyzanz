import QtQuick 2.2
import Material 0.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2 as QuickControls
import Material.ListItems 0.1 as ListItem

ApplicationWindow {
    id: demo

    width: 300
    height: 320
    visible: true
    title: qsTr(" ")

    theme {
        primaryColor: Palette.colors["blue"]["500"]
        primaryDarkColor: Palette.colors["blue"]["700"]
        accentColor: Palette.colors["red"]["A200"]
        tabHighlightColor: "white"
    }

    property var styles: [
            "Icons", "Custom Icons", "Color Palette", "Typography"
    ]

    property var basicComponents: [
            "Button", "CheckBox", "Progress Bar", "Radio Button",
            "Slider", "Switch", "TextField"
    ]

    property var compoundComponents: [
            "Bottom Sheet", "Dialog", "Forms", "List Items", "Page Stack", "Time Picker", "Date Picker"
    ]

    property var sections: [ styles, basicComponents, compoundComponents ]

    property var sectionTitles: [ "Style", "Basic Components", "Compound Components" ]

    property string selectedComponent: styles[0]

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

            View {
                anchors.top: parent.top

                width: parent.width
                height: column.implicitHeight + Units.dp(32)

                elevation: 1
                radius: Units.dp(2)

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
                        action: Icon {
                            anchors.centerIn: parent
                            name: "maps/place"
                        }

                        content: RowLayout {
                            anchors.centerIn: parent
                            width: parent.width

                            TextField {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.preferredWidth: 0.25 * parent.width

                                floatingLabel: true
                                placeholderText: "X"
                            }

                            TextField {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.preferredWidth: 0.25 * parent.width

                                floatingLabel: true
                                placeholderText: "Y"
                            }

                            TextField {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.preferredWidth: 0.25 * parent.width

                                floatingLabel: true
                                placeholderText: "Width"
                            }

                            TextField {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.preferredWidth: 0.25 * parent.width

                                floatingLabel: true
                                placeholderText: "Height"
                            }
                        }
                    }

                    ListItem.Standard {
                        action: Icon {
                            anchors.centerIn: parent
                            name: "maps/place"
                        }

                        content: RowLayout {
                            anchors.centerIn: parent
                            width: parent.width

                            TextField {
                                Layout.alignment: Qt.AlignCenter
                                Layout.preferredWidth: 0.7 * parent.width

                                placeholderText: "File name"

                                function generateName() {
                                    return "Test name"
                                }
                            }

                            MenuField {
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
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - durationRadio.width
                            text: "10"
                            horizontalAlignment: Qt.AlignHCenter
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
                            checked: true
                            text: "Record audio"
                            darkBackground: false
                        }


                        CheckBox {
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
                        }

                        Button {
                            text: "Done"
                            textColor: Theme.primaryColor
                        }
                    }
                }
            }
        }
    }

}
