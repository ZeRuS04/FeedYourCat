pragma Singleton

import QtQuick
import QtMultimedia
import Singletons 1.0

Item {
    id: root

    property bool menuSoundPlaying: false
    property bool gameMusicPlaying: false
    property bool pauseMusic: false

    property real __globalVolume: 1

    function updateVolume(volume) {
        Qt.callLater(__updateVolume, volume)
    }
    function __updateVolume(volume) {
        __globalVolume = volume;
    }
    function buttonClickPlay() {
        buttonSound.stop();
        buttonSound.play();
    }
    function feedCatPlay() {
        feedCatSound.stop();
        feedCatSound.play();
    }
    function feedTigerPlay() {
        feedTigerSound.stop();
        feedTigerSound.play();
    }

    MediaPlayer {
        id: buttonSound
        source: "qrc:/resources/sounds/buttons.ogg"
        audioOutput: AudioOutput { volume: root.__globalVolume }
    }
    MediaPlayer {
        id: feedCatSound
        source: "qrc:/resources/sounds/feedcat.ogg"
        audioOutput: AudioOutput { volume: root.__globalVolume }
    }
    MediaPlayer {
        id: feedTigerSound
        source: "qrc:/resources/sounds/feedtiger.ogg"
        audioOutput: AudioOutput { volume: root.__globalVolume }
    }
    MediaPlayer {
        id: menuSound

        property bool needPlay: Qt.application.state === Qt.ApplicationActive && root.menuSoundPlaying

        loops: -1
        source: "qrc:/resources/sounds/purring.ogg"
        audioOutput: AudioOutput { volume: root.__globalVolume }
        onNeedPlayChanged: {
            if (needPlay)
                menuSound.play();
            else if (root.menuSoundPlaying)
                menuSound.pause();
            else
                menuSound.stop();
        }
    }
    MediaPlayer {
        id: gameMusicSound

        property real realVolume: root.__globalVolume
        property bool needPlay: Qt.application.state === Qt.ApplicationActive && root.gameMusicPlaying
        property bool isLastPart: false
        property Connections connection: Connections {
            target: Logic

            function onGameOver(time, score) {
                gameMusicSound.isLastPart = false;
                gameMusicSound.loops = 1;
            }
        }

        loops: 1
        source: !isLastPart ? "qrc:/resources/sounds/main1.ogg"
                           : "qrc:/resources/sounds/main1loop.ogg"
        audioOutput: AudioOutput { volume: pauseMusic ? gameMusicSound.realVolume / 4 : gameMusicSound.realVolume }
        onNeedPlayChanged: {
            if (needPlay)
                gameMusicSound.play();
            else if (root.gameMusicPlaying)
                gameMusicSound.pause();
            else
                gameMusicSound.stop();
        }
        onPlayingChanged: {
            if (!gameMusicSound.playing) {
                loops = -1;
                isLastPart = true;
                play();
            }
        }
    }
}


