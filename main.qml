import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtCharts 2.3

Window {
    id: mainWindow
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    width: 1600
    height: 900
    color: "#ffffff"
    title: qsTr("")

    signal signalExit

    GroupBox {
        id: groupBox
        x: 22
        y: 149
        width: 277
        height: 272
        font.family: "Arial"

        Label {
            id: label
            x: 133
            y: 7
            width: 115
            height: 42
            color: "#496ec2"
            text: qsTr("Время работы: 00 сек.")
            verticalAlignment: Text.AlignVCenter
            lineHeight: 0.8
        }

        GroupBox {
            id: groupBox1
            x: 3
            y: 71
            width: 248
            height: 177
            font.weight: Font.Normal
            title: ""

            Label {
                id: label1
                x: -12
                y: -29
                width: 134
                height: 19
                color: "#496ec2"
                text: qsTr("Выбор активного графика")
                verticalAlignment: Text.AlignVCenter
                lineHeight: 0.8
            }

            CheckDelegate {
                id: checkBoxTemp
                x: 0
                y: 0
                width: 224
                height: 36
                text: qsTr("Температура")
                display: AbstractButton.TextBesideIcon
                font.pixelSize: 14
            }

            CheckDelegate {
                id: checkBoxConcentrationCO2
                x: 0
                y: 59
                width: 224
                height: 36
                text: qsTr("Концентрация CO₂")
                font.pixelSize: 12
            }

            CheckDelegate {
                id: checkBoxConcentrationCH4
                x: 0
                y: 117
                width: 224
                height: 36
                text: qsTr("Концентрация CH₄")
                font.pixelSize: 14
            }
        }

        RoundButton {
            id: btnStartMeasure
            radius: 100
            z: 1
            Image{
                z: 1
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.fill: parent
                source: "icons/ButtonStart.png"
                fillMode: Image.Stretch
            }
            x: -1
            y: 6
            width: 105
            height: 43
        }
    }

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
                color: "#496ec2"
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
                color: mouseArea.containsMouse ?  "#2f4a87" : "#496ec2"


            }

        }
    }




    GroupBox {
        id: groupBox2
        x: 22
        y: 47
        width: 277
        height: 96
        title: qsTr("")

        Label {
            id: label2
            x: -12
            y: -28
            width: 134
            height: 18
            color: "#496ec2"
            text: qsTr("Com порт")
            verticalAlignment: Text.AlignVCenter
            lineHeight: 0.8
        }

        RoundButton {
            id: btnSOpenPort
            x: 179
            y: 0
            width: 74
            height: 28
            radius: 100
            Image {
                anchors.leftMargin: 0
                fillMode: Image.Stretch
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.fill: parent
                z: 1
                source: "icons/ButtonOpenPort.png"
            }
            z: 1
        }

        ComboBox {
            id: comboBox
            x: 0
            y: 0
            width: 163
            height: 28
        }
    }

    GroupBox {
        id: groupBox3
        x: 22
        y: 453
        width: 277
        height: 223
        title: qsTr("")

        TextField {
            id: textField
            x: 0
            y: 18
            width: 121
            height: 33
        }

        TextField {
            id: textField1
            x: 0
            y: 166
            width: 121
            height: 33
        }

        TextField {
            id: textField2
            x: 0
            y: 89
            width: 121
            height: 33
        }

        CheckBox {
            id: checkBox1
            x: 207
            y: 18
            width: 46
            height: 33
        }

        CheckBox {
            id: checkBox2
            x: 207
            y: 89
            width: 46
            height: 33
        }

        CheckBox {
            id: checkBox3
            x: 207
            y: 166
            width: 46
            height: 33
        }

        Label {
            id: label4
            x: 0
            y: 0
            width: 121
            height: 19
            color: "#496ec2"
            text: qsTr("Температура")
            verticalAlignment: Text.AlignVCenter
            lineHeight: 0.8
        }

        Label {
            id: label5
            x: 0
            y: 71
            width: 121
            height: 19
            color: "#496ec2"
            text: qsTr("Концентрация CO₂")
            verticalAlignment: Text.AlignVCenter
            lineHeight: 0.8
        }

        Label {
            id: label6
            x: 0
            y: 147
            width: 121
            height: 19
            color: "#496ec2"
            text: qsTr("Концентрация CH₄")
            verticalAlignment: Text.AlignVCenter
            lineHeight: 0.8
        }
    }

    Label {
        id: label3
        x: 22
        y: 433
        width: 180
        height: 19
        color: "#496ec2"
        text: qsTr("Установка предельных значений")
        verticalAlignment: Text.AlignVCenter
        lineHeight: 0.8
    }

    GroupBox {
        id: groupBox4
        x: 366
        y: 47
        width: 1194
        height: 629
        title: qsTr("")

        ChartView {
            id: line
            x: 0
            y: 0
            width: 1170
            height: 605
            LineSeries {
                name: "LineSeries"
                XYPoint {
                    x: 0
                    y: 2
                }

                XYPoint {
                    x: 1
                    y: 1.2
                }

                XYPoint {
                    x: 2
                    y: 3.3
                }

                XYPoint {
                    x: 5
                    y: 2.1
                }
            }
        }
    }


}





/*##^## Designer {
    D{i:22;anchors_height:28;anchors_width:163;anchors_x:0;anchors_y:0}
}
 ##^##*/
