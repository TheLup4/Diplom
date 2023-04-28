import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0

Item {
    id:termPage
   // visible: false

    property var objectPlot:
    Connections {
        target: objectPlot
        onSignalNewBuffer:
        {
            console.log(buffer)
            textEdit.text = buffer;

        }
    }

    GroupBox {
        id: groupBox5
        x: 33
        y: 40
        width: 293
        height: 221
        title: qsTr("")

        Label {
            id: label11
            x: 0
            y: 164
            width: 134
            height: 19
            color: "#496ec2"
            text: qsTr("Parity")
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: label12
            x: -4
            y: 113
            width: 134
            height: 19
            color: "#496ec2"
            text: qsTr("Stop bits")
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: label13
            x: -4
            y: 61
            width: 134
            height: 19
            color: "#496ec2"
            text: qsTr("Data bits")
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: label14
            x: -4
            y: 5
            width: 134
            height: 19
            color: "#496ec2"
            text: qsTr("BaudRate")
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
        }

        ComboBox {
            id: comboBox1
            x: 149
            y: 2
            width: 120
            height: 26
        }

        ComboBox {
            id: comboBox2
            x: 149
            y: 58
            width: 120
            height: 26
        }

        ComboBox {
            id: comboBox3
            x: 149
            y: 110
            width: 120
            height: 26
        }

        ComboBox {
            id: comboBox4
            x: 149
            y: 161
            width: 120
            height: 26
        }
    }

    Label {
        id: label10
        x: 33
        y: 15
        width: 134
        height: 19
        color: "#496ec2"
        text: qsTr("Настройки Com порта")
        lineHeight: 0.8
        verticalAlignment: Text.AlignVCenter
    }

    GroupBox {
        id: groupBox
        x: 383
        y: 40
        width: 549
        height: 200
        title: qsTr("")

        TextEdit {
            id: textEdit
            width: 537
            height: 176
            readOnly: true
            font.pixelSize: 10



        }
    }

    Label {
        id: label15
        x: 347
        y: 15
        width: 134
        height: 19
        color: "#496ec2"
        text: qsTr("Полученные данные")
        lineHeight: 0.8
        verticalAlignment: Text.AlignVCenter
    }
}





/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
