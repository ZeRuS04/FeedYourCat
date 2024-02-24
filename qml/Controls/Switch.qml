import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.15

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
            color: ThemeManager.currentTheme["themeSwitcherCheckedColor"]
            layer {
                enabled: true
                effect: InnerShadow {
                    verticalOffset: 3
                    radius: 3.0
                    samples: 12
                    spread: 0
                    color: "#88000000"
                }
            }
        }
        Rectangle {
            anchors {
                fill: parent
                margins: 3
            }
            color: ThemeManager.currentTheme["themeSwitcherHandleColor"]
            radius: Number.MAX_VALUE
            layer {
                enabled: true
                effect: InnerShadow {
                    verticalOffset: 3
                    radius: 3.0
                    samples: 12
                    spread: 0
                    color: "#66000000"
                }
            }
        }
        Item {
            x: !control.checked ? parent.width - width - 20 : 20
            anchors.verticalCenter: parent.verticalCenter
            width: 48
            height: width

            Image {
                anchors.centerIn: parent
                source: control.checked ? control.checkedIcon : control.uncheckedIcon
                layer {
                    enabled: true
                    effect: ColorOverlay {
                        color: ThemeManager.currentTheme["mainTextColor"]
                    }
                }
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
            color: ThemeManager.currentTheme["themeSwitcherCheckedColor"]
            layer {
                enabled: true
                effect: DropShadow {
                    verticalOffset: 2
                    radius: 5.0
                    samples: 12
                    spread: 0
                }
            }

            Behavior on x {
                NumberAnimation {
                    duration: 150
                }
            }
            Image {
                anchors.centerIn: parent
                source: "qrc:/resources/icons/paw.svg"
                sourceSize.width: 32
                sourceSize.height: 32
                fillMode: Image.PreserveAspectFit
                layer {
                    enabled: true
                    effect: ColorOverlay {
                        color: ThemeManager.currentTheme["mainTextColor"]
                    }
                }
            }
        }
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 88
        color: ThemeManager.currentTheme["themeSwitcherCheckedColor"]
        opacity: ThemeManager.currentTheme["themeSwitcherOpacity"]
    }
}
