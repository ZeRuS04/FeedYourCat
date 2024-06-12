import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Singletons 1.0
import "." as Controls

ToolBar {
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

            PropertyChanges { target: root; visible: !Logic.sessionPaused }
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

    Rectangle {
        anchors.fill: parent
        color: ThemeManager.currentTheme["toolbarBackgroundColor"]
        opacity: ThemeManager.currentTheme["toolbarBackgroundOpacity"]

        RowLayout {
            anchors {
                fill: parent
                leftMargin: 20
                rightMargin: 20
            }

            BackToolButton {
                Layout.fillHeight: true
                Layout.preferredWidth: height
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
                Controls.Label {
                    id: titleLabel

                    anchors.fill: parent
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter

                    text: stack.currentItem && stack.currentItem.hasOwnProperty("title") ? stack.currentItem.title
                                                                                         : ""
                    elide: Label.ElideRight
                    color: ThemeManager.currentTheme["mainTextColor"]
                }
            }
            PauseToolButton {
                id: pauseButton

                Layout.fillHeight: true
                Layout.preferredWidth: height
                visible: false
                checked: Logic.sessionPaused
                onToggled: {
                    !Logic.sessionPaused ? Logic.pause()
                                         : Logic.resume()
                }
            }
        }
    }
}
