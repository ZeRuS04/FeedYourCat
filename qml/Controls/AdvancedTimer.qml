import QtQuick

QtObject {
    id: root

    property int interval: 0
    property int timeLeft: 0
    property int delta: 100
    property alias running: timer.running
    property bool repeat: false
    property bool paused: false

    signal tick(time: int);
    signal triggered()

    function start() {
        if (running)
            return;
        timer.stop();
        timeLeft = interval;
        timer.start();
    }
    function restart() {
        timer.stop();
        timeLeft = interval;
        timer.start();
    }
    function stop() {
        timeLeft = 0;
        timer.stop();
    }
    function pause() {
        if (timer.running) {
            timer.stop();
            paused = true;
        }
    }
    function resume() {
        if (root.paused) {
            root.paused = false;
            timer.start();
        }
    }
    property Timer __timer: Timer {
        id: timer

        interval: Math.min(root.timeLeft, root.delta)
        repeat: root.timeLeft > 0

        onTriggered: {
            root.tick(interval);
            root.timeLeft -=interval;
            if (timeLeft === 0) {
                Qt.callLater(root.triggered);
                if (root.repeat) {
                    root.restart();
                }
            }
        }
    }
}
