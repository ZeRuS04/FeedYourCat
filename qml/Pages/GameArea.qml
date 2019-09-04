import QtQuick 2.0
import "../controls" as Controls

import Singletons 1.0

Controls.BasePage {
    id: root

    pageName: "game"
    foodCount: 0

    Item {
        id: timerItem

        anchors.top: parent.top
        anchors.bottom: gridItem.top
        width: parent.width

        Controls.Label {
            anchors.centerIn: parent

            text: "00:00"
            font.pointSize: 40
            color: ThemeManager.currentTheme["toolbarTextColor"]
        }
    }

    Item {
        id: gridItem

        anchors {
            bottom: parent.bottom
            bottomMargin: root.height / 15
        }

        width: parent.width
        height: grid.height

        Grid {
            id: grid

            anchors.centerIn: parent
            columns: 3
            spacing: root.width / 24

            Repeater {
                model: 12

                delegate: Controls.GameCell {
                    width: (root.width - (root.width / 6)) / 3
                }
            }
        }
    }
}

