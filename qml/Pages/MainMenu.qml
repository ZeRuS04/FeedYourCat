import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

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

                visible: Logic.lang !== "ru"
                text: qsTr("FEED\nYOUR CAT")
                color: ThemeManager.currentTheme["secondaryTextColor"]
            }

            Image {
                id: titleImage
                anchors.centerIn: parent

                width: 240
                height: 83

                visible: Logic.lang === "ru"
                sourceSize.width: width
                sourceSize.height: height
                source: "qrc:/resources/icons/HOKOPMN_KOTNKOB.svg"
                layer {
                    enabled: true
                    effect: ColorOverlay {
                        color: ThemeManager.currentTheme["secondaryTextColor"]
                    }
                }
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

                bottomPadding: 60

                spacing: 20

                Controls.MenuButton {
                    width: 280
                    height: 60

                    primaryStyle: true
                    text: qsTr("START!")

                    font.bold: true

                    onClicked: root.start()
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
