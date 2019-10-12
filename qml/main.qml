import QtQuick.Window 2.2
import QtQuick 2.12
import QtQuick.Controls 2.12

import "controls" as Controls

ApplicationWindow {
    id: root

    visible: true
    width: 360
    height: 640
    title: qsTr("Feed your cat")
    visibility: Qt.platform.os === "android" ? Window.FullScreen
                                             : Window.Windowed

    header: Controls.Toolbar {
        height: root.height / 9
        stack: stackView
    }

    PageSelector {
        id: stackView

        anchors.fill: parent
    }
}
