import QtQuick 2.0

import Singletons 1.0

Row {
    id: root

    property int score: 0

    spacing: 5

    Image {
        anchors.verticalCenter: parent.verticalCenter
        source: ThemeManager.currentTheme["scoreImage"]
    }

    Label {
        anchors.verticalCenter: parent.verticalCenter
        text: root.score
        font.pointSize: 40
        color: ThemeManager.currentTheme["toolbarTextColor"]
    }
}
