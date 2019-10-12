import QtQuick 2.12
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Layouts 1.12

import Singletons 1.0

QQC2.ToolBar {
    id: root

    property QtObject stack

    state: stack.state
    states: [
        State {
            name: "mainMenu"

            PropertyChanges { target: root; visible: false }
        },
        State {
            name: "settings"

            PropertyChanges { target: root; visible: true }
        },
        State {
            name: "rules"

            PropertyChanges { target: root; visible: false }
        },
        State {
            name: "game"

            PropertyChanges { target: root; visible: true }
            PropertyChanges { target: scorePanel; visible: true }
            PropertyChanges { target: pauseButton; visible: true }
        },
        State {
            name: "score"

            PropertyChanges { target: root; visible: false }
        },
        State {
            name: "pause"

            PropertyChanges { target: root; visible: false }
        }
    ]

    background: null

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 30
            rightMargin: 30
        }

        BackToolButton {
            width: height / 35 * 25
            height: parent.height / 1.5
            onClicked: stack.pop()
        }

        Item {
            id: centerItem

            Layout.fillWidth: visible
            Layout.preferredHeight: root.height

            ScorePanel {
                id: scorePanel

                anchors.centerIn: parent

                visible: false
            }

            Label {
                id: titleLabel

                anchors.fill: parent
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: Qt.AlignVCenter

                text: stack.currentItem && stack.currentItem.hasOwnProperty("title") ? stack.currentItem.title
                                                                                     : ""
                elide: Label.ElideRight
                color: ThemeManager.currentTheme["toolbarTextColor"]
            }
        }

        PauseToolButton {
            id: pauseButton

            width: height
            height: parent.height / 1.5
            visible: false
            checked: Logic.sessionPaused

            onToggled: {
                checked ? Logic.pause()
                        : Logic.resume()
            }
        }
    }
}
