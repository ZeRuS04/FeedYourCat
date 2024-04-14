import QtQuick.Window
import QtQuick
import QtQuick.Controls
import Singletons 1.0

import "controls" as Controls

ApplicationWindow {
    id: root

    property int dpi: Screen.pixelDensity * 25.4

    function dp(x){
        if(dpi < 120) {
            return x;
        } else {
            return x*(dpi/160);
        }
    }
    width: 360
    height: 640
    title: qsTr("Feed your cat")
    color: "#D3D3EB"
    header: Controls.Toolbar {
        visible: false
        height: 70
        stack: stackViewLoader.item
    }
    Component.onCompleted: {
        console.log(Common.getDefaultFont(),Common.getDefaultFont())
        SoundManager.updateVolume(Logic.soundVolume);
        Vibrator.setEnabled(Logic.vibrationEnabled);
    }

    Binding {
        target: SoundManager
        property: "pauseMusic"
        value: Logic.sessionPaused
    }

    Loader {
        id: stackViewLoader
        anchors.fill: parent
        asynchronous: true
        opacity: 0
        focus: true

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
                    root.header.height = Qt.binding(function() { return 70 })
                    root.header.visible = true
                }
            }
        }
    }
}
