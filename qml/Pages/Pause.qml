import QtQuick
import QtQuick.Layouts

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
                source: ThemeManager.currentTheme["pauseImage"]
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
                    text: qsTr("CONTINUE")
                    primaryStyle: true
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
                    icon.source: "qrc:/resources/icons/settings.svg"
                    text: qsTr("SETTINGS")
                    onClicked: root.settings()
                }
            }
        }
    }
}
