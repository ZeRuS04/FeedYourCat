import QtQuick
import QtQuick.Layouts

import "../controls" as Controls
import Singletons 1.0

Controls.BasePage {
    id: root

    property int score: !!Logic.session ? Logic.session.score : 0
    property int fedCat: !!Logic.session ? Logic.session.fedCat : 0

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

                spacing: 20

                Controls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 30
                    text: qsTr("YOUR RESULT:")
                    color: ThemeManager.currentTheme["secondaryTextColor"]
                }
                Controls.ScoreParameter {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 280
                    value: ({
                        multiplier: "x%1".arg("8"),
                        text: root.score || "0"
                    })
                    state: "score"
                }
                Controls.ScoreParameter {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 280
                    value: ({
                        text: root.fedCat || "0"
                    })
                    state: "cats"
                }
                Controls.ScoreParameter {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 280
                    value: ({
                                text: !!Logic.session ? Qt.formatTime(new Date(Logic.session.totalSessionTime), "mm:ss")
                                                      : "00:00"
                            })
                    state: "time"
                }
                Item {
                    width: 10
                    height: 20
                }
                Controls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 30
                    text: qsTr("HIGH RESULT:")
                    color: ThemeManager.currentTheme["secondaryTextColor"]
                }
                Controls.ScoreParameter {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 280
                    value: ({
                        multiplier: "x%1".arg("8"),
                        text: Logic.topScore
                    })
                    state: "score"
                }
                Controls.ScoreParameter {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 280
                    value: ({
                        text: Logic.topFedCat
                    })
                    state: "cats"
                }
                Controls.ScoreParameter {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 280
                    value: ({
                                text: Qt.formatTime(new Date(Logic.topSessionTime), "mm:ss")
                            })
                    state: "time"
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
