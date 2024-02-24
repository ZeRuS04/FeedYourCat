import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.15

import Singletons 1.0

Slider {
    id: control

    property bool bold: false

    font.family: Common.getDefaultFont(bold)
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
            color: ThemeManager.currentTheme["themeSwitcherCheckedColor"]
            // color: control.checked ? "#17a81a" : "transparent"
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
        Row {
            anchors.centerIn: parent
            spacing: 10

            Item {
                width: 32
                height: width

                Image {
                    anchors.centerIn: parent
                    sourceSize.width: 28
                    sourceSize.height: 21
                    source: "qrc:/resources/icons/volume_min.svg"
                    layer {
                        enabled: true
                        effect: ColorOverlay {
                            color: ThemeManager.currentTheme["mainTextColor"]
                        }
                    }
                }
            }
            Item {
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: 200
                implicitHeight: 2
                width: control.availableWidth - parent.spacing * 2
                height: implicitHeight
                Image {
                    anchors.centerIn: parent
                    sourceSize.width: parent.width
                    sourceSize.height: 10
                    source: "qrc:/resources/icons/line.svg"
                    layer {
                        enabled: true
                        effect: ColorOverlay {
                            color: ThemeManager.currentTheme["mainTextColor"]
                        }
                    }
                }
            }
            Item {
                width: 32
                height: width

                Image {
                    anchors.centerIn: parent
                    sourceSize.width: 30
                    sourceSize.height: 21
                    source: "qrc:/resources/icons/volume_max.svg"
                    layer {
                        enabled: true
                        effect: ColorOverlay {
                            color: ThemeManager.currentTheme["mainTextColor"]
                        }
                    }
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
}
