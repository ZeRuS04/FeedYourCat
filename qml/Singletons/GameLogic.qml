pragma Singleton

import QtQuick 2.12
import Qt.labs.settings 1.1

import "../helpers/Constants.js" as Constants
import "../controls" as Controls

Item {
    id: root

    property QtObject session: null
    property bool sessionStarted: false
    property bool sessionPaused: false

    property int lastScore: 0
    property int lastTime: 0

    property alias topScore: setting.topScore
    property alias soundVolume: setting.soundVolume
    property alias vibrationEnabled: setting.vibrationEnabled
    property alias lang: setting.lang

    property int columnCount: 3
    property int rowCount: 4

    property int time: 30
    property int startCats: 3
    property real newCatInterval: 1.3
    property int rewardForFeedCat: 1
    property int rewardForSkipCat: 0
    property int rewardForTiger: -20
    property var stagesInterval: [7,12,15]
    property var newStageCatCount: [1,2,3]
    property var newStageTigerChance: [8,13,18.25,33,40]
    property int minimumCatDelay: 1200
    property int maximumCatDelay: 1800
    property real speedIncreaseCof: 1.05

    signal gameOver(int time, int score);

    function newGame(isTestMode) {
        if (!!session)
            session.destroy();
        session = sessionComponent.createObject(root, {isTestMode: isTestMode});
        sessionPaused = false;
    }

    function pause() {
        if(!!session) {
            session.pause();
            sessionPaused = true;
        } else
            console.warn("Error pause: session is not open yet");
    }

    function resume() {
        if(!!session) {
            session.resume();
            sessionPaused = false;
        } else
            console.warn("Error resume: session is not open yet");
    }

    onLastScoreChanged: if (lastScore > topScore) topScore = lastScore

    Settings {
        id: setting

        property int topScore: 0
        property real soundVolume: 1
        property bool vibrationEnabled: true
        property string lang: "en"

        onLangChanged: Translator.setTranslation(lang)
    }

    Component {
        id: sessionComponent

        Item {
            id: sessionObj

            signal pause()
            signal resume()

            property bool isTestMode: false
            readonly property int cellCount: root.rowCount * root.columnCount
            property var area: []
            property int score: 0
            property int totalSessionTime: 0
            property alias timeLeft: mainGameTimer.timeLeft
            property int time: root.time * 1000
            property int startCats: root.startCats
            property int newCatInterval: root.newCatInterval * 1000
            property int newCatCount: newStageCatCount[Math.min(currentStage, newStageCatCount.length - 1)]
            property var stagesInterval: root.stagesInterval
            property var newStageCatCount: root.newStageCatCount
            property real tigerChance: root.newStageTigerChance[Math.min(currentStage, root.newStageTigerChance.length - 1)] / 100
            property int currentStage: 0
            property int rewardForFeedCat: root.rewardForFeedCat * 1000
            property int rewardForSkipCat: root.rewardForSkipCat * 1000
            property int rewardForTiger: root.rewardForTiger * 1000
            property real speedIncreaseCof: root.speedIncreaseCof
            property int minimumCatDelay: root.minimumCatDelay
            property int maximumCatDelay: root.maximumCatDelay

            function initArea() {
                for (var i = 0, c = Constants.tigersCatalog.length * -1; i < cellCount; i++, c++) {
                    if (isTestMode && c <= Constants.catsCatalog.length) {
                        area.push(c);
                        continue;
                    }
                    area.push(0);
                }
            }

            function initGame() {
                mainGameTimer.start()
                nextStageTimer.start()

                for (var i = 0; i < startCats; ++i) {
                    var index = Math.floor(Math.random() * cellCount);
                    while (area[index] !== 0) {
                        index = Math.floor(Math.random() * cellCount);
                    }
                    area[index] = Math.floor(Math.random() * Constants.catsCatalog.length) + 1;
                }
                areaChanged();

                mainGameTimer.start();
                nextStageTimer.start();
                nextCatTimer.start();
            }

            function emitTiger() {
                return Math.random() <= tigerChance;
            }

            function emitCat() {
                for (var i = 0; i < newCatCount; ++i) {
                    var index = Math.floor(Math.random() * cellCount);
                    var c = 1
                    while (area[index] !== 0) {
                        if (c > cellCount)
                            break;
                        index = Math.floor(Math.random() * cellCount);
                        c++;
                    }
                    if (area[index] !== 0)
                        continue;
                    var isTiger  = emitTiger();
                    area[index] = isTiger ? (Math.floor(Math.random() * Constants.tigersCatalog.length) + 1) * -1
                                          : Math.floor(Math.random() * Constants.catsCatalog.length) + 1;
                }
                areaChanged();
            }

            function hideCat(index, isFed) {
                if (area[index] < 0 && isFed) {
                    if (timeLeft <= Math.abs(rewardForTiger) && !isTestMode) {
                        root.pause();
                        root.lastScore = sessionObj.score;
                        root.lastTime = sessionObj.totalSessionTime;
                        root.gameOver(sessionObj.totalSessionTime, sessionObj.score)
                        Vibrator.vibrate(500)
                        Vibrator.vibrate(500)
                    } else {
                        timeLeft += rewardForTiger;
                        Vibrator.vibrate(500)
                    }
                    area[index] = 0;
                    return;
                }

                if (area[index] > 0) {
                    score += isFed ? 1 : 0;
                    timeLeft += isFed ? rewardForFeedCat
                                      : rewardForSkipCat;
                }
                area[index] = 0;
                areaChanged()
            }

            function updateStage() {
                minimumCatDelay /= speedIncreaseCof;
                maximumCatDelay /= speedIncreaseCof;
                newCatInterval /= speedIncreaseCof;
            }

            Component.onCompleted: {
                initArea();
                if (!isTestMode)
                    initGame();
            }
            onPause: {
                mainGameTimer.pause();
                nextStageTimer.pause();
                nextCatTimer.pause();
            }
            onResume: {
                mainGameTimer.resume();
                nextStageTimer.resume();
                nextCatTimer.resume();
            }

            Controls.AdvancedTimer {
                id: nextStageTimer

                interval: sessionObj.stagesInterval[Math.min(sessionObj.currentStage, sessionObj.stagesInterval.length - 1)] * 1000
                repeat: true

                onTriggered: {
                    currentStage++
                    updateStage();
//                    restart();
                }
            }

            Controls.AdvancedTimer {
                id: mainGameTimer

                interval: sessionObj.time
                onTick: sessionObj.totalSessionTime += time
                onTriggered: {
                    if (!isTestMode) {
                        root.pause();
                        root.lastScore = sessionObj.score;
                        root.lastTime = sessionObj.totalSessionTime;
                        root.gameOver(sessionObj.totalSessionTime, sessionObj.score)
                    }
                }
            }

            Controls.AdvancedTimer {
                id: nextCatTimer

                interval: sessionObj.newCatInterval
                repeat: true

                onTriggered: sessionObj.emitCat()
            }
        }
    }
}
