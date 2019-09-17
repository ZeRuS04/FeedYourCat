import QtQuick 2.0
import QtQuick.Controls 2.12
import Singletons 1.0

import "pages" as Pages

StackView {
    id: root

    function updatePage(page) {
        switch (page) {
        case "game":
            replace(pauseComponent);
            push(gameComponent);
            Logic.newGame();
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

    Keys.onBackPressed: {
        if (root.empty) {
            event.accepted = false;
            return;
        }

        root.pop();
    }

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

            onContinueSig: updatePage("game")
            onSettings: updatePage("settings")
        }
    }

    Component {
        id: gameComponent

        Pages.GameArea {

        }
    }
}
