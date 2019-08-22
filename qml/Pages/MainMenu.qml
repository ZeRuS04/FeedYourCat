import QtQuick 2.12
import QtQuick.Layouts 1.12

import "../controls" as Controls

Controls.BackgroundGradient {
    id: root

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

            Rectangle {
                anchors.centerIn: parent

                color: "gray"
                width: 280
                height: 285
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: buttonsColumn.height

            Column {
                id: buttonsColumn

                anchors.centerIn: parent

                bottomPadding: 20

                spacing: 23

                Controls.MenuButton {
                    width: 280
                    height: 60

                    text: qsTr("START!")

                    font.bold: true
                }

                Controls.MenuButton {
                    width: 280
                    height: 60

                    text: qsTr("SETTINGS")
                }
            }
        }
    }
}
