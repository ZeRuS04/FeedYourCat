import QtQuick
import "../controls" as Controls

import Singletons 1.0

Controls.BasePage {
    id: root

    pageName: "game"
    foodCount: 0

    property int plusObjectsCount: 0
    property int minusObjectsCount: 0

    function addPlus() {
        var plusObj = plusComponent.createObject(timerItem);
    }

    function addMinus() {
        var minusObj = minusComponent.createObject(timerItem);
    }

    Component {
        id: plusComponent

        Controls.Label {
            id: plus

            anchors.left: gameTimerLabel.right
            y: parent.height / 3 * 2 - height / 2
            text: "+" + Logic.rewardForFeedCat
            color: "#F600FF"
            visible: !Logic.sessionPaused
            font.pointSize: 30
            Component.onCompleted: {
                var nAvailableCount = Math.floor((timerItem.width - gameTimerLabel.width) / 2 / implicitWidth);
                anchors.leftMargin = 5 + implicitWidth * (root.plusObjectsCount % nAvailableCount);
                root.plusObjectsCount++;
            }

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
                    root.plusObjectsCount--;
                    plus.destroy();
                }

                NumberAnimation {
                    target: plus
                    property: "y"
                    from: plus.y
                    to: 0
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

        Controls.Label {
            anchors {
                top: parent.top
                bottom: gridItem.top
                horizontalCenter: parent.horizontalCenter
            }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: height
            bold: true
            color: ThemeManager.currentTheme["toolbarBackgroundColor"]
            opacity: ThemeManager.currentTheme["toolbarBackgroundOpacity"]
            text: "x%1".arg(Math.min(Logic.series, 7) + 1)
        }
        Item {
            id: timerItem

            anchors.top: parent.top
            anchors.bottom: gridItem.top
            width: parent.width

            Controls.Label {
                id: gameTimerLabel

                function switchColor() {
                    if (gameTimerLabel.color === ThemeManager.currentTheme["mainTextColor"])
                        gameTimerLabel.color = ThemeManager.currentTheme["alertColor"];
                    else
                        gameTimerLabel.color = ThemeManager.currentTheme["mainTextColor"];
                }

                anchors.centerIn: parent

                visible: !Logic.sessionPaused
                text: !!Logic.session ? Qt.formatTime(new Date(Logic.session.timeLeft), "mm:ss")
                                      : "00:00"
                bold: true
                font.pointSize: 40
                color: ThemeManager.currentTheme["secondaryTextColor"]

                Behavior on color {
                    ColorAnimation {
                        duration: 500
                    }
                }

                Controls.AdvancedTimer {
                    property bool running: !!Logic.session && Logic.session.timeLeft < 6000

                    interval: 500
                    repeat: true

                    onRunningChanged: {
                        if (running)
                            restart()
                        else {
                            stop();
                            gameTimerLabel.color = ThemeManager.currentTheme["mainTextColor"]
                        }
                    }

                    onTriggered: {
                        gameTimerLabel.switchColor()
                    }
                }
            }

            Controls.Label {
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
                bottom: parent.bottom
                bottomMargin: root.height / 15
            }

            width: parent.width
            height: grid.height

            enabled: !Logic.sessionPaused
            opacity: enabled ? 1.0 : 0.5

            Grid {
                id: grid

                anchors.centerIn: parent
                columns: Logic.columnCount
                spacing: root.width / 24

                Repeater {
                    model: Logic.columnCount * Logic.rowCount

                    delegate: Controls.GameCell {
                        cellIndex: model.index
                        width: (root.width - (root.width / 6)) / 3

                        onFeed: function (type) { return type === "cat" ? root.addPlus() : root.addMinus(); }
                    }
                }
            }
        }
    }
}


