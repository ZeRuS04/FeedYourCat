import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import "../controls" as Controls
import Singletons 1.0

Item {
    id: root

    property real centerOffset: 0
    property bool __finished: false

    signal explode()
    signal finished()

    on__FinishedChanged: if (__finished) finished()

    MouseArea {
        anchors.fill: parent
        onClicked: {
            rotationAnimation.complete();
            rotation.angle = rotationAnimation.to;
        }
    }
    Repeater {
        model: 18
        delegate: Item {
            id: foodItem

            function getImageSource(type) {
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

            anchors.centerIn: parent
            width: 1
            height: (parent.height * parent.width) / Math.sqrt(Math.pow(parent.height, 2) * Math.pow(Math.sin(rotation * Math.PI / 180), 2) + Math.pow(parent.width, 2) * Math.pow(Math.cos(rotation * Math.PI / 180), 2))
            rotation: index * 10
            visible: (rotationAnimation.to - rotation.angle) < 100

            Connections {
                target: root
                function onExplode() {
                    foodItem.visible = true;
                    downAnimatiom1.restart();
                    downAnimatiom2.restart();
                }
            }
            Image {
                id: foodImage1

                readonly property int type: Math.random() * 6
                property real position:  Math.random() * 0.6

                y: (parent.height - height) / 2
                anchors.horizontalCenter: parent.horizontalCenter
                source: foodItem.getImageSource(type)
                rotation: Math.random() * 360

                Behavior on rotation {
                    RotationAnimator {
                        duration: 2500
                        easing.type: Easing.OutExpo
                    }
                }
                YAnimator {
                    id: downAnimatiom1

                    target: foodImage1
                    duration: 1000
                    from: foodImage1.parent.height / 2
                    to: (foodImage1.parent.height / 2 - root.centerOffset) * foodImage1.position
                    easing {
                        type: Easing.OutExpo
                        overshoot: 0
                    }
                    onStarted: foodImage1.rotation += 360
                    onFinished: root.__finished = true
                }
            }
            Image {
                id: foodImage2

                readonly property int type: Math.random() * 6
                property real position: 0.4 + Math.random() * 0.6

                y: parent.height / 2
                source: foodItem.getImageSource(type)
                rotation: Math.random() * 360

                Behavior on rotation {
                    RotationAnimator {
                        duration: 2500
                        easing.type: Easing.OutExpo
                    }
                }
                YAnimator {
                    id: downAnimatiom2

                    target: foodImage2
                    duration: 1000
                    from: foodImage2.parent.height / 2
                    to: (foodImage2.parent.height / 2 + root.centerOffset)
                        + (foodImage2.parent.height / 2 - root.centerOffset) * foodImage2.position
                    easing {
                        type: Easing.OutExpo
                        overshoot: 0
                        amplitude: 0
                    }
                    onStarted: foodImage2.rotation += 360
                }
            }
        }
    }
    Flipable {
        id: flipable

        anchors.centerIn: parent
        implicitWidth: front.implicitWidth
        implicitHeight: front.implicitHeight

        visible: true
        property bool flipped: false

        front: Image {
            source: "qrc:/resources/icons/record_paw.png";
            anchors.centerIn: parent

            Controls.Label {
                anchors {
                    centerIn: parent
                    verticalCenterOffset: 20
                }
                font.pointSize: 42
                text: qsTr("NEW\nRECORD")
                color: "#1B124C"
                rotation: -13
                bold: true
                lineHeight: 0.8
                horizontalAlignment: Text.AlignHCenter
                visible: (rotationAnimation.to - rotation.angle) < 180
            }
        }
        back: Image {
            source: "qrc:/resources/icons/record_paw_revers.png"
            anchors.centerIn: parent
            mirror: true
        }
        transform: Rotation {
            id: rotation
            property real lastValue: 360
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis.x: 0; axis.y: 1; axis.z: 0
            angle: 180
            onAngleChanged: {
                if (Math.abs(rotationAnimation.to - rotation.angle) < 5){
                    rotationAnimation.stop();
                    SoundManager.drumhitPlay()
                    Qt.callLater(root.explode);
                }
            }
        }
        SpringAnimation {
            id: rotationAnimation

            target: rotation
            property: "angle"
            // running: true
            from: 180
            to: 360 * 5
            spring: 0.5
            damping: 0.2
            velocity: 1000
            Component.onCompleted: {
                SoundManager.whooshPlay();
                start()
            }
        }
    }
}
