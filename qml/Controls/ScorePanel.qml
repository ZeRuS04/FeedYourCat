import QtQuick
import Singletons 1.0

Row {
    id: root

    property int score: !!Logic.session ? Logic.session.fedCat : 0
    property alias color: scoreLabel.color

    spacing: 5

    Image {
        anchors.verticalCenter: parent.verticalCenter
        sourceSize.width: 60
        sourceSize.height: 48
        source: ThemeManager.currentTheme["scoreImage"]
    }
    Label {
        id: scoreLabel

        anchors.verticalCenter: parent.verticalCenter
        text: root.score
        font.pointSize: 34
        bold: true
        color: ThemeManager.currentTheme["mainTextColor"]
    }
}
