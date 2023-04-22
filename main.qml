import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    width: 1600
    height: 900
    color: "#ffffff"
    title: qsTr("")

    signal signalExit

    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: 1600
        height: 31
        color: "#496ec2"

        Button {
            id: btnMenu
            x: 8
            y: 4
            width: 23
            height: 23
            focusPolicy: Qt.NoFocus
            background: Rectangle {
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.fill: parent
                color: mouseArea.containsMouse ?  "#2f4a87" : "#496ec2"


            }
            Image{
                z: 1
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.fill: parent
                source: "icons/MenuButton.png"
                fillMode: Image.Stretch
            }
            onClicked: {

                menu.visible = !menu.visible

            }

        }

        Button {
            id: btnCloseWindow
            x: 1552
            y: 0
            width: 48
            height: 31



            MouseArea {
                id: mouseArea
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    mainWindow.close()
                }
            }

            Image {
                anchors.leftMargin: 0
                fillMode: Image.Stretch
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.fill: parent
                z: 1
                source: "icons/CloseButton.png"
            }


            focusPolicy: Qt.NoFocus
            background: Rectangle {
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.fill: parent
                color: mouseArea.containsMouse ?  "#2f4a87" : "#496ec2"


            }

        }
    }

    SwipeView {
        id: swipeView
        x: 0
        y: 32
        width: 1600
        height: 868
        currentIndex: 0

        FirstPage {
            id: firstPage
        }

        SecondPage {
            id: secondPage
        }
    }
footer: MenuBar
menuBar: MenuBar
    Menu {
        id:menu
        x:35
        y:5
            title: qsTr("&File")

            Action { text: qsTr("Главная")
                onTriggered: {
                    firstPage.visible = true;
                    secondPage.visible = false;
                }
            }
            Action { text: qsTr("Терминал")
                onTriggered: {
                    firstPage.visible = false;
                    secondPage.visible = true;
                }}


            MenuSeparator { }

            Action { text: qsTr("О программе") }
            Action { text: qsTr("Выход")
                onTriggered: {
                    mainWindow.close()

                }
            }
        }



}
















