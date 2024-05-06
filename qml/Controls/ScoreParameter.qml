import QtQuick
import QtQuick.Effects
import "../controls" as Controls
import Singletons 1.0

Item {
    id: root

    property alias background: background
    property alias iconLoader: iconLoader
    property alias contentLoader: contentLoader
    property var value
    property real __blinkCoef: 0
    property color __blinkColor: "green"

    function blink(color) {
        __blinkColor = color;
        blinkAnimation.restart();
    }

    implicitHeight: Math.max(background.implicitHeight, iconLoader.implicitHeight)
    layer {
        enabled: true
        effect: MultiEffect {
            autoPaddingEnabled: true
            colorization: 0.5 * __blinkCoef
            colorizationColor: __blinkColor
            brightness: 0.4 * __blinkCoef
            saturation: 0.2 * __blinkCoef
            blurEnabled: __blinkCoef > 0
            blurMax: 16
            blur: __blinkCoef
            shadowEnabled: __blinkCoef > 0
            shadowScale: 1.1 * __blinkCoef
            shadowColor: __blinkColor
        }
    }
    Rectangle {
        id: background

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: iconLoader.width / 2
        }
        implicitHeight: 40
        color: ThemeManager.currentTheme["cellBackgroundColor"]
        radius: height / 4

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
            width: 2
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
    SequentialAnimation {
        id: blinkAnimation

        loops: 1

        PropertyAnimation {
            target: root
            property: "__blinkCoef"
            from: 0
            to: 1.0
            easing.type: Easing.OutInQuad
            duration: 150
        }
        PropertyAnimation {
            target: root
            property: "__blinkCoef"
            from: 1.0
            to: 0
            easing.type: Easing.InOutQuad
            duration: 400
        }
    }
    Component {
        id: textComponent

        Controls.Label {
            text: !!root.value && root.value.text || ""
            font.pointSize: 28
            bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
    Component {
        id: barComponent

        Item {
            id: barItem

            property var oldValue: root.value
            Rectangle {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    top: parent.top
                }
                width: Math.min(parent.width * root.value, parent.width)
                radius: background.radius
                color: root.value > 0.6 ? "green"
                                        : root.value <= 0.3 ? "red"
                                                            : "orange"
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
        id: hourglassComponent

        Image {
            id: hourglassImage

            source: "qrc:/resources/icons/hourglass.svg"

            // sourceSize.width: 22
            // sourceSize.height: 29

            SequentialAnimation {
                running: !Logic.sessionPaused
                loops: -1

                ScaleAnimator {
                    target: hourglassImage
                    from: 0.95
                    to: 1.05
                    easing.type: Easing.InOutQuad
                    duration: 800
                }
                // RotationAnimator {
                //     target: hourglassImage
                //     from: 0
                //     to: 360
                //     duration: 800
                // }
                ScaleAnimator {
                    target: hourglassImage
                    from: 1.05
                    to: 0.95
                    easing.type: Easing.InOutQuad
                    duration: 800
                }
            }
        }
    }
    Component {
        id: catComponent

        Image {
            id: catImage

            source: ThemeManager.currentTheme["scoreImage"]
            sourceSize.width: 60
            sourceSize.height: 48
        }
    }
    Component {
        id: multiplierComponent

        Rectangle {
            color: "white"
            height: 60
            width: 60
            // implicitWidth: implicitHeight
            radius: Number.MAX_VALUE
            border {
                color: ThemeManager.currentTheme["cellBorderColor"]
                width: 3
            }

            Controls.Label {
                anchors.centerIn: parent
                font.pointSize: 22
                bold: true
                text: !!root.value && root.value.multiplier || ""
            }
        }
    }
    Component {
        id: clockComponent

        Rectangle {
            id: clockBack

            color: "white"
            height: 60
            width: 60
            radius: Number.MAX_VALUE
            border {
                color: ThemeManager.currentTheme["cellBorderColor"]
                width: 3
            }

            Rectangle {
                id: mLine

                anchors {
                    bottom: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                height: parent.height / 3
                width: 2
                antialiasing: true
                color: ThemeManager.currentTheme["cellBorderColor"]
                transformOrigin: Item.Bottom

                RotationAnimator {
                    target: mLine
                    from: 0
                    to: 360
                    loops: -1
                    duration: 3000
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
                height: parent.height / 4
                width: 3
                rotation: 120
                color: ThemeManager.currentTheme["cellBorderColor"]
                transformOrigin: Item.Bottom

                RotationAnimator {
                    target: hLine
                    from: 0
                    to: 360
                    loops: -1
                    duration: 36000
                    running: !Logic.sessionPaused
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
                iconLoader.sourceComponent: hourglassComponent
            }
        },
        State {
            name: "score"

            PropertyChanges {
                target: root
                contentLoader {
                    anchors.leftMargin: iconLoader.width / 3
                    sourceComponent: textComponent
                }
                iconLoader.sourceComponent: multiplierComponent
            }
        },
        State {
            name: "time"

            PropertyChanges {
                target: root
                contentLoader {
                    anchors.leftMargin: iconLoader.width / 3
                    sourceComponent: textComponent
                }
                iconLoader.sourceComponent: clockComponent
            }
        },
        State {
            name: "cats"

            PropertyChanges {
                target: root
                contentLoader {
                    anchors.leftMargin: iconLoader.width / 3
                    sourceComponent: textComponent
                }
                iconLoader.sourceComponent: catComponent
            }
        }
    ]
}
