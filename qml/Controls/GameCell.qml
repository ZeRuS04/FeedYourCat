import QtQuick 2.12

import Singletons 1.0

MouseArea {
    id: root

    property int cellIndex: -1
    property int backgroundIndex: 0
    property string backgroundColor: Common.catBackgrounds[backgroundIndex] || ThemeManager.currentTheme["cellBackgroundColor"]
    property real backgroundOpacity: 1
    property string borderColor: Common.catBorders[backgroundIndex] || ThemeManager.currentTheme["cellBorderColor"]

    height: width

    state: {
        if (cellIndex < 0 || !Logic.sessionStarted || Logic.session === null)
            return "nothing";
        switch (Logic.session.area[cellIndex]) {
        case -1:
            return "tiger"
        case 0:
            return "nothing"
        case 1:
            return "cat1"
        case 2:
            return "cat2"
        case 3:
            return "cat3"
        case 4:
            return "cat4"
        case 5:
            return "cat5"
        case 6:
            return "cat6"
        default:
            return "nothing"
        }
    }

    states: [
        State {
            name: "nothing"
            PropertyChanges {
                target: root
                backgroundColor: ThemeManager.currentTheme["cellBackgroundColor"]
                backgroundOpacity: ThemeManager.currentTheme["cellBackgroundOpacity"]
                borderColor: ThemeManager.currentTheme["cellBorderColor"]
            }
        },
        State {
            name: "cat1"

            PropertyChanges { target: root; backgroundIndex: Math.floor(Math.random() * 7) }
        },
        State {
            name: "cat2"

            PropertyChanges { target: root; backgroundIndex: Math.floor(Math.random() * 7) }
        },
        State {
            name: "cat3"

            PropertyChanges { target: root; backgroundIndex: Math.floor(Math.random() * 7) }
        },
        State {
            name: "cat4"

            PropertyChanges { target: root; backgroundIndex: Math.floor(Math.random() * 7) }
        },
        State {
            name: "cat5"

            PropertyChanges { target: root; backgroundIndex: Math.floor(Math.random() * 7) }
        },
        State {
            name: "cat6"

            PropertyChanges { target: root; backgroundIndex: Math.floor(Math.random() * 7) }
        },
        State {
            name: "tiger"

            PropertyChanges { target: root; backgroundIndex: Math.floor(Math.random() * 7) }
        }
    ]

    onStateChanged: {
        if (state !== "nothing") {
            waitTimer.interval = Math.floor(Math.random() * 1500) + 1000;
            waitTimer.start()
        }
    }

    onClicked: {
        waitTimer.stop();
        Logic.session.hideCat(cellIndex, true);
    }

    AdvancedTimer {
        id: waitTimer

        onTriggered: {
            Logic.session.hideCat(root.cellIndex, false);
        }
    }

    Connections {
        target: Logic.session

        enabled: waitTimer.running

        onPause: waitTimer.pause()
        onResume: waitTimer.resume()
    }

    Rectangle {
        anchors.fill: parent

        radius: height / 10
        color: root.backgroundColor
        opacity: root.backgroundOpacity
    }

    Rectangle {
        anchors.fill: parent

        radius: height / 10
        color: "transparent"
        border.color: root.borderColor
    }
}
