import QtQuick 2.12

import Singletons 1.0

Row {
    id: root

    spacing: 5

    Image {
        anchors.verticalCenter: parent.verticalCenter
        source: ThemeManager.currentTheme["scoreImage"]
    }

    Label {
        anchors.verticalCenter: parent.verticalCenter
        text: !!Logic.session ? Logic.session.score : 0
        font.pointSize: 40
        color: ThemeManager.currentTheme["toolbarTextColor"]
    }
}
