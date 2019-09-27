import QtQuick 2.12

import "../helpers/Constants.js" as Constants
import Singletons 1.0

MouseArea {
    id: root

    property int cellIndex: -1
    property int backgroundIndex: 0
    property string backgroundColor: Constants.catBackgrounds[backgroundIndex] || ThemeManager.currentTheme["cellBackgroundColor"]
    property real backgroundOpacity: 1
    property string borderColor: Constants.catBorders[backgroundIndex] || ThemeManager.currentTheme["cellBorderColor"]

    height: width

    state: !Logic.session || Logic.session.area[cellIndex] === 0 ? "nothing"
                             : Logic.session.area[cellIndex] > 0 ? "cat"
                                                                 : "tiger"

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
            name: "cat"

            PropertyChanges { target: root; backgroundIndex: Math.floor(Math.random() * 7) }
        },
        State {
            name: "tiger"

            PropertyChanges { target: root; backgroundIndex: Math.floor(Math.random() * 7) }
        }
    ]

    onStateChanged: {
        if (state !== "nothing") {
            waitTimer.interval = Math.floor(Math.random() * (Logic.maximumCatDelay - Logic.minimumCatDelay)) + Logic.minimumCatDelay;
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

        onPause: {
            if (waitTimer.running)
                waitTimer.pause()
        }
        onResume: {
            if (root.state !== "nothing")
                waitTimer.resume()
        }
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
        border.width: 2
    }

    CatImage {
        anchors.fill: parent

        visible: root.state !== "nothing"
        catObject: root.state === "cat" ? Constants.catsCatalog[Logic.session.area[cellIndex] - 1] :
                 root.state === "tiger" ? Constants.tigersCatalog[Math.abs(Logic.session.area[cellIndex]) - 1]
                                        : {}
    }
}
