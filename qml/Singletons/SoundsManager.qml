pragma Singleton
import QtQuick 2.12
import QtMultimedia 5.12
import Singletons 1.0

Item {
    id: root

    property bool menuSoundPlaying: false
    property bool gameMusicPlaying: false

    function updateVolume(volume) {
        buttonSound.volume = volume;
        feedCatSound.volume = volume;
        feedTigerSound.volume = volume;
        menuSound.volume = volume;
        gameMusicSound.volume = volume;
    }

    function buttonClickPlay() {
        buttonSound.stop()
        buttonSound.play()
    }
    function feedCatPlay() {
        feedCatSound.stop()
        feedCatSound.play()
    }
    function feedTigerPlay() {
        feedTigerSound.stop()
        feedTigerSound.play()
    }

    Audio {
        id: buttonSound

        audioRole: Audio.GameRole
        source: "qrc:/resources/sounds/buttons.ogg"
    }
    Audio {
        id: feedCatSound

        audioRole: Audio.GameRole
        source: "qrc:/resources/sounds/feedcat.ogg"
    }
    Audio {
        id: feedTigerSound

        audioRole: Audio.GameRole
        source: "qrc:/resources/sounds/feedtiger.ogg"
    }
    Audio {
        id: menuSound

        property bool needPlay: Qt.application.state === Qt.ApplicationActive && root.menuSoundPlaying

        onNeedPlayChanged: {
            if (needPlay)
                menuSound.play();
            else if (root.menuSoundPlaying)
                menuSound.pause();
            else
                menuSound.stop();
        }

//        volume: Common.soundVolume
        audioRole: Audio.GameRole
        loops: -1
        source: "qrc:/resources/sounds/purring.ogg"
    }
    Audio {
        id: gameMusicSound


        property bool needPlay: Qt.application.state === Qt.ApplicationActive && root.gameMusicPlaying

        onNeedPlayChanged: {
            if (needPlay)
                gameMusicSound.play();
            else if (root.gameMusicPlaying)
                gameMusicSound.pause();
            else
                gameMusicSound.stop();
        }

        audioRole: Audio.GameRole
        loops: -1
        source: "qrc:/resources/sounds/main1.mp3"
//        playbackRate: Logic.session.currentStage * 1.05

    }

//    Timer {
//        interval: 2000
//        running: true
//        onTriggered: gameMusicSound.playbackRate += 0.2
//    }
}


