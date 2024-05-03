import QtQuick
import QtQuick.Controls
import Singletons 1.0

import "pages" as Pages

StackView {
    id: root

    property QtObject storedGameArea

    function updatePage(page) {
        switch (page) {
        case "game":
            clear();
            push(pauseComponent);
            if (!!storedGameArea) {
                storedGameArea.destroy();
            }
            root.storedGameArea = gameComponent.createObject(root);
            push(root.storedGameArea);
            Logic.newGame(false);
            break;
        case "testGame":
            clear();
            push(pauseComponent);
            push(gameComponent);
            Logic.newGame(true);
            break;
        case "continue":
            if (!!storedGameArea) {
                push(storedGameArea);
                Logic.resume();
            }
            break;
        case "rules":
            push(rulesComponent);
            break;
        case "score":
            replace(scoreComponent);
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

    state: !!currentItem && currentItem.pageName ? currentItem.pageName : ""

    Keys.onBackPressed: {
        if (root.depth === 1 || root.state === "score") {
            event.accepted = false;
            return;
        }

        root.pop();
    }

    Binding {
        target: SoundManager

        property: "menuSoundPlaying"
        value: root.state === "mainMenu" || root.state === "rules" ||
               root.state === "settings" || root.state === "score"
    }

    Binding {
        target: SoundManager

        property: "gameMusicPlaying"
        value: root.state === "game" || root.state === "pause"
               || (root.state === "settings" && Logic.sessionStarted)
    }

    Connections {
        target: Logic

        function onGameOver(time, score) {
            updatePage("score")
        }
    }

    Component {
        id: menuComponent

        Pages.MainMenu {
            onStart: updatePage("rules")
            onStartTestMode: updatePage("testGame")
            onSettings: updatePage("settings")
        }
    }

    Component {
        id: settingsComponent

        Pages.Settings {}
    }

    Component {
        id: pauseComponent

        Pages.Pause {
            onContinueSig: updatePage("continue")
            onRestart: updatePage("game")
            onSettings: updatePage("settings")
            onVisibleChanged: if (visible) Logic.pause()
        }
    }

    Component {
        id: gameComponent

        Pages.GameArea {}
    }

    Component {
        id: scoreComponent

        Pages.Score {
            onRestart: updatePage("game")
            onSettings: updatePage("settings")
        }
    }

    Component {
        id: rulesComponent

        Pages.Rules {
            onRestart: updatePage("game")
            onSettings: updatePage("settings")
        }
    }
}
