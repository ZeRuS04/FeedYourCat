import QtQuick 2.12
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Layouts 1.12

import Singletons 1.0

QQC2.ToolBar {
    id: root

    property QtObject stack

    height: 70
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

            PropertyChanges { target: root; visible: true }
        },
        State {
            name: "game"


            PropertyChanges { target: root; visible: true }
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

    background: Rectangle {
        color: ThemeManager.currentTheme["toolbarBackgroundColor"]
        opacity: 0.7
    }

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 30
            rightMargin: 30
        }

        ToolButton {
            width: 70
            height: 70
            text: qsTr("‹")
            onClicked: stack.pop()
        }

        Label {
            id: titleLabel

            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignRight
            verticalAlignment: Qt.AlignVCenter

            font.pointSize: 20
            text: stack.currentItem && stack.currentItem.hasOwnProperty("title") ? stack.currentItem.title
                                                                                 : ""
            elide: Label.ElideRight
            color: ThemeManager.currentTheme["toolbarTextColor"]
        }
    }
}
