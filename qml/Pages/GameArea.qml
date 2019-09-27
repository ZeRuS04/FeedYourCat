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

            text: !!Logic.session ? Qt.formatTime(new Date(Logic.session.timeLeft), "mm:ss")
                                  : "00:00"

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
            columns: Logic.columnCount
            spacing: root.width / 24

            Repeater {
                model: Logic.columnCount * Logic.rowCount

                delegate: Controls.GameCell {
                    cellIndex: model.index
                    width: (root.width - (root.width / 6)) / 3
                }
            }
        }
    }
}

