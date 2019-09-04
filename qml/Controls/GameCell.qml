import QtQuick 2.0

import Singletons 1.0

Item {
    height: width

    Rectangle {
        anchors.fill: parent

        radius: height / 10
        color: ThemeManager.currentTheme["cellBackgroundColor"]
        opacity: ThemeManager.currentTheme["cellBackgroundOpacity"]
    }
    Rectangle {
        anchors.fill: parent

        radius: height / 10
        color: "transparent"
        border.color: ThemeManager.currentTheme["cellBorderColor"]
    }

}
