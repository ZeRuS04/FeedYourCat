import QtQuick 2.12
import QtQuick.Layouts 1.12

import "../controls" as Controls
import Singletons 1.0

Controls.BasePage {
    id: root

    signal continueSig()
    signal restart()
    signal settings()

    pageName: "pause"

    ColumnLayout {
        anchors.fill: parent

        Item {
            id: titleItem

            Layout.fillWidth: true
            Layout.preferredHeight: root.height / 6

            Controls.Label {
                anchors.centerIn: parent

                font.pointSize: 30
                text: qsTr("PAUSE")
            }
        }

        Item {
            id: logoItem

            Layout.fillWidth: true
            Layout.fillHeight: true

            Image {
                anchors.centerIn: parent

                width: 200
                height: 200

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

                spacing: 30

                Controls.MenuButton {
                    width: 280
                    height: 60

                    text: qsTr("CONTINUE")

                    font.bold: true

                    onClicked: root.continueSig()
                }

                Controls.MenuButton {
                    width: 280
                    height: 60

                    text: qsTr("RESTART")

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
