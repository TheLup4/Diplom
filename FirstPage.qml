import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2


Item {
    id:firstPage
    property var objectPlot: graph.plot
    width: 1600
    height: 848
    GroupBox {
        id: groupBox
        x: 22
        y: 149
        width: 277
        height: 272
        z: -1
        font.family: "Arial"
        Label {
            id: label
            x: 3
            y: 0
            width: 148
            height: 43
            color: "#496ec2"
            text: qsTr("Время работы: 00 сек.")
            horizontalAlignment: Text.AlignHCenter
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
        }


        GroupBox {
            id: groupBox1
            x: 3
            y: 71
            width: 248
            height: 177
            z: 2
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
                lineHeight: 0.8
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: label7
                x: -5
                y: 0
                width: 97
                height: 35
                color: "#496ec2"
                text: qsTr("Температура")
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: label8
                x: -5
                y: 105
                width: 143
                height: 35
                color: "#496ec2"
                text: qsTr("Концентрация CH₄")
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: label9
                x: -5
                y: 48
                width: 141
                height: 35
                color: "#496ec2"
                text: qsTr("Концентрация CO₂")
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        CheckBox {
            id: checkBoxTermGraph
            x: 194
            y: 84
            width: 46
            height: 33
            checked: true
        }

        CheckBox {
            id: checkBoxCO2Graph
            x: 194
            y: 133
            width: 46
            height: 33
            checked: true
        }

        CheckBox {
            id: checkBoxCH4Graph
            x: 194
            y: 192
            width: 46
            height: 33
            checked: true
        }
    }

    GroupBox {
        id: groupBox2
        x: 22
        y: 47
        width: 277
        height: 96
        anchors.bottom: groupBox4.top
        anchors.bottomMargin: -96
        anchors.right: groupBox4.left
        anchors.rightMargin: 62
        z: 1
        title: qsTr("")
        Label {
            id: label2
            x: -12
            y: -28
            width: 134
            height: 18
            color: "#496ec2"
            text: qsTr("Com порт")
            z: 2
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
        }

        RoundButton {
            id: btnOpenPort
            x: 179
            y: 0
            width: 74
            height: 28
            contentItem: Rectangle{
            color: "#496ec2"
            radius: 50
            anchors.fill: parent
            Text{
                id:btnOpenText
                color: "#ffffff"
                text:"Открыть"
                anchors.centerIn: parent

            }
         }

            onClicked: {


                if(objectPlot.portIsOpen() && btnOpenText.text == "Закрыть"){
                btnOpenText.text = "Открыть"
                    objectPlot.closePort()
                    labelPortStatus.text = "Статус порта: Закрыт"
                    comboBoxCom.enabled = true
                }
                else{
                    if (!objectPlot.portIsOpen() && btnOpenText.text == "Открыть"){
                    objectPlot.openPort(comboBoxCom.currentText)
                       if(objectPlot.portIsOpen()){
                    btnOpenText.text = "Закрыть"
                        labelPortStatus.text = "Статус порта: Открыт"
                    comboBoxCom.enabled = false
                       }
                    }
                }
            }

        }

        ComboBox {
            id: comboBoxCom
            anchors.right: parent.right
            anchors.rightMargin: 90
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 44
            anchors.top: parent.top
            anchors.topMargin: 0
            font.pixelSize: 12

            model: ListModel
            {
                id:comElements
            }
            delegate: ItemDelegate {
                id:delegat

                      width: comboBoxCom.width
                      contentItem: Text {
                          text:modelData
                        font.pixelSize: 12
                        color:"#496ec2"


                        verticalAlignment: Text.AlignVCente
                        horizontalAlignment: Text.AlignHCenter

                }
                      anchors.horizontalCenter: parent.horizontalCenter
                      anchors.left: parent.left

            }

            Component.onCompleted:{
                var list = objectPlot.updatePortCombobox()
                console.debug(list);
                for (var i =0;i<list.length;i++)
                    comElements.append({"text": list[i]} )

            }
        }

        RoundButton {
            id: btnUpdatePort
            x: 179
            y: 34
            width: 74
            height: 28
            contentItem: Rectangle{
            color: "#496ec2"
            radius: 50
            anchors.fill: parent
            Text{
                color: "#ffffff"
                text:"Обновить"
                anchors.centerIn: parent

            }
            }


            onClicked: {
                comElements.clear()
                var list = objectPlot.updatePortCombobox()
                console.debug(list);
                for (var i =0;i<list.length;i++)
                    comElements.append({"text": list[i]})

            }
        }

        Label {
            id: labelPortStatus
            color: "#496ec2"
            text: qsTr("Статус порта: Закрыт")
            anchors.right: parent.right
            anchors.rightMargin: 114
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            anchors.top: parent.top
            anchors.topMargin: 40
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
            id: textFieldTemp
            x: 0
            y: 18
            width: 121
            height: 39
            text: "0"
            z: 1
            font.pointSize: 10
            onTextChanged: {
            if (checkBoxTemp.checked)
                objectPlot.setLimits(3,true,text.toString())

            }
        }

        TextField {
            id: textFieldCH4
            x: 0
            y: 166
            width: 121
            height: 40
            text: "0"
            font.pointSize: 10
            onTextChanged: {
            if (checkBoxCH4.checked)
                objectPlot.setLimits(5,true,text.toString())

            }

        }

        TextField {
            id: textFieldCO2
            x: 0
            y: 89
            width: 121
            height: 38
            text: "0"
            font.pointSize: 10
            onTextChanged: {
                if (checkBoxCO2.checked)
                objectPlot.setLimits(4,true,text.toString())

            }
        }

        CheckBox {
            id: checkBoxTemp
            x: 186
            y: 18
            width: 46
            height: 33
            onCheckedChanged: {
                if (checked)
                    objectPlot.setLimits(3,true,text.toString())
                else
                    objectPlot.setLimits(3,false,text.toString())
                }
            }


        CheckBox {
            id: checkBoxCO2
            x: 186
            y: 89
            width: 46
            height: 33
            onCheckedChanged: {
                if (checked)
                    objectPlot.setLimits(4,true,text.toString())
                else
                    objectPlot.setLimits(4,false,text.toString())
                }
        }

        CheckBox {
            id: checkBoxCH4
            x: 186
            y: 166
            width: 46
            height: 33
            onCheckedChanged: {
                if (checked)
                    objectPlot.setLimits(5,true,text.toString())
                else
                    objectPlot.setLimits(5,false,text.toString())
                }
        }

        Label {
            id: label4
            x: 0
            y: 0
            width: 121
            height: 19
            color: "#496ec2"
            text: qsTr("Температура")
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: label5
            x: 0
            y: 71
            width: 121
            height: 19
            color: "#496ec2"
            text: qsTr("Концентрация CO₂")
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: label6
            x: 0
            y: 147
            width: 121
            height: 19
            color: "#496ec2"
            text: qsTr("Концентрация CH₄")
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: label3
            x: -12
            y: -32
            width: 180
            height: 19
            color: "#496ec2"
            text: qsTr("Установка предельных значений")
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: label10
            x: -12
            y: 219
            width: 180
            height: 19
            color: "#496ec2"
            text: qsTr("Работа с файлами")
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
        }
    }

    GroupBox {
        id: groupBox4
        anchors.top: parent.top
        anchors.topMargin: 47
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 34
        anchors.left: parent.left
        anchors.leftMargin: 361
        anchors.right: parent.right
        anchors.rightMargin: 40
        title: qsTr("")
        Plot {
            id: graph
            width: 54
            height: 35
            anchors.fill: parent
        }
    }

    GroupBox {
        id: groupBox5
        x: 22
        y: 703
        width: 277
        height: 111
        title: qsTr("")

        RoundButton {
            id: btnChooseFile
            x: 61
            y: 0
            width: 132
            height: 43
            contentItem: Rectangle{
            color: "#496ec2"
            radius: 50
            anchors.fill: parent
            Text{
                id:btnFileText
                color: "#ffffff"
                text:"Запись в файл"
                anchors.centerIn: parent

            }

         }
            onClicked: {
            fileDialog.visible = true
            }
        }

        Label {
            id: labelDir
            x: -12
            y: 37
            width: 277
            height: 62
            color: "#496ec2"
            text: qsTr("Директория сохранения не выбрана")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        FileDialog{
            id:fileDialog
            selectFolder: true
            title: "Выберите директорию сохранения файла"
                folder: shortcuts.home
                onAccepted: {
                    labelDir.text = "Директория сохранения:\r\n "+fileDialog.folder
                    objectPlot.setSaveDir(fileDialog.folder)
                    console.log(fileDialog.folder)

                }
                onRejected: {
                    console.log("Canceled")
                }
        }
    }
}



























/*##^## Designer {
    D{i:13;anchors_height:28;anchors_width:74;anchors_x:179;anchors_y:0}D{i:16;anchors_height:28;anchors_width:163;anchors_x:0;anchors_y:0}
D{i:20;anchors_height:28;anchors_width:74;anchors_x:179;anchors_y:34}D{i:23;anchors_x:0;anchors_y:40}
D{i:11;anchors_height:96;anchors_width:277;anchors_x:22;anchors_y:47}D{i:36;anchors_height:629;anchors_width:1199;anchors_x:361;anchors_y:47}
}
 ##^##*/
