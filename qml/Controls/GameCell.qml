import QtQuick 2.12
import QtGraphicalEffects 1.12

import "../helpers/Constants.js" as Constants
import Singletons 1.0

MouseArea {
    id: root

    property int cellIndex: -1
    property int backgroundIndex: 0
    property string backgroundColor: Constants.catBackgrounds[backgroundIndex] || ThemeManager.currentTheme["cellBackgroundColor"]
    property real backgroundOpacity: 1
    property string borderColor: Constants.catBorders[backgroundIndex] || ThemeManager.currentTheme["cellBorderColor"]

    property bool isFed: false

    signal feed(bool isCat);

    onFeed: {
        if (waitTimer.running) {
            waitTimer.stop();
        }
        if (isCat)
            SoundManager.feedCatPlay();
        else
            SoundManager.feedTigerPlay();
        Vibrator.vibrate(120)
        isFed = true;
        catImage.hide(isFed);
    }

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

            PropertyChanges { target: root; backgroundIndex: Math.floor(Math.random() * 6) }
        },
        State {
            name: "tiger"

            PropertyChanges { target: root; backgroundIndex: Math.floor(Math.random() * 6) }
        }
    ]

    onStateChanged: {
        isFed = false;
        if (state !== "nothing") {
            catImage.timeIsOver = false
            if (!Logic.session.isTestMode) {
                waitTimer.interval = Math.floor(Math.random() * (Logic.session.maximumCatDelay - Logic.session.minimumCatDelay)) + Logic.session.minimumCatDelay;
                waitTimer.start()
            }
        }
    }

    onClicked: {
        if (Logic.sessionPaused)
            return;

        if (!Logic.session.isTestMode) {
            if (state == "nothing" || catImage.timeIsOver)
                return;
            root.feed(state === "cat");
        } else {
            if (state !== "nothing") {
                catImage.hide(isFed);
            } else {
                if (Logic.session.isTestMode) {
                    Logic.session.area[root.cellIndex] = root.cellIndex - 2;
                    Logic.session.areaChanged()
                }
            }
        }
    }

    AdvancedTimer {
        id: waitTimer

        onTriggered: {
            catImage.hide(isFed);
        }
    }

    Connections {
        target: Logic.session

        function onPause() {
            if (waitTimer.running)
                waitTimer.pause()
        }
        function onResume() {
            if (root.state !== "nothing")
                waitTimer.resume()
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: height / 10

        color: root.backgroundColor
        opacity: root.backgroundOpacity

        Behavior on color {
            ColorAnimation {
                duration: 300
            }
        }
    }

    Image {
        id: mask
        anchors.fill: parent
        visible: false

        source: "../../resources/icons/mask.svg"
    }

    Item {
        id: catContainer

        anchors.fill: parent
        visible: false

        CatImage {
            id: catImage

            anchors.fill: parent

            catObject: root.state === "cat" ? Constants.catsCatalog[Logic.session.area[cellIndex] - 1] :
                                              root.state === "tiger" ? Constants.tigersCatalog[Math.abs(Logic.session.area[cellIndex]) - 1]
                                                                     : null
            onHideAnimationFinished: {
                Logic.session.hideCat(root.cellIndex, root.isFed);
            }
            onShowAnimationFinished: {
                if (!Logic.session.isTestMode && root.state !== "nothing") {
                    waitTimer.interval = Math.floor(Math.random() * (Logic.session.maximumCatDelay - Logic.session.minimumCatDelay)) + Logic.session.minimumCatDelay;
                    waitTimer.start()
                }
            }
        }

        Item {
            id: clickReactionImage

            property bool needShow: root.pressed
            property string state: "nothing"

            function reset() {
                resetOpacityAnimation.start();
            }

            anchors.fill: parent
            opacity: 0

            onNeedShowChanged: if (needShow && opacity === 0 && !catImage.timeIsOver) opacityAnimation.start()

            Connections {
                target: root

                function onStateChanged() {
                    if (clickReactionImage.opacity > 0)
                        clickReactionImage.reset()
                }
            }

            SequentialAnimation {
                id: opacityAnimation

                ScriptAction {
                    script: clickReactionImage.state = root.state;
                }

                PropertyAnimation {
                    target: clickReactionImage
                    property: "opacity"
                    from: 0
                    to: 1
                    alwaysRunToEnd: true
                    duration: 100
                }
            }

            SequentialAnimation {
                id: resetOpacityAnimation

                PropertyAnimation {
                    target: clickReactionImage
                    property: "opacity"
                    from:1
                    to: 0
                    alwaysRunToEnd: true
                    duration: 100
                }

                ScriptAction {
                    script: clickReactionImage.state = "nothing";
                }
            }

            RadialGradient {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: clickReactionImage.state === "tiger" ? "#dd000000"
                                                                                              : "#ccffffff" }
                    GradientStop { position: 0.5; color: "#dd000000" }
                }
            }

            Image {
                anchors.fill: parent
                anchors.margins: 10
                sourceSize.width: width
                sourceSize.height: height

                source: "../../resources/icons/%1.svg".arg(clickReactionImage.state === "cat" ? "paw"
                                                                                              : "jaws")
            }
        }
    }

    OpacityMask {
        anchors.fill: parent
        source: catContainer
        maskSource: mask

        opacity:  root.state !== "nothing" ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }
    }

    Rectangle {
        anchors.fill: parent

        radius: height / 10
        color: "transparent"
        border.color: root.state !== "nothing" &&
                      clickReactionImage.opacity > 0 &&
                      !resetOpacityAnimation.running ? (root.state == "tiger" ? "#ff0000"
                                                                              : root.backgroundColor)
                                                     : root.borderColor
        border.width: root.state !== "nothing" &&
                      clickReactionImage.opacity > 0 &&
                      !resetOpacityAnimation.running  ? 5 : 2
    }

}
