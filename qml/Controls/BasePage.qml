import QtQuick 2.12

import Singletons 1.0

Item {
    id: root

    property string pageName: "unknown"

    property int foodCount: 32
    property int __screenZoneCount: 8

    function intitFoodAnimation () {
        for (var i = 0; i < __screenZoneCount; ++i) {
            for (var j = 0; j < foodCount / __screenZoneCount; ++j) {
                var randY = Math.random() * height - 170,
                    randX = Math.random() * width / __screenZoneCount + width / __screenZoneCount * i;
                sausageComponent.createObject(root, {"x": randX, "y": randY, "screenZone": i})
            }
        }
    }

    function createAnotherOneFood(zone) {
        var randX = Math.random() * width / __screenZoneCount + width / __screenZoneCount * zone;
        sausageComponent.createObject(root, {"x": randX, "y": -170, "screenZone": zone})
    }

    Component.onCompleted: {
        initTimer.restart()
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: -70

        gradient: Gradient {
            GradientStop { position: 0.0; color: ThemeManager.currentTheme["backgroundGradColor1"] }
            GradientStop { position: 1.0; color: ThemeManager.currentTheme["backgroundGradColor2"] }
        }
        z: -100

    }

    Timer {
        id: initTimer

        interval: 100
        onTriggered: intitFoodAnimation();
    }

    Component {
        id: sausageComponent

        Image {
            id: foodImage

            readonly property int type: Math.random() * 6
            property int screenZone: -1

            z: Math.random() * -6 - 1

            source: {
                switch (type) {
                case 0:
                    return "qrc:/resources/images/background/Can.svg";
                case 1:
                    return "qrc:/resources/images/background/Fish.svg";
                case 2:
                    return "qrc:/resources/images/background/Korm1.svg";
                case 3:
                    return "qrc:/resources/images/background/Korm2.svg";
                case 4:
                    return "qrc:/resources/images/background/Korm3.svg";
                case 5:
                    return "qrc:/resources/images/background/Sausage.svg";
                default:
                    return "";
                }
            }
            rotation: Math.random() * 360

            Component.onCompleted: downAnimatiom.start()

            SmoothedAnimation {
                id: downAnimatiom

                target: foodImage
                property: "y"
                velocity: Math.random() * 20 + 30
                to: root.height + height
                reversingMode: SmoothedAnimation.Immediate
                easing.type: Easing.Linear
                onFinished: {
                    root.createAnotherOneFood(screenZone)
                    foodImage.destroy()
                }
            }

//            NumberAnimation {
//                easing.type: Easing.Linear
//                duration: Math.random() * 1000 + 10000

//                onRunningChanged: {
//                    if (!running)
//                        foodImage.destroy()
//                }
//            }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: -70
        opacity: 0.5
        gradient: Gradient {
            GradientStop { position: 0.0; color: ThemeManager.currentTheme["backgroundGradColor1"] }
            GradientStop { position: 1.0; color: ThemeManager.currentTheme["backgroundGradColor2"] }
        }
    }
}

