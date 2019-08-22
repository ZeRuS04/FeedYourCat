import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 480
    height: 640
    title: qsTr("Feed your cat")

    PageSelector {
        anchors.fill: parent
    }
}
