pragma Singleton

import QtQuick 2.12
import "../controls" as Controls

Item {
    id: root

    property QtObject session: null
    property bool sessionStarted: false
    property bool sessionPaused: false

    property int lastScore: 0
    property int lastTime: 0

    property int time: 30
    property int startCats: 3
    property int newCatInterval: 1
    property int rewardForFeedCat: 1
    property int rewardForSkipCat: 0
    property int rewardForTiger: -20
    property var stagesInterval: [10,15,20]
    property var newStageCatCount: [1,2,3]
    property int minimumCatDelay: 1000
    property int maximumCatDelay: 2000

    signal gameOver(int time, int score);

    function newGame() {
        if (sessionStarted)
            session.destroy();
        session = sessionComponent.createObject(root);
    }

    function pause() {
        if(sessionStarted) {
            session.pause();
            sessionPaused = true;
        } else
            console.warn("Error pause: session is not open yet");
    }

    function resume() {
        if(sessionStarted) {
            session.resume();
            sessionPaused = false;
        } else
            console.warn("Error resume: session is not open yet");
    }


    Component {
        id: sessionComponent

        Item {
            id: sessionObj

            signal pause()
            signal resume()

            property var area: [0, 0, 0,
                                0, 0, 0,
                                0, 0, 0,
                                0, 0, 0]
            property int score: 0
            property int totalSessionTime: 0
            property alias timeLeft: mainGameTimer.timeLeft
            property int time: root.time * 1000
            property int startCats: root.startCats
            property int newCatInterval: root.newCatInterval * 1000
            property int newCatCount: newStageCatCount[currentStage]
            property var stagesInterval: root.stagesInterval.push(0)
            property var newStageCatCount: root.newStageCatCount
            property int currentStage: 0
            property int rewardForFeedCat: root.rewardForFeedCat * 1000
            property int rewardForSkipCat: root.rewardForSkipCat * 1000
            property int rewardForTiger: root.rewardForTiger * 1000

            function init() {
                mainGameTimer.start()
                nextStageTimer.start()

                for (var i = 0; i < startCats; ++i) {
                    var index = Math.floor(Math.random() * 12);
                    while (area[index] !== 0) {
                        index = Math.floor(Math.random() * 12);
                    }
                    area[index] = Math.floor(Math.random() * 6);
                }
                areaChanged();

                mainGameTimer.start()
                nextStageTimer.start()
                nextCatTimer.start();
                root.sessionStarted = true;
            }


            function emitCat() {
                for (var i = 0; i < startCats; ++i) {
                    var index = Math.floor(Math.random() * 12);
                    while (area[index] !== 0) {
                        index = Math.floor(Math.random() * 12);
                    }
//                    if (area[index] === 0)
                        area[index] = Math.floor(Math.random() * 6);
                }
                areaChanged();
            }

            function hideCat(index, isFed) {
//                console.log("###hideCat")
                if (area[index] < 0 && isFed) {
                    if (timeLeft <= rewardForTiger) {
                        root.pause();
                        root.lastScore = sessionObj.score;
                        root.lastTime = sessionObj.totalSessionTime;
                        root.gameOver(sessionObj.totalSessionTime, sessionObj.score)
                    } else {
                        timeLeft += rewardForTiger;
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


            Component.onCompleted: {
                init();
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

                interval: sessionObj.stagesInterval[sessionObj.currentStage] * 1000

                onTriggered: {
                    if (currentStage < sessionObj.newStageCatCount.length - 1) {
                        sessionObj.currentStage++;
                        restart();
                    }
                }
            }

            Controls.AdvancedTimer {
                id: mainGameTimer

                interval: sessionObj.time
                onTick: sessionObj.totalSessionTime += time
                onTriggered: {
                    root.pause();
                    root.lastScore = sessionObj.score;
                    root.lastTime = sessionObj.totalSessionTime;
                    root.gameOver(sessionObj.totalSessionTime, sessionObj.score)
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
