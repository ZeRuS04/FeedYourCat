import QtQuick 2.0
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.12 as QQC2

import Singletons 1.0

QQC2.Button {
    id: root

    property bool primaryStyle: false

    font.pointSize: 20

    background: Item {
        Rectangle {
            anchors.fill: parent
            color: root.pressed ? ThemeManager.currentTheme["menuButtonPressedBackgroundColor"]
                                : primaryStyle ? ThemeManager.currentTheme["menuButtonBackgroundColor"]
                                               : "transparent"
            border.color: ThemeManager.currentTheme["menuButtonBorderColor"]
            radius: 12
        }
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: ThemeManager.currentTheme["menuButtonBorderColor"]
            radius: 12
        }
    }

    contentItem: Item {
        anchors.fill: parent
        Row {
            anchors.centerIn: parent

            spacing: 10

            Image {
                height: label.height
                anchors.verticalCenter: parent.verticalCenter
                source: root.icon.source
                sourceSize.width: width
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                layer {
                    enabled: true
                    effect: ColorOverlay {
                        color: ThemeManager.currentTheme["secondaryTextColor"]
                    }
                }
            }

            Label {
                id: label

                anchors.verticalCenter: parent.verticalCenter
                bold: root.font.bold
                text:  root.text
                color: ThemeManager.currentTheme["secondaryTextColor"]
                font.pointSize: root.font.pointSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    onClicked: {
        SoundManager.buttonClickPlay();
    }
}
