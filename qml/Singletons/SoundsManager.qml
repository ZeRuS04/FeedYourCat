pragma Singleton

import QtQuick
import QtMultimedia
import Singletons 1.0

Item {
    id: root

    property bool menuSoundPlaying: false
    property bool gameMusicPlaying: false
    property bool pauseMusic: false
    property int index: -1
    property list<SoundEffect> dropCoinSounds: [
        SoundEffect {
            muted: Qt.application.state === Qt.ApplicationInactive
            source: "qrc:/resources/sounds/dropcoin5.wav"
        },
        SoundEffect {
            muted: Qt.application.state === Qt.ApplicationInactive
            source: "qrc:/resources/sounds/dropcoin2.wav"
        },
        SoundEffect {
            muted: Qt.application.state === Qt.ApplicationInactive
            source: "qrc:/resources/sounds/dropcoin5.wav"
        },
        SoundEffect {
            muted: Qt.application.state === Qt.ApplicationInactive
            source: "qrc:/resources/sounds/dropcoin3.wav"
        },
        SoundEffect {
            muted: Qt.application.state === Qt.ApplicationInactive
            source: "qrc:/resources/sounds/dropcoin4.wav"
        },
        SoundEffect {
            muted: Qt.application.state === Qt.ApplicationInactive
            source: "qrc:/resources/sounds/dropcoin5.wav"
        },
        SoundEffect {
            muted: Qt.application.state === Qt.ApplicationInactive
            source: "qrc:/resources/sounds/dropcoin1.wav"
        }
    ]
    property real __globalVolume: 1

    function playDropCoinSounds(weight) {
        if (root.__globalVolume === 0 ) {
            return;
        }

        index++;
        let t = 0;
        let startPos = Math.floor(Math.random() * dropCoinSounds.length)
        while(t < dropCoinSounds.length) {
            t++;
            let mediaPlayer = dropCoinSounds[(startPos + index + t) % dropCoinSounds.length];
            if (!mediaPlayer.playing || t > dropCoinSounds.length) {
                mediaPlayer.stop();
                mediaPlayer.volume = Math.min(1,  weight / 0.3) * root.__globalVolume
                mediaPlayer.play();
                return;
            }
        }
    }
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
    function fallPlay(index) {
        var player;
        switch(index) {
        case 0:
            player = fallSound3;
            break;
        case 1:
            player = fallSound2;
            break;
        case 2:
            player = fallSound1;
            break;
        default:
            player = fallSound3;
        }

        player.play();
    }
    function whooshPlay() {
        whoosh.stop();
        whoosh.play();
    }
    function drumhitPlay() {
        drumhit.stop();
        drumhit.play();
    }
    function hungryPlay() {
        hungrySound.stop();
        hungrySound.play();
    }

    SoundEffect {
        id: hungrySound

        volume: root.__globalVolume
        muted: Qt.application.state === Qt.ApplicationInactive
        source: "qrc:/resources/sounds/hungry.wav"
    }
    SoundEffect {
        id: fallSound1

        volume: root.__globalVolume
        muted: Qt.application.state === Qt.ApplicationInactive
        source: "qrc:/resources/sounds/fallonwood4.wav"
    }
    SoundEffect {
        id: fallSound2

        volume: root.__globalVolume
        muted: Qt.application.state === Qt.ApplicationInactive
        source: "qrc:/resources/sounds/fallonwood5.wav"
    }
    SoundEffect {
        id: fallSound3

        volume: root.__globalVolume
        muted: Qt.application.state === Qt.ApplicationInactive
        source: "qrc:/resources/sounds/fallonwood3.wav"
    }
    SoundEffect {
        id: drumhit

        volume: root.__globalVolume
        muted: Qt.application.state === Qt.ApplicationInactive
        source: "qrc:/resources/sounds/drumhit.wav"
    }
    SoundEffect {
        id: whoosh

        volume: root.__globalVolume
        muted: Qt.application.state === Qt.ApplicationInactive
        source: "qrc:/resources/sounds/whoosh.wav"
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

            function onSessionStartedChanged() {
                if (!Logic.sessionStarted) {
                    gameMusicSound.isLastPart = false;
                    gameMusicSound.loops = 1;
                }
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
            if (!gameMusicSound.playing && Logic.sessionStarted && !Logic.sessionPaused && needPlay) {
                loops = -1;
                isLastPart = true;
                play();
            }
        }
    }
}


