import QtQuick
import QtQuick.Layouts
import "../controls" as Controls

import Singletons 1.0

Controls.BasePage {
    id: root

    pageName: "game"
    foodCount: 0

    Component {
        id: plusComponent

        Controls.Label {
            id: plus

            anchors.centerIn: parent
            text: "+" + Logic.rewardForFeedCat * Logic.session.multiplier
            color: "#F600FF"
            visible: !Logic.sessionPaused
            font.pointSize: 28
            bold: true

            Connections {
                target: Logic.session

                function onPause() {
                    if (plusAnimation.running)
                        plusAnimation.pause();
                }
                function onResume() {
                    plusAnimation.resume()
                }
            }
            ParallelAnimation {
                id: plusAnimation

                running: true

                onFinished: {
                    plus.destroy();
                }

                NumberAnimation {
                    target: plus
                    property: "anchors.horizontalCenterOffset"
                    from: 0
                    to: plus.height * 2
                    duration: 1000 / Math.pow(Logic.session.speedIncreaseCof, Logic.session.currentStage - 1)
                }
                PropertyAnimation {
                    target: plus
                    easing.type: Easing.InExpo
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 1000 / Math.pow(Logic.session.speedIncreaseCof, Logic.session.currentStage - 1)
                }
            }
        }
    }
    Component {
        id: minusComponent

        Controls.Label {
            id: minus

            anchors.right: gameTimerLabel.left
            y: parent.height / 3 - height / 2
            text: Logic.rewardForTiger
            color: "#ff0000"
            visible: !Logic.sessionPaused
            font.pointSize: 30
            Component.onCompleted: {
                var nAvailableCount = Math.floor((timerItem.width - gameTimerLabel.width) / 2 / implicitWidth);
                anchors.rightMargin = 5 + implicitWidth * (root.minusObjectsCount % nAvailableCount);
                root.minusObjectsCount++;
            }

            Connections {
                target: Logic.session

                function onPause() {
                    if (minusAnimation.running) {
                        minusAnimation.pause();
                    }
                }
                function onResume() {
                    minusAnimation.resume();
                }
            }

            ParallelAnimation {
                id: minusAnimation

                running: true

                onFinished: {
                    root.minusObjectsCount--;
                    minus.destroy();
                }
                NumberAnimation {
                    target: minus
                    property: "y"
                    from: minus.y
                    to: parent.height - height
                    duration: 1000 / Math.pow(Logic.session.speedIncreaseCof, Logic.session.currentStage - 1)
                }
                PropertyAnimation {
                    target: minus
                    easing.type: Easing.InExpo
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 1000 / Math.pow(Logic.session.speedIncreaseCof, Logic.session.currentStage - 1)
                }
            }
        }
    }
    Item {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: !header.visible ? -header.height : 0
        }
        height: root.height

        Item {
            id: timerItem

            anchors {
                top: parent.top
                bottom: gridItem.top
                horizontalCenter: parent.horizontalCenter
            }
            width: gridItem.width
            implicitHeight: pauseLabel.implicitHeight

            Column {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 40
                }
                width: parent.width
                spacing: 10

                Controls.ScoreParameter {
                    width: parent.width - 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    value: !!Logic.session && (Logic.session.timeLeft / (Logic.time * 1000)) || 0
                    state: "time_bar"
                    enabled: !Logic.sessionPaused
                    opacity: enabled ? 1.0 : 0.5
                }
            }
            Controls.Label {
                id: pauseLabel

                visible: Logic.sessionPaused
                anchors.centerIn: parent
                font.pointSize: 60
                bold: true
                color: ThemeManager.currentTheme["secondaryTextColor"]
                text: qsTr("PAUSE")
            }
        }
        Item {
            id: gridItem

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: root.height / 15
            }

            width: Math.min(parent.width, (parent.height - header.height - timerItem.implicitHeight) / 4 * 3)
            height: grid.height
            enabled: !Logic.sessionPaused
            opacity: enabled ? 1.0 : 0.5

            Grid {
                id: grid

                anchors.centerIn: parent
                columns: Logic.columnCount
                spacing: gridItem.width / 24

                Repeater {
                    model: Logic.columnCount * Logic.rowCount

                    delegate: Controls.GameCell {
                        cellIndex: model.index
                        width: (gridItem.width - (gridItem.width / 6)) / 3
                    }
                }
            }
        }
    }
}


