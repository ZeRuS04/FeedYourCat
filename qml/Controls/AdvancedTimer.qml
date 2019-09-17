import QtQuick 2.12

QtObject {
    id: root

    property int interval: 0
    property int timeLeft: 0
    property int delta: 100
    property bool running: timer.running
    property bool repeat: false

    signal tick(int time);
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
        timer.stop();
    }
    function resume() {
        timer.start();
    }

    property Timer __timer: Timer {
        id: timer

        interval: Math.min(root.timeLeft, root.delta)
        repeat: root.timeLeft > 0

        onTriggered: {
            root.tick(interval);
            root.timeLeft -=interval;
            if (timeLeft === 0) {
                root.triggered();
                if (root.repeat)
                    root.restart();
            }
        }
    }
}
