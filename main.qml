import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    width: 1600
    height: 900
    minimumWidth: 600
    minimumHeight: 850
    color: "#ffffff"
    title: qsTr("")

    // Объявляем свойства, которые будут хранить позицию зажатия курсора мыши
        property int previousX
        property int previousY
    // Аналогичные расчёты для остальных трёх областей ресайза
    MouseArea {
        id: bottomArea
        height: 5
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        cursorShape: Qt.SizeVerCursor

        onPressed: {
            previousY = mouseY
        }
        onMouseYChanged: {
            var dy = mouseY - previousY
            console.log(mainWindow.minimumHeight,mainWindow.height,dy)
            if (mainWindow.minimumHeight<=mainWindow.height+dy)
                mainWindow.setHeight(mainWindow.height + dy)
        }
    }

        MouseArea {
            id: topArea
            height: 5
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            // Устанавливаем форму курсора, чтобы было понятно, что это изменение размера
            cursorShape: Qt.SizeVerCursor

            onPressed: {
                // Запоминаем позицию по оси Y
                previousY = mouseY
            }

            // При изменении позиции делаем пересчёт позиции окна, и его высоты
            onMouseYChanged: {
                var dy = mouseY - previousY
                mainWindow.setY(mainWindow.y + dy)

                if (mainWindow.minimumHeight<=mainWindow.height-dy)
                    mainWindow.setHeight(mainWindow.height - dy)
            }
        }



        MouseArea {
            id: leftArea
            width: 5
            anchors {
                top: topArea.bottom
                bottom: bottomArea.top
                left: parent.left
            }
            cursorShape: Qt.SizeHorCursor

            onPressed: {
                previousX = mouseX
            }

            onMouseXChanged: {
                var dx = mouseX - previousX

                mainWindow.setX(mainWindow.x + dx)

                mainWindow.setWidth(mainWindow.width - dx)
            }
        }

        MouseArea {
            id: rightArea
            width: 5
            anchors {
                top: topArea.bottom
                bottom: bottomArea.top
                right: parent.right
            }
            cursorShape:  Qt.SizeHorCursor

            onPressed: {
                console.log(mainWindow.minimumHeight,mainWindow.width,dy)
                previousX = mouseX
            }

            onMouseXChanged: {

                var dx = mouseX - previousX
                console.log(mainWindow.minimumWidth,mainWindow.width,dx)
                if (mainWindow.minimumWidth>=mainWindow.width-dx)
                mainWindow.setWidth(mainWindow.width + dx)
            }
        }

        // Центральная область для перемещения окна приложения
        // Здесь уже потребуется использовать положение как по оси X, так и по оси Y
        MouseArea {
            anchors {
                top: topArea.bottom
                bottom: bottomArea.top
                left: leftArea.right
                right: rightArea.left
            }

            onPressed: {
                previousX = mouseX
                previousY = mouseY
            }

            onMouseXChanged: {
                var dx = mouseX - previousX
                mainWindow.setX(mainWindow.x + dx)
            }

            onMouseYChanged: {
                var dy = mouseY - previousY
                mainWindow.setY(mainWindow.y + dy)
            }
        }
    Rectangle {
        id: rectangle
        height: 31
        color: "#496ec2"
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Button {
            id: btnMenu
            width: 23
            height: 23
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 4
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
            width: 48
            height: 31
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0



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
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 32
        currentIndex: 0


        FirstPage {
            id: firstPage
        }
        SecondPage {
            id: termPage
            objectPlot: firstPage.objectPlot
        }
        FunctionsPage {
            id: functionsPage
        }



    }
footer: menuBar

    Menu {
        id:menu
        x:35
        y:5


            Action { text: qsTr("Главная")

                onTriggered: {
                    swipeView.currentIndex = 0

                }
            }
            Action { text: qsTr("Терминал")
                onTriggered: {
                    swipeView.currentIndex = 1

                }}
            Action { text: qsTr("Работа с графиками")
                onTriggered: {
                    swipeView.currentIndex = 2
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



























/*##^## Designer {
    D{i:1;anchors_height:31;anchors_width:1600;anchors_x:0;anchors_y:0}D{i:2;anchors_x:8;anchors_y:4}
D{i:5;anchors_y:0}D{i:9;anchors_height:868;anchors_width:1600;anchors_x:0;anchors_y:32}
}
 ##^##*/
