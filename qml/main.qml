import QtQuick.Window
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
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

    width:Qt.platform.os === "android" ?  Screen.desktopAvailableWidth
                                       : 640
    height: Qt.platform.os === "android" ? Screen.desktopAvailableHeight
                                         : 1280
    visibility: Qt.platform.os === "android" ? Window.FullScreen
                                             : Window.Windowed
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
        root.showFullScreen();
    }

    Connections {
        target: Qt.application
        function onStateChanged() {
            if (Qt.application.state !== Qt.ApplicationActive) {
                Logic.pause();
            }
        }
    }
    Binding {
        target: SoundManager
        property: "pauseMusic"
        value: Logic.sessionPaused
    }
    Loader {
        id: stackViewLoader

        property Item header: root.header

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
    FastBlur {
        anchors.fill: stackViewLoader
        source: stackViewLoader
        radius: 64
        visible: pauseOverlay.visible
    }
    Item {
        id: pauseOverlay

        anchors.fill: parent
        visible: Logic.sessionPaused && stackViewLoader.item.state === "game"

        Column {
            anchors.centerIn: parent
            Controls.Label {
                id: pauseLabel

                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 60
                bold: true
                color: ThemeManager.currentTheme["secondaryTextColor"]
                text: qsTr("PAUSE")
            }
            Controls.PauseToolButton {
                anchors.horizontalCenter: parent.horizontalCenter
                checked: true
                width: 100
                height: 100
                onClicked: Logic.resume()
            }
        }
    }
}
