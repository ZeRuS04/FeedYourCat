import QtQuick 2.0
import QtQuick.Controls 2.12

import "pages" as Pages

StackView {
    id: root

    function updatePage(page) {
        switch (page) {
        case "game":
            replace(pauseComponent);
            push(gameComponent);
            break;
        case "settings":
            push(settingsComponent);
            break;
        }
    }

    initialItem: menuComponent

    states: [
        State {
            name: "mainMenu"
        },
        State {
            name: "settings"
        },
        State {
            name: "rules"
        },
        State {
            name: "game"
        },
        State {
            name: "score"
        },
        State {
            name: "pause"
        }
    ]

    state: currentItem.pageName || ""

    Component {
        id: menuComponent

        Pages.MainMenu {

            onStart: updatePage("game")
            onSettings: updatePage("settings")
        }
    }

    Component {
        id: settingsComponent

        Pages.Settings {

        }
    }

    Component {
        id: pauseComponent

        Pages.Pause {

        }
    }

    Component {
        id: gameComponent

        Pages.GameArea {

        }
    }
}
