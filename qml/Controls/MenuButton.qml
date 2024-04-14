import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects

import Singletons 1.0

QQC2.Button {
    id: root

    property bool primaryStyle: false
    property bool isActiveState: false

    font.pointSize: 20
    background: Item {
        Rectangle {
            id: bgRectangle

            anchors.fill: parent
            radius: 12
            color: "lightsteelblue"
            border.color: Qt.rgba(0, 0, 0, 0.01)
            border.width: 1
            layer.enabled: true
            layer.effect: InnerShadow {
                color: ThemeManager.currentTheme["menuButtonActiveShadowColor"]
                samples: 32
                radius: height / 1.2
                spread: 0.0
            }
        }
        Rectangle {
            anchors.fill: bgRectangle
            radius: bgRectangle.radius
            color: "transparent"
            border {
                width: 2
                color: ThemeManager.currentTheme["menuButtonBorderColor"]
            }
        }
        Connections {
            target: root

            function onReleased() {
                isActiveState = true;
                stateTimer.start();
            }
        }
        Timer {
            id: stateTimer
            interval: 100
            onTriggered: root.isActiveState = false
        }

        state: "generic"
        states: [
            State {
                name: "generic"
                when: !root.pressed && !isActiveState

                PropertyChanges {
                    target: bgRectangle
                    layer.enabled: false
                    color: primaryStyle ? ThemeManager.currentTheme["menuButtonBackgroundColor"]
                                        : "transparent"
                }
            },
            State {
                name: "pressed"
                when: root.pressed || !isActiveState

                PropertyChanges {
                    target: bgRectangle
                    layer.enabled: false
                    color: ThemeManager.currentTheme["menuButtonPressedBackgroundColor"]
                }
            },
            State {
                name: "active"
                when: isActiveState

                PropertyChanges {
                    target: bgRectangle
                    layer.enabled: true
                    color: ThemeManager.currentTheme["menuButtonPressedBackgroundColor"]
                }
            }
        ]
    }
    contentItem: Item {
        anchors.fill: parent
        Row {
            anchors.centerIn: parent
            spacing: 3

            QQC2.IconImage {
                height: label.height
                anchors.verticalCenter: parent.verticalCenter
                source: root.icon.source
                sourceSize.width: width
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                color: ThemeManager.currentTheme["secondaryTextColor"]
            }
            Label {
                id: label

                anchors.verticalCenter: parent.verticalCenter
                text:  root.text
                color: ThemeManager.currentTheme["secondaryTextColor"]
                font.pointSize: root.font.pointSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
    onClicked: SoundManager.buttonClickPlay()
}
