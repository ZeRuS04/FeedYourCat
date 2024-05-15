import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import "../controls" as Controls
import Singletons 1.0

Item {
    id: root

    property alias background: background
    property alias iconLoader: iconLoader
    property alias contentLoader: contentLoader
    property var value

    implicitHeight: Math.max(background.implicitHeight, iconLoader.implicitHeight)

    Rectangle {
        id: background

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: iconLoader.width / 2
        }
        implicitHeight: 80
        color: ThemeManager.currentTheme["timeBarBackgroundColor"]
        radius: Number.MAX_VALUE
    }
    Loader {
        id: contentLoader

        anchors.fill: background
    }
    Rectangle {
        id: backgroundBorder

        anchors.fill: background
        border {
            color: ThemeManager.currentTheme["cellBorderColor"]
            width: 3
        }

        color: "transparent"
        radius: background.radius
    }
    Loader {
        id: iconLoader

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
        }
    }
    Component {
        id: barComponent

        Item {
            id: barItem

            property var oldValue: root.value
            property color barColor: {
                if (root.value > 0.8) {
                    return "#ABE388";
                } else if ( root.value > 0.6) {
                    return "#E6E68A";
                } else if (root.value > 0.4) {
                    return "#CC7552";
                } else {
                    return "#C13229";
                }
            }
            Behavior on barColor {
                ColorAnimation {}
            }

            Rectangle {
                id: innerBarRect

                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    margins: backgroundBorder.border.width * 2
                }
                width: Math.min((parent.width - iconLoader.width / 6 * 5 - anchors.margins * 2) * root.value
                                + iconLoader.width / 6 * 5,
                                parent.width)
                radius: background.radius
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.2; color: barItem.barColor }
                    GradientStop { position: 0.5; color: "#FFFFFF" }
                    GradientStop { position: 0.8; color: barItem.barColor }
                }
                border.color: Qt.rgba(0, 0, 0, 0.01)
                border.width: 2
                layer {
                    enabled: true
                    effect: InnerShadow {
                        radius: 20
                        samples: 12
                        spread: 0.6
                        color: "#33000000"
                    }
                }
                Behavior on width {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }
            Connections {
                target: root

                function onValueChanged() {
                    if (oldValue - value < 0) {
                        root.blink("#ABE388");
                    } else if (oldValue - value > 0.1) {
                        root.blink("red");
                    }
                    oldValue = value;
                }
            }
        }
    }
    Component {
        id: clockComponent

        Rectangle {
            id: clockBack

            color: ThemeManager.currentTheme["timeBarBackgroundColor"]
            height: 130
            width: height
            radius: Number.MAX_VALUE
            border {
                color: ThemeManager.currentTheme["cellBorderColor"]
                width: 6
            }

            Rectangle {
                id: mLine

                anchors {
                    bottom: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                height: parent.height / 3 + 10
                width: 2
                antialiasing: true
                radius: Number.MAX_VALUE
                color: ThemeManager.currentTheme["cellBorderColor"]
                transformOrigin: Item.Bottom

                RotationAnimator {
                    target: mLine
                    from: 0
                    to: 360
                    loops: -1
                    duration: emergencyAnimation.running ? 500 : 2000
                    running: !Logic.sessionPaused
                }
            }
            Rectangle {
                id: hLine

                anchors {
                    bottom: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                antialiasing: true
                height: parent.height / 3
                width: 4
                rotation: 120
                radius: Number.MAX_VALUE
                color: ThemeManager.currentTheme["cellBorderColor"]
                transformOrigin: Item.Bottom

                RotationAnimator {
                    target: hLine
                    from: 0
                    to: 360
                    loops: -1
                    duration: emergencyAnimation.running ? 6000 : 24000
                    running: !Logic.sessionPaused
                }
            }
            Rectangle {
                id: redOverlay

                anchors.fill: parent
                radius: Number.MAX_VALUE
                color: "#C13229"
                opacity: 0
            }
            SequentialAnimation {
                id: emergencyAnimation

                running: Logic.sessionStarted && !Logic.sessionPaused
                         && typeof root.value === "number" && root.value < 0.4
                loops: -1
                alwaysRunToEnd: true

                ParallelAnimation {
                    ScaleAnimator {
                        target: clockBack
                        from: 0.95
                        to: 1.05
                        easing.type: Easing.InOutQuad
                        duration: 500
                    }
                    OpacityAnimator {
                        target: redOverlay
                        from: 0
                        to: 0.5
                    }
                }
                ParallelAnimation {
                    ScaleAnimator {
                        target: clockBack
                        from: 1.05
                        to: 0.95
                        easing.type: Easing.InOutQuad
                        duration: 500
                    }
                    OpacityAnimator {
                        target: redOverlay
                        from: 0.5
                        to: 0
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    state: "time_bar"
    states: [
        State {
            name: "time_bar"

            PropertyChanges {
                target: root
                contentLoader.sourceComponent: barComponent
                iconLoader {
                    sourceComponent: clockComponent
                    anchors.leftMargin: (root.width - iconLoader.width) / 2
                }
                background.anchors.leftMargin: 0
            }
        }
    ]
}
