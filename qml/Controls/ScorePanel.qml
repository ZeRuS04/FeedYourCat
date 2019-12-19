import QtQuick 2.12

import Singletons 1.0

Row {
    id: root

    property int score: !!Logic.session ? Logic.session.score : 0

    spacing: 5

    Image {
        anchors.verticalCenter: parent.verticalCenter
        sourceSize.width: width
        sourceSize.height: height
        source: ThemeManager.currentTheme["scoreImage"]
    }

    Label {
        anchors.verticalCenter: parent.verticalCenter
        text: root.score
        font.pointSize: 40
        color: ThemeManager.currentTheme["toolbarTextColor"]
    }
}
