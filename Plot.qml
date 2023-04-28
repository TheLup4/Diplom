import QtQuick 2.0
import CustomPlot 1.0

Item {
    id: plotForm
    property var plot : objectPlot;
    CustomPlotItem {
        id: objectPlot
        anchors.fill: parent

        Component.onCompleted: initCustomPlot()
    }
}
