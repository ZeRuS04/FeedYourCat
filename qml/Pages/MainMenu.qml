import QtQuick 2.12
import QtQuick.Layouts 1.12

import "../controls" as Controls
import Singletons 1.0


Controls.BasePage {
    id: root

    signal start()
    signal startTestMode()
    signal settings()

    pageName: "mainMenu"

    ColumnLayout {
        anchors.fill: parent

        Item {
            id: titleItem

            Layout.fillWidth: true
            Layout.preferredHeight: root.height / 5

            Controls.TitleLabel {
                anchors.centerIn: parent

                text: qsTr("FEED\nYOUR CAT")
            }
        }

        Item {
            id: logoItem

            Layout.fillWidth: true
            Layout.fillHeight: true

            Image {
                anchors.centerIn: parent

                width: 280
                height: 280

                sourceSize.width: width
                sourceSize.height: height
                source: ThemeManager.currentTheme["mainMenuImage"]
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: buttonsColumn.height

            Column {
                id: buttonsColumn

                anchors.centerIn: parent

                bottomPadding: 50

                spacing: 23

                Controls.MenuButton {
                    width: 280
                    height: 60

                    text: qsTr("START!")

                    font.bold: true

                    onClicked: root.start()
                }

                Controls.MenuButton {
                    width: 280
                    height: 60

                    text: qsTr("TEST MODE!")

                    font.bold: true

                    onClicked: root.startTestMode()
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
