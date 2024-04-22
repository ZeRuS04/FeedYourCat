import QtQuick

import Singletons 1.0

Item {
    id: root

    property string pageName: "unknown"

    property int foodCount: 24
    property int __screenZoneCount: 8

    signal destroyFood()

    function intitFoodAnimation () {
        for (var i = 0; i < __screenZoneCount; ++i) {
            for (var j = 0; j < foodCount / __screenZoneCount; ++j) {
                var randYCof = Math.random();
                var randY = randYCof * height,
                    randX = Math.random() * width / __screenZoneCount + width / __screenZoneCount * i;
                sausageComponent.createObject(root, {"x": randX, "y": randY, "screenZone": i, "position": 1 - randYCof })
            }
        }
    }
    function createAnotherOneFood(zone) {
        var randX = Math.random() * width / __screenZoneCount + width / __screenZoneCount * zone;
        sausageComponent.createObject(root, {"x": randX, "y": -170, "screenZone": zone, "position": 1})
    }

    onVisibleChanged: {
        if (visible) {
            intitFoodAnimation();
        } else {
            destroyFood();
        }
    }
    Component.onCompleted: {
        initTimer.restart()
    }

    Rectangle {
        anchors {
            fill: parent
            bottomMargin: -140
        }
        anchors.topMargin: -root.height / 8
        gradient: Gradient {
            GradientStop { position: 0.0; color: ThemeManager.currentTheme["backgroundGradColor1"] }
            GradientStop { position: root.height / height; color: ThemeManager.currentTheme["backgroundGradColor2"] }
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
            property real position: 1

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

            Component.onCompleted:  {
                downAnimatiom.start()
                Logic.foodCount++
            }
            Component.onDestruction: {
                Logic.foodCount--;
            }

            Connections {
                target: root
                function onDestroyFood() { foodImage.destroy(); }
            }
            YAnimator {
                id: downAnimatiom

                target: foodImage
                duration: (Math.random() * 5000 + 8000) * foodImage.position
                to: root.height + height
                easing.type: Easing.Linear
                onFinished: {
                    root.createAnotherOneFood(foodImage.screenZone);
                    foodImage.destroy();
                }
            }
        }
    }
    Rectangle {
        anchors {
            fill: parent
            bottomMargin: -140
        }
        opacity: 0.5
        gradient: Gradient {
            GradientStop { position: 0.0; color: ThemeManager.currentTheme["backgroundGradColor1"] }
            GradientStop { position: root.height / height; color: ThemeManager.currentTheme["backgroundGradColor2"] }
        }
    }
}

