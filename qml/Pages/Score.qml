import QtQuick 2.12
import QtQuick.Layouts 1.12

import "../controls" as Controls
import Singletons 1.0

Controls.BasePage {
    id: root

    property int score: !!Logic.session ? Logic.session.score : 0

    signal continueSig()
    signal restart()
    signal settings()

    pageName: "score"

    ColumnLayout {
        anchors.fill: parent

        Item {
            id: scoreItem

            Layout.fillWidth: true
            Layout.fillHeight: true

            Column {
                id: scoreColumn

                anchors.centerIn: parent
                width: parent.width

                spacing: 50

                Controls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 30
                    text: qsTr("YOUR SCORE:")
                }

                Controls.ScorePanel {
                    anchors.horizontalCenter: parent.horizontalCenter
                    score: root.score
                }

                Controls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter

                    font.pointSize: 30
                    text: qsTr("HIGH SCORE: %1").arg(Logic.topScore)
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: buttonsColumn.height

            Column {
                id: buttonsColumn

                anchors.centerIn: parent

                bottomPadding: 50

                spacing: 30

                Controls.MenuButton {
                    width: 280
                    height: 60

                    text: qsTr("FEED MY CATS!")
                    font.bold: true

                    onClicked: root.restart()
                }

                Controls.MenuButton {
                    width: 280
                    height: 60

                    icon.source: "qrc:/resources/icons/%1/settings.svg".arg(ThemeManager.currentTheme.catalogName)
                    text: qsTr("SETTINGS")

                    onClicked: root.settings()
                }
            }
        }
    }
}
