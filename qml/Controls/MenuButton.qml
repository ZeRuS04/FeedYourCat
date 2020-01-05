import QtQuick 2.0
import QtQuick.Controls 2.12 as QQC2

import Singletons 1.0

QQC2.Button {
    id: root

    font.pointSize: 20

    background: Item {
        Rectangle {
            anchors.fill: parent
            color: root.pressed ? ThemeManager.currentTheme["menuButtonPressedBackgroundColor"]
                                : ThemeManager.currentTheme["menuButtonBackgroundColor"]
            border.color: ThemeManager.currentTheme["menuButtonBorderColor"]
            opacity: ThemeManager.currentTheme["menuButtonBackgroundOpacity"]
        }
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: ThemeManager.currentTheme["menuButtonBorderColor"]
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
            }

            Label {
                id: label

                anchors.verticalCenter: parent.verticalCenter

                bold: root.font.bold
                text:  root.text
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
