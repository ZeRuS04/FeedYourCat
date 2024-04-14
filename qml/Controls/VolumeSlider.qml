import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

import Singletons 1.0

Slider {
    id: control

    font.family: Common.getDefaultFont()
    font.pointSize: 20
    leftPadding: 48
    rightPadding: 48

    background: Item {
        id: bgItem

        anchors.fill: parent
        implicitWidth: 200
        implicitHeight: 64

        Rectangle {
            anchors.fill: parent
            radius: Number.MAX_VALUE
            color: ThemeManager.currentTheme["themeSwitcherHandleColor"]
            // color: control.checked ? "#17a81a" : "transparent"
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
        Row {
            anchors.centerIn: parent
            spacing: 10

            Item {
                width: 32
                height: width

                IconImage {
                    anchors.centerIn: parent
                    sourceSize.width: 28
                    sourceSize.height: 21
                    source: control.value === control.from ? "qrc:/resources/icons/volume_min_fill.svg"
                                                           : "qrc:/resources/icons/volume_min.svg"
                    color: ThemeManager.currentTheme["mainTextColor"]
                }
            }
            Item {
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: 200
                implicitHeight: 2
                width: control.availableWidth - parent.spacing * 2
                height: implicitHeight
                IconImage {
                    anchors.centerIn: parent
                    sourceSize.width: parent.width
                    sourceSize.height: 10
                    source: "qrc:/resources/icons/line.svg"
                    color: ThemeManager.currentTheme["mainTextColor"]
                }
            }
            Item {
                width: 32
                height: width

                IconImage {
                    anchors.centerIn: parent
                    sourceSize.width: 30
                    sourceSize.height: 21
                    source: control.value === control.to ? "qrc:/resources/icons/volume_max_fill.svg"
                                                         : "qrc:/resources/icons/volume_max.svg"
                    color: ThemeManager.currentTheme["mainTextColor"]
                }
            }
        }
    }

    handle: Item {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width )  //+ width / 2
        y: control.topPadding + control.availableHeight / 2 - height / 2
        width: 64
        height: 64

        Rectangle {
            anchors.centerIn: parent
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
}
