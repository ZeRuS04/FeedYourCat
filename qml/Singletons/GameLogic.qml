pragma Singleton

import QtQuick
import QtCore

import "../helpers/Constants.js" as Constants
import "../controls" as Controls

Item {
    id: root

    property QtObject session: null
    property bool sessionStarted: false
    property bool sessionPaused: false

    property int lastScore: 0
    property int lastTime: 0
    property int lastFedCat: 0

    property alias topScore: setting.topScore
    property alias topSessionTime: setting.topSessionTime
    property alias topFedCat: setting.topFedCat
    property alias totalFedCat: setting.totalFedCat
    property alias totalGameTime: setting.totalGameTime
    property alias soundVolume: setting.soundVolume
    property alias vibrationEnabled: setting.vibrationEnabled
    property alias lang: setting.lang

    property int columnCount: 3
    property int rowCount: 4

    property int time: 30
    property int startCats: 2
    property real baseNewCatInterval: 1.0
    property int rewardForFeedCat: 1
    property int rewardForSkipCat: 0
    property int rewardForTiger: -10
    property int stagesInterval: 5
    property var newStageCatCount: [1,2,3]
    property var newStageTigerChance: [8,13,18.23,27,30,35,40]
    property int minimumCatDelay: 1200
    property int maximumCatDelay: 1800
    property real tigerTimeFactor: 1.0
    property real speedIncreaseCof: 1.05
    property int foodCount: 0
    property int maxTigersInRow: 4

    signal gameOver(int time, int score);

    function newGame(isTestMode) {
        if (!!session)
            session.destroy();
        session = sessionComponent.createObject(root, {isTestMode: isTestMode});
        sessionStarted = true;
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
    onLastTimeChanged: {
        if (lastTime > topSessionTime) topSessionTime = lastTime;
        totalGameTime += lastTime;
    }
    onLastFedCatChanged: {
        if (lastFedCat > topFedCat) topFedCat = lastFedCat;
        totalFedCat += topFedCat;
    }
    onGameOver: sessionStarted = false

    Settings {
        id: setting

        property int topScore: 0
        property int topSessionTime: 0
        property int topFedCat: 0
        property int totalFedCat: 0
        property int totalGameTime: 0
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
            property int fedCat: 0
            property int score: 0
            property int totalSessionTime: 0
            property alias timeLeft: mainGameTimer.timeLeft
            property int time: root.time * 1000
            property int multiplier: 1
            property int startCats: root.startCats
            property int newCatInterval:Math.max(root.baseNewCatInterval * Math.pow(0.9, currentStage) * 1000, 500)
//            property int newCatCount: newStageCatCount[Math.min(currentStage, newStageCatCount.length - 1)]
            property int stagesInterval: root.stagesInterval
            property var newStageCatCount: root.newStageCatCount
            property real tigerChance: root.newStageTigerChance[Math.min(currentStage, root.newStageTigerChance.length - 1)] / 100
            property int currentStage: 0
            property int rewardForFeedCat: root.rewardForFeedCat * 1000
            property int rewardForSkipCat: root.rewardForSkipCat * 1000
            property int rewardForTiger: root.rewardForTiger * 1000
            property real speedIncreaseCof: root.speedIncreaseCof
            property int minimumCatDelay: root.minimumCatDelay
            property int maximumCatDelay: root.maximumCatDelay
            property real tigerTimeFactor: root.tigerTimeFactor
            property int __tigersInRow: 0

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
                return __tigersInRow < root.maxTigersInRow && Math.random() <= tigerChance;
            }

            function emitCat() {
                var index = Math.floor(Math.random() * cellCount);
                var c = 1
                let ccw = Math.random() > 0.5;
                while (area[index] !== 0) {
                    if (c > cellCount)
                        break;
                    if (ccw) {
                        index++;
                        if (index >= cellCount)
                            index = 0;
                    } else {
                        index--;
                        if (index < 0)
                            index = cellCount - 1;
                    }
                    c++;
                }
                if (area[index] !== 0) {
                    return;
                }
                var isTiger  = emitTiger();
                if (isTiger) {
                    __tigersInRow++;
                } else {
                    __tigersInRow = 0;
                }

                area[index] = isTiger ? (Math.floor(Math.random() * Constants.tigersCatalog.length) + 1) * -1
                                      : Math.floor(Math.random() * Constants.catsCatalog.length) + 1;
                areaChanged();
            }

            function hideCat(index, isFed) {
                if (area[index] < 0 && isFed) {
                    if (timeLeft <= Math.abs(rewardForTiger) && !isTestMode) {
                        root.pause();
                        root.lastScore = sessionObj.score;
                        root.lastFedCat = sessionObj.fedCat;
                        root.lastTime = sessionObj.totalSessionTime;
                        root.gameOver(sessionObj.totalSessionTime, sessionObj.fedCat);
                        multiplier = 1;
                        Vibrator.vibrate(500);
                        Vibrator.vibrate(500);
                    } else {
                        timeLeft += rewardForTiger;
                        Vibrator.vibrate(500);
                    }
                    area[index] = 0;
                    return;
                }

                if (area[index] > 0) {
                    fedCat += isFed ? 1 : 0;
                    score += isFed ? multiplier : 0;
                    multiplier = isFed ? Math.min(8, multiplier + 1) : multiplier;
                    timeLeft += isFed ? rewardForFeedCat
                                      : rewardForSkipCat;
                }
                area[index] = 0;
                areaChanged()
            }

            function updateStage() {
                minimumCatDelay = Math.max(minimumCatDelay / speedIncreaseCof, 300);
                maximumCatDelay = Math.max(maximumCatDelay / speedIncreaseCof, 500);
                tigerTimeFactor = Math.min(tigerTimeFactor * speedIncreaseCof, 2.0);
//                newCatInterval /= speedIncreaseCof;
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

                interval: sessionObj.stagesInterval * 1000
                repeat: true

                onTriggered: {
                    currentStage++;
                    updateStage();
//                    restart();
                }
            }

            Controls.AdvancedTimer {
                id: mainGameTimer

                interval: sessionObj.time
                onTick: function (time) { sessionObj.totalSessionTime += time; }
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
                delta: 100

                onTriggered: sessionObj.emitCat()
            }
        }
    }
}
