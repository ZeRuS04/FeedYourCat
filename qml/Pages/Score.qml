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
                    color: ThemeManager.currentTheme["secondaryTextColor"]
                }

                Controls.ScorePanel {
                    anchors.horizontalCenter: parent.horizontalCenter
                    score: root.score
                    color: ThemeManager.currentTheme["secondaryTextColor"]
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter

                    Controls.Label {
                        anchors.verticalCenter: parent.verticalCenter

                        font.pointSize: 30
                        text: qsTr("HIGH SCORE: ")
                        color: ThemeManager.currentTheme["secondaryTextColor"]
                    }
                    Controls.Label {
                        anchors.verticalCenter: parent.verticalCenter
                        bold: true
                        font.pointSize: 30
                        text: qsTr("%1").arg(Logic.topScore)
                        color: ThemeManager.currentTheme["secondaryTextColor"]
                    }
                }

            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: buttonsColumn.height

            Column {
                id: buttonsColumn

                anchors.centerIn: parent
                bottomPadding: 60
                spacing: 20

                Controls.MenuButton {
                    width: 280
                    height: 60

                    primaryStyle: true
                    text: qsTr("FEED MY CATS!")
                    font.bold: true
                    onClicked: root.restart()
                }
                Controls.MenuButton {
                    width: 280
                    height: 60
                    icon.source: "qrc:/resources/icons/settings.svg"
                    text: qsTr("SETTINGS")
                    onClicked: root.settings()
                }
            }
        }
    }
}
