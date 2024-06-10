import QtQuick
import QtMultimedia

import Singletons 1.0
import "../helpers/Constants.js" as Constants

Item {
    id: root

    signal finished()

    function start(count) {
        presenter.initialize(count);
        presenter.dropTimer.start();
    }

    MouseArea {
        anchors.fill: parent
        onClicked: presenter.skipAnimation = true
    }
    Component {
        id: catcoinComponent

        Rectangle {
            id: catcoin

            property point centerPosition
            property int backgroundIndex: Math.floor(Math.random() * 6)
            property int catcoinIndex: Math.floor(Math.random() * 6)
            property int delay: 0
            property real dispersion: 0.1
            property real weight: 0
            property real targetWidth: 0
            property bool isLastCoin: false
            property string backgroundColor: Constants.catBackgrounds[backgroundIndex]
            property string borderColor: Constants.catBorders[backgroundIndex]

            x: centerPosition.x - width / 2 + width * (Math.random() * dispersion * 2 - dispersion)
            y: -height
            z: Math.floor(Math.random() * 10)
            width: targetWidth + targetWidth * (Math.random() * dispersion * 2 - dispersion)
            height: width
            radius: Number.MAX_VALUE
            color: backgroundColor
            Component.onCompleted: dropAnimation.start()

            Connections {
                target: presenter

                function onSkipAnimationChanged() {
                    if (presenter.skipAnimation && dropAnimation.running) {
                        dropAnimation.stop();
                        catcoin.y = yAnimator.to;
                    }
                }
            }
            SequentialAnimation {
                id: dropAnimation

                onFinished: if (catcoin.isLastCoin) root.finished()

                PauseAnimation {
                    duration: presenter.skipAnimation ? 0 : catcoin.delay
                }
                ParallelAnimation {
                    RotationAnimator {
                        target: catcoin
                        duration: presenter.skipAnimation ? 10 : 800
                        from: 0
                        to: 25 * (Math.random() * dispersion * 2 - dispersion)
                    }
                    SequentialAnimation {
                        PauseAnimation {
                            duration: 300
                        }
                        ScriptAction {
                            script: SoundManager.playDropCoinSounds(weight)
                        }
                    }
                    YAnimator {
                        id: yAnimator
                        target: catcoin
                        easing.type: Easing.OutBounce
                        easing.amplitude: 0.8 - catcoin.weight
                        duration: presenter.skipAnimation ? 10 : 800
                        from: catcoin.y
                        to: root.height - catcoin.centerPosition.y - catcoin.height / 2
                            + catcoin.height * (Math.random() * dispersion * 2 - dispersion)
                    }
                }
            }
            Image {
                anchors.centerIn: parent
                width: parent.width * 1.06
                height: width
                source: "qrc:/resources/images/cats/Catcoins/Catcoin-%1.png".arg(catcoin.catcoinIndex + 1)
            }
            Rectangle {
                anchors {
                    fill: parent
                    margins: 0
                }
                radius: parent.radius
                color: "transparent"
                border {
                    color: parent.borderColor
                    width: 2 * catcoin.width / 160
                }
            }
        }
    }
    QtObject {
        id: presenter

        property int columns: 42
        property int coins: 0
        readonly property real columnWidth: root.width / columns
        property var groundLevels
        property var sizeModel: []
        property bool skipAnimation: false
        property Timer dropTimer: Timer {
            property int index: 0
            property int lastPosition: 0

            interval: presenter.skipAnimation ? 30 : 300
            onTriggered: {
                let arrLevel = presenter.sizeModel[index];
                let position = 0
                console.log(arrLevel)
                arrLevel.forEach(function (diameterColumns, i) {
                    if (diameterColumns < 0) {
                        position -= diameterColumns;
                    } else {
                        position = presenter.dropCoin(diameterColumns, position,
                                                      (interval / arrLevel.length) * (index%2 ? i : arrLevel.length - 1 - i),
                                                      index === presenter.sizeModel.length - 1 && i === arrLevel.length -1);
                    }
                })
                index++;
                if (index < presenter.sizeModel.length) {
                    restart();
                }
            }
        }

        function initialize(count) {
            presenter.coins = count;
            groundLevels = Array(columns).fill(0);
            let done = 0;
            let size = 3;
            while (done < count) {
                let arrLevel = Array(Math.min(size, count - done)).fill(Math.floor(presenter.columns / size));

                let sum = arrLevel.reduce((a, b) => a + b, 0);
                if (done < count && (presenter.columns - sum) > 0) {
                    arrLevel.splice((arrLevel.length) * Math.random(), 0, sum - presenter.columns)
                }
                sizeModel.push(arrLevel);
                done += Math.min(arrLevel.length, count - done);
                size++;
            }
        }
        function generateShape(shapeColumns) {
            var chordArray = [];
            let leftArray = [];
            let rightArray = [];

            let size = shapeColumns * columnWidth;

            var bEven = shapeColumns % 2 === 0;
            if (bEven) {
                shapeColumns += 1;
            }

            let cIndex = Math.floor(shapeColumns / 2);
            for (let i = 0; i <= cIndex; i++) {
                let chordLength = 2 * Math.sqrt(Math.pow(size / 2, 2) - Math.pow(Math.abs(i - cIndex) * columnWidth - (bEven ? columnWidth / 2 : 0), 2));
                if (i !== cIndex) {
                    leftArray.push(chordLength);
                    rightArray.unshift(chordLength);
                } else {
                    if (!bEven) {
                        leftArray.push(chordLength);
                    }
                    chordArray = leftArray.concat(rightArray);
                }
            }
            return chordArray;
        }
        function dropCoin(diameterColumns, shapePosition, delay, isLast) {
            let shape = generateShape(diameterColumns);

            // find max level:
            let maxLevel = 0;
            for (let j = 0; j < groundLevels.length; j++) {
                if (j < shapePosition || j >= shapePosition + diameterColumns) {
                    continue;
                }

                var level = groundLevels[j] + shape[j - shapePosition] / 2;
                maxLevel = Math.max(maxLevel, level);
                // max level it is y coord;
            }
            groundLevels = groundLevels.map(function (level, index) {
                if (index < shapePosition || index >= shapePosition + diameterColumns) {
                    return level;
                }
                return maxLevel + shape[index - shapePosition] / 2;
            })
            let coinTargetPos = Qt.point((shapePosition + diameterColumns / 2) * columnWidth, maxLevel)
            catcoinComponent.createObject(root, {
                                              centerPosition: coinTargetPos,
                                              targetWidth: columnWidth * diameterColumns * 1.2,
                                              delay: delay,
                                              weight: 2 * diameterColumns / presenter.columns,
                                              isLastCoin: isLast
                                          });
            return shapePosition + diameterColumns;
        }
    }
}
