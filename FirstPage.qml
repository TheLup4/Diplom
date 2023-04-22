import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0


Item {
    id:firstPage
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
    }

    GroupBox {
        id: groupBox2
        x: 22
        y: 47
        width: 277
        height: 96
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


                if(objectPlot.portIsOpen()){
                btnOpenText.text = "Открыть"
                    //добавить ф-ю закрытия
                }
                else{
                    objectPlot.openPort(comboBoxCom.currentText)
                    btnOpenText.text = "Закрыть"}
            }

        }

        ComboBox {
            id: comboBoxCom
            x: 0
            y: 0
            width: 163
            height: 28
            font.pixelSize: 12

            model: ListModel
            {
                id:comElements
            }
            delegate: ItemDelegate {
                id:delegat

                      width: control.width
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
            Text{
                parent: comElements
            font.pixelSize: 8

            }

        }

        RoundButton {
            id: btnUpdatePort
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


            x: 179
            y: 34
            width: 74
            height: 28
            onClicked: {
                comElements.clear()
                var list = objectPlot.updatePortCombobox()
                console.debug(list);
                for (var i =0;i<list.length;i++)
                    comElements.append({"text": list[i]})

            }
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
            x: 186
            y: 18
            width: 46
            height: 33
        }

        CheckBox {
            id: checkBox2
            x: 186
            y: 89
            width: 46
            height: 33
        }

        CheckBox {
            id: checkBox3
            x: 186
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

        CheckBox {
            id: checkBox4
            x: 186
            y: -216
            width: 46
            height: 33
        }

        CheckBox {
            id: checkBox5
            x: 186
            y: -163
            width: 46
            height: 33
        }

        CheckBox {
            id: checkBox6
            x: 186
            y: -113
            width: 46
            height: 33
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
    }

    GroupBox {
        id: groupBox4
        x: 366
        y: 47
        width: 1194
        height: 629
        title: qsTr("")
        Plot {
            id: plot
            width: 54
            height: 35
            anchors.fill: parent
        }
    }
}



/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
