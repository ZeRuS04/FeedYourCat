import QtQuick.Window 2.2
import QtQuick 2.12
import QtQuick.Controls 2.12

import "controls" as Controls

ApplicationWindow {
    id: root

//    visible: false
    width: 360
    height: 640
    title: qsTr("Feed your cat")
    visibility: Qt.platform.os === "android" ? Window.FullScreen
                                             : Window.Windowed

    header: Controls.Toolbar {
        visible: false
        height: 0 //root.height / 9
        stack: stackViewLoader.item
    }

    Loader {
        id: stackViewLoader
        anchors.fill: parent
        asynchronous: true
        opacity: 0
        focus: true;

        sourceComponent: PageSelector {
            id: stackView

            anchors.fill: parent

            onCurrentItemChanged: {
                if (currentItem) {
                    root.visible = true;
                    stackViewLoader.opacity = 1;
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutQuad;
                onFinished: {
                    root.header.height = Qt.binding(function() { return root.height / 9 })
                    root.header.visible = true
                }
            }
        }
    }
}
