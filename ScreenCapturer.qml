/*************************************************************
*File Name: ScreenCapturer.qml
*Author: Match
*Email: Match.YangWanQing@gmail.com
*Created Time: 2016年02月18日 星期四 19时55分58秒
*Description:
*
*************************************************************/
import QtQuick 2.3
import QtQuick.Window 2.2

Window {
    id: screenCapturer

    color: "transparent"
    flags: Qt.Dialog


    property point m_startPoint: Qt.point(0, 0)

    signal confirm(point pos, real w, real h)
    signal cancel()

    Canvas {
        id: canvas
        opacity: 1
        anchors.fill: parent
        property point startPos: Qt.point(0, 0)
        property point endPos: Qt.point(0, 0)
        property real borderWidth: 1
        property color borderColor: "#26ae90"
        property color contentColor: "transparent"

        function updatePos(pos) {
            startPos = m_startPoint
            endPos = pos

            var ltp = getLeftTopPos()
            var rbp = getRightBottomPos()
            posRec.updatePos(ltp, rbp)
            buttonRec.updatePos(ltp, rbp)
        }

        function getLeftTopPos() {
            if (startPos.x < endPos.x && startPos.y < endPos.y) {
                return startPos;
            }
            else if (startPos.x < endPos.x && startPos.y > endPos.y){
                return Qt.point(startPos.x, endPos.y);
            }
            else if (startPos.x > endPos.x && startPos.y > endPos.y) {
                return endPos;
            }
            else {
                return Qt.point(endPos.x, startPos.y);
            }
        }

        function getRightBottomPos() {
            if (startPos.x < endPos.x && startPos.y < endPos.y) {
                return endPos;
            }
            else if (startPos.x < endPos.x && startPos.y > endPos.y){
                return Qt.point(endPos.x, startPos.y);
            }
            else if (startPos.x > endPos.x && startPos.y > endPos.y) {
                return startPos;
            }
            else {
                return Qt.point(startPos.x, endPos.y);
            }
        }

        onPaint: {
            var ctx = getContext('2d')

            //clear whole cancas
            ctx.clearRect(canvas.x, canvas.y, canvas.width, canvas.height)

            //draw background
            ctx.fillStyle = Qt.rgba(0, 0, 0, 0.3)
            ctx.fillRect(canvas.x, canvas.y, canvas.width, canvas.height)

            //draw select Rectangle border
            ctx.lineWidth = borderWidth
            ctx.strokeStyle = borderColor
            ctx.strokeRect(startPos.x, startPos.y, endPos.x - startPos.x, endPos.y - startPos.y)

            //fill select Rectangle
            ctx.clearRect(startPos.x, startPos.y, endPos.x - startPos.x, endPos.y - startPos.y)
        }

        Rectangle {
            id: posRec

            visible: false
            color: Qt.rgba(0, 0, 0, 0.7)
            radius: 3
            width: posText.contentWidth + 6
            height: posText.contentHeight + 6

            function updatePos(ltp, rbp) {
                var ps = "[%1,%2] [%3X%4]"
                posText.text = ps.arg(ltp.x).arg(ltp.y).arg(rbp.x - ltp.x).arg(rbp.y - ltp.y)

                if ((ltp.x + posRec.width) > canvas.width) {
                    posRec.x = rbp.x - posRec.width
                }
                else {
                    posRec.x = ltp.x
                }

                if (ltp.y < posRec.height) {
                    posRec.y = ltp.y
                }
                else {
                    posRec.y = ltp.y - posRec.height
                }
            }

            Text {
                id: posText
                font.pixelSize: 15
                color: "white"
                anchors.centerIn: parent
            }
        }

        Rectangle {
            id: buttonRec
            visible: false
            width: childrenRect.width
            height: childrenRect.height
            color: Qt.rgba(0, 0, 0, 0.7)
            radius: 3

            function updatePos(ltp, rbp) {
                if ((rbp.x - buttonRec.width) < 0) {
                    buttonRec.x = ltp.x
                }
                else {
                    buttonRec.x = rbp.x - buttonRec.width
                }

                if ((buttonRec.height + rbp.y) > canvas.height) {
                    buttonRec.y = rbp.y - buttonRec.height
                }
                else {
                    buttonRec.y = rbp.y
                }
            }

            Row {
                Rectangle {
                    color: "transparent"
                    radius: 3
                    width: 60
                    height: okText.contentHeight + 6

                    Text {
                        id: okText
                        anchors.centerIn: parent
                        text: qsTr("OK")
                        font.pixelSize: 15
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            parent.color = "#016be3"
                        }
                        onExited: {
                            parent.color = "transparent"
                        }
                        onPressed: {
                            var ltp = canvas.getLeftTopPos()
                            var rbp = canvas.getRightBottomPos()
                            screenCapturer.confirm(ltp, rbp.x - ltp.x, rbp.y - ltp.y)
                            screenCapturer.close()
                        }
                    }
                }

                Rectangle {
                    color: "transparent"
                    radius: 3
                    width: 60
                    height: cancelText.contentHeight + 6

                    Text {
                        id: cancelText
                        anchors.centerIn: parent
                        text: qsTr("Cancel")
                        font.pixelSize: 15
                        color: "white"
                    }

                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        onEntered: {
                            parent.color = "#ef2928"
                        }
                        onExited: {
                            parent.color = "transparent"
                        }
                        onClicked: {
                            screenCapturer.cancel()
                            screenCapturer.close()
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        id: ma
        z: -1
        anchors.fill: parent
        onPressed: {
            m_startPoint.x = mouse.x
            m_startPoint.y = mouse.y
            posRec.visible = true
            buttonRec.visible = true
        }
        onReleased: {
            console.log("Drag Done:", m_startPoint, "-->", Qt.point(mouse.x, mouse.y))
        }
        onPositionChanged: {
            canvas.updatePos(Qt.point(mouse.x, mouse.y))
            canvas.requestPaint()
        }
    }
}


