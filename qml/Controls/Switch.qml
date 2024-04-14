import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

import Singletons 1.0
import "." as Controls

SwitchDelegate {
    id: control

    property string checkedIcon: ""
    property string uncheckedIcon: ""

    leftPadding: 40
    rightPadding: 40
    contentItem: Controls.Label {
        text: control.text
        opacity: enabled ? 1.0 : 0.3
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
    indicator: Item {
        implicitWidth: 128
        implicitHeight: 64
        x: control.width - width - control.rightPadding
        y: parent.height / 2 - height / 2

        Rectangle {
            anchors.fill: parent
            radius: Number.MAX_VALUE
            color: ThemeManager.currentTheme["themeSwitcherHandleColor"]
            layer {
                enabled: true
                effect: InnerShadow {
                    verticalOffset: 3
                    radius: 3.0
                    samples: 12
                    spread: 0
                    color: "#44000000"
                }
            }
        }
        Rectangle {
            anchors {
                fill: parent
                margins: 3
            }
            color: ThemeManager.currentTheme["themeSwitcherCheckedColor"]
            radius: Number.MAX_VALUE
            layer {
                enabled: true
                effect: InnerShadow {
                    verticalOffset: 3
                    radius: 3.0
                    samples: 12
                    spread: 0
                    color: "#33000000"
                }
            }
        }
        Item {
            x: !control.checked ? parent.width - width - 20 : 20
            anchors.verticalCenter: parent.verticalCenter
            width: 48
            height: width

            IconImage {
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: control.checked ? control.checkedIcon : control.uncheckedIcon
                color: ThemeManager.currentTheme["mainTextColor"]
            }
            Behavior on x {
                NumberAnimation {
                    duration: 150
                }
            }
        }
        Rectangle {
            x: control.checked ? parent.width - width - 5 : 5
            anchors.verticalCenter: parent.verticalCenter
            width: 48
            height: width
            radius: Number.MAX_VALUE
            color: ThemeManager.currentTheme["themeSwitcherHandleColor"]
            layer {
                enabled: true
                effect: MultiEffect {
                    shadowEnabled: true
                    shadowScale: 1
                    shadowColor: "#88000000"
                }
            }

            Behavior on x {
                NumberAnimation {
                    duration: 150
                }
            }
            IconImage {
                anchors.centerIn: parent
                source: "qrc:/resources/icons/paw.svg"
                sourceSize.width: 32
                sourceSize.height: 32
                fillMode: Image.PreserveAspectFit
                color: ThemeManager.currentTheme["mainTextColor"]
            }
        }
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 88
        color: ThemeManager.currentTheme["themeSwitcherHandleColor"]
        opacity: ThemeManager.currentTheme["themeSwitcherOpacity"]
    }
}
