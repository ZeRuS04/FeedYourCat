import QtQuick 2.12

import Singletons 1.0

Item {
    id: root

    property real __cof: width / 100
    property var catObject
    property alias longestFinishDuration: finishDelayTimer.interval
    property alias longestStartDuration: startDelayTimer.interval
    property string catColor: {
        if (Math.random() > 0.5)
            return "Dark_Theme";
        else
            return "Light_Theme"
    }

    signal hideAnimationFinished()
    signal showAnimationFinished()
    signal reverseAnimation()

    function hide() {
        root.reverseAnimation();
        finishDelayTimer.restart();
    }

    clip: true

    Component.onCompleted: startDelayTimer.start();

    AdvancedTimer {
        id: finishDelayTimer
        interval: 0

        onTriggered: root.hideAnimationFinished()
    }

    AdvancedTimer {
        id: startDelayTimer
        interval: 0

        onIntervalChanged: {
            startDelayTimer.restart();
        }
        onTriggered: {
            root.showAnimationFinished()
        }
    }

    Connections {
        target: Logic.session

        onPause: {
            if (startDelayTimer.running)
                startDelayTimer.pause();
            if (finishDelayTimer.running)
                finishDelayTimer.pause();
        }
        onResume: {
            startDelayTimer.resume()
            finishDelayTimer.resume()
        }
    }

    Repeater {
        model: !!root.catObject ? Object.keys(root.catObject.parts || {}) : 0

        delegate: Image {
            id: delegateImage

            property int rotation: catObject.parts[modelData].split(";")[2].split(",")[0]

            x: catObject.parts[modelData].split(";")[0].split(",")[0] * root.__cof
            y: catObject.parts[modelData].split(";")[0].split(",")[1] * root.__cof
            width: catObject.parts[modelData].split(";")[1].split(",")[0] * root.__cof
            height: catObject.parts[modelData].split(";")[1].split(",")[1] * root.__cof
            sourceSize.width: width
            sourceSize.height: height
            source: catObject["catImagePrefix"].replace("%THEME%", root.catColor/*ThemeManager.currentTheme.catalogName*/) + modelData + ".svg"

            Component.onCompleted: {
                if (catObject.parts[modelData].split(";").length > 3) {
                    var animArray = catObject.parts[modelData].split(";")[3].split("|");
                    for (var i = 0; i < animArray.length; ++i) {
                        var animObj;
                        try {
                            animObj = JSON.parse(animArray[i]);
                            animationComponent.createObject(delegateImage, animObj);
                        } catch (err) {
                            console.warn(err.name + ":", err.message, "\n", animArray[i])
                        }
                    }
                }
            }

            transform: Rotation {
                property var rotationPoint: {
                    if (catObject.parts[modelData].split(";")[2].split(",").length < 3)
                        return undefined;
                    var map = delegateImage.mapFromItem(root, parseInt(catObject.parts[modelData].split(";")[2].split(",")[1]),
                                              parseInt(catObject.parts[modelData].split(";")[2].split(",")[2]))
                    return Qt.point(map.x, map.y)
                }

                angle: delegateImage.rotation
                origin.x: !!rotationPoint ? rotationPoint.x : delegateImage.width / 2
                origin.y: !!rotationPoint ? rotationPoint.y : delegateImage.height / 2

            }

            Component {
                id: animationComponent

                PropertyAnimation {
                    id: propAnimation

                    property AdvancedTimer delayTimer: AdvancedTimer {
                        interval: propAnimation.delay

                        onTriggered: {
                            propAnimation.start()
                        }
                    }

                    property Connections connection: Connections {
                        target: root

                        onReverseAnimation: {
                            var from = propAnimation.from;
                            propAnimation.from = propAnimation.to;
                            propAnimation.to = from;
                            propAnimation.start();
                        }
                    }

                    property Connections connection2: Connections {
                        target: Logic.session

                        onPause: {
                            if (delayTimer.running)
                                delayTimer.pause();
                            if (propAnimation.running)
                                propAnimation.pause();
                        }
                        onResume: {
                            delayTimer.resume();
                            propAnimation.resume();
                        }
                    }

                    property int delay: 0

                    target: delegateImage
                    duration: 300

                    Component.onCompleted: {
                        if (Logic.session.currentStage > 0) {
                            propAnimation.duration /= Math.pow(Logic.session.speedIncreaseCof, Logic.session.currentStage - 1)
                            propAnimation.delay /= Math.pow(Logic.session.speedIncreaseCof, Logic.session.currentStage - 1)
                        }
                        if (root.longestFinishDuration < propAnimation.duration)
                            root.longestFinishDuration = propAnimation.duration;

                        if (root.longestStartDuration < propAnimation.duration + propAnimation.delay)
                            root.longestStartDuration = propAnimation.duration + propAnimation.delay;
                        delegateImage[propAnimation.property] = from;
                        delay > 0 ? delayTimer.start() : start()
                    }
                }
            }
        }
    }

    Repeater {
        model: !!root.catObject ? Object.keys(root.catObject.clouds || {}) : 0

        delegate: Image {
            id: cloudDelegateImage

            property int rotation: catObject.clouds[modelData].split(";") >= 3 ? catObject.clouds[modelData].split(";")[2].split(",")[0]
                                                                               : 0

            x: catObject.clouds[modelData].split(";")[0].split(",")[0] * root.__cof
            y: catObject.clouds[modelData].split(";")[0].split(",")[1] * root.__cof
            width: catObject.clouds[modelData].split(";")[1].split(",")[0] * root.__cof
            height: catObject.clouds[modelData].split(";")[1].split(",")[1] * root.__cof
            sourceSize.width: width
            sourceSize.height: height
            source: catObject["cloudImagePrefix"].replace("%THEME%", ThemeManager.currentTheme.catalogName) + modelData + ".svg"

            Component.onCompleted: {
                if (catObject.clouds[modelData].split(";").length > 3) {
                    var animArray = catObject.clouds[modelData].split(";")[3].split("|");
                    var animObj;
                    for (var i = 0; i < animArray.length; ++i) {
                        try {
                            animObj = JSON.parse(animArray[i]);
                            animationComponent.createObject(cloudDelegateImage, animObj);
                        } catch (err) {
                            console.warn(err.name + ":", err.message, "\n", animArray[i])
                        }
                    }
                }
            }
            transform: Rotation {
                property var rotationPoint: {
                    if (!catObject.clouds[modelData]
                            || catObject.clouds[modelData].split(";").length < 3
                            || catObject.clouds[modelData].split(";")[2].split(",").length < 3)
                        return undefined;
                    var map = cloudDelegateImage.mapFromItem(root, parseInt(catObject.clouds[modelData].split(";")[2].split(",")[1]),
                                              parseInt(catObject.clouds[modelData].split(";")[2].split(",")[2]))
                    return Qt.point(map.x, map.y)
                }

                angle: cloudDelegateImage.rotation
                origin.x: !!rotationPoint ? rotationPoint.x : cloudDelegateImage.width / 2
                origin.y: !!rotationPoint ? rotationPoint.y : cloudDelegateImage.height / 2
            }

            Component {
                id: animationComponent

                PropertyAnimation {
                    id: propAnimation

                    property AdvancedTimer delayTimer: AdvancedTimer {
                        interval: propAnimation.delay

                        onTriggered: {
                            propAnimation.start()
                        }
                    }
                    property Connections connection: Connections {
                        target: root

                        onReverseAnimation: {
                            var from = propAnimation.from;
                            propAnimation.from = propAnimation.to;
                            propAnimation.to = from;
                            propAnimation.start();
                        }
                    }

                    property Connections connection2: Connections {
                        target: Logic.session

                        onPause: {
                            if (delayTimer.running)
                                delayTimer.pause();
                            if (propAnimation.running)
                                propAnimation.pause();
                        }
                        onResume: {
                            delayTimer.resume();
                            propAnimation.resume()
                        }
                    }

                    property int delay: 0

                    target: cloudDelegateImage
                    duration: 300

                    Component.onCompleted: {
                        if (Logic.session.currentStage > 0) {
                            propAnimation.duration /= Math.pow(Logic.session.speedIncreaseCof, Logic.session.currentStage - 1)
                            propAnimation.delay /= Math.pow(Logic.session.speedIncreaseCof, Logic.session.currentStage - 1)
                        }
                        if (root.longestStartDuration < propAnimation.duration + propAnimation.delay)
                            root.longestStartDuration = propAnimation.duration + propAnimation.delay;
                        cloudDelegateImage[propAnimation.property] = from;
                        delay > 0 ? delayTimer.start() : start()
                    }
                }
            }
        }
    }
}
