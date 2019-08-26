import QtQuick 2.0
import QtQuick.Controls 2.12 as QQC2

import Singletons 1.0

QQC2.Button {
    id: root

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

    contentItem: Label {
        anchors.fill: parent
        text:  root.text
        font.pointSize: 24
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
