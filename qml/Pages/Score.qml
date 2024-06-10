import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import "../controls" as Controls
import Singletons 1.0

Controls.BasePage {
    id: root

    readonly property bool isRecord: Logic.topFedCat < fedCat
    property int score: !!Logic.session ? Logic.session.score : 0
    property int fedCat: !!Logic.session ? Logic.session.fedCat : 0

    signal continueSig()
    signal restart()
    signal settings()
    signal nextStep()

    foodCount: fedCat === 0 ? 24 : 0
    pageName: "score"
    Component.onCompleted: nextStep()
    onNextStep: {
        switch (scoreStateGroup.state) {
            case "initial":
                if (fedCat === 0) {
                    scoreStateGroup.state = "hungryCats";
                } else if (root.isRecord) {
                    scoreStateGroup.state = "record";
                } else {
                    scoreStateGroup.state = "coins";
                }
                break;
            case "record":
                scoreStateGroup.state = "coins"
                break;
            case "coins":
                scoreStateGroup.state = "labels"
                break;
            default:
                break;
        }
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            id: scoreItem

            Layout.fillWidth: true
            Layout.fillHeight: true

            Loader {
                id: hungryLoader

                anchors.fill: parent
                active: false
                sourceComponent: Item {
                    Component.onCompleted: SoundManager.hungryPlay()
                    Column {
                        anchors.centerIn: parent
                        width: scoreItem.width
                        spacing: 50

                        Controls.Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 30
                            bold: true
                            text: qsTr("GAME OVER!")
                        }
                        Controls.Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 280

                            font.pointSize: 24
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            color: ThemeManager.currentTheme["secondaryTextColor"]
                            text: qsTr("Hungry cats stole\nthe sauseges!")
                        }
                        Image {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 200
                            height: 200
                            sourceSize.width: width
                            sourceSize.height: height
                            source: ThemeManager.currentTheme["pauseImage"]
                        }
                    }
                }
            }
            Loader {
                id: recordLoader

                anchors.fill: parent
                active: false
                sourceComponent: Controls.RecordPawAnimation {
                    onFinished: root.nextStep()
                }
            }
            Loader {
                id: coinsLoader

                anchors.fill: parent
                active: false
                sourceComponent: Controls.DropCatCoins {
                    onFinished: root.nextStep()
                    Component.onCompleted: start(root.fedCat)
                }
            }
            Loader {
                id: labelsLoader

                anchors.fill: parent
                active: false
                sourceComponent: Item {
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            scoreColumn.speedCoef = 0.01;
                            scoreColumn.completeAnimation();
                        }
                    }
                    Column {
                        id: scoreColumn

                        property real speedCoef: 1
                        signal completeAnimation()

                        anchors.centerIn: parent
                        width: scoreItem.width

                        spacing: 50

                        Repeater {
                            property var targetModel: [{
                                text: qsTr("<b>GAME OVER!</b>"),
                                color: ThemeManager.currentTheme["orangeColor"],
                                size: Qt.size(328, 68),
                                rotation: 5,
                                timeout: 400
                            },{
                                text: qsTr("<b><font size='5'>%1</font><br>GAMING!</b>").arg(Qt.formatTime(new Date(Logic.session.totalSessionTime), "m%2 ss%1").arg('"').arg("'")),
                                color: ThemeManager.currentTheme["greenColor"],
                                size: Qt.size(260, 120),
                                rotation: -10,
                                timeout: 1000
                            },{
                                text: qsTr("<b>YOU FED<br><font size='5'>%1</font> CATS!</b>").arg(root.fedCat || "0"),
                                color: ThemeManager.currentTheme["yellowColor"],
                                size: Qt.size(320, 120),
                                rotation: 13,
                                timeout: 1500
                            }]

                            model:  {
                                if (!root.isRecord) {
                                    targetModel.push({
                                                         text: qsTr("<b>RECORD: %1</b>").arg(Logic.topFedCat || "0"),
                                                         color: ThemeManager.currentTheme["redColor"],
                                                         size: Qt.size(260, 68),
                                                         rotation: 0,
                                                         timeout: 2000
                                                     });
                                }

                                return targetModel
                            }
                            delegate: Item {
                                id: scoreLabelItem

                                property color mainColor: modelData.color
                                property int timeout: modelData.timeout

                                anchors.horizontalCenter: parent.horizontalCenter
                                implicitWidth: scoreLabelRect.implicitWidth
                                implicitHeight: scoreLabelRect.implicitHeight

                                Connections {
                                    target: scoreColumn
                                    function onCompleteAnimation() { startAnimation.complete(); }
                                }
                                Rectangle {
                                    id: scoreLabelRect

                                    implicitWidth: Math.max(scoreLabel.implicitWidth, modelData.size.width)
                                    implicitHeight: Math.max(scoreLabel.implicitHeight, modelData.size.height)
                                    rotation: modelData.rotation
                                    radius: Number.MAX_VALUE
                                    opacity: 0.90
                                    visible: false
                                    border {
                                        color: mainColor
                                        width: 3
                                    }
                                    layer {
                                        enabled: true
                                        effect: MultiEffect {
                                            shadowEnabled: true
                                            shadowScale: 1
                                            shadowColor: "black"
                                        }
                                    }
                                    gradient: Gradient {
                                        GradientStop { position: 0.2; color: "#ffffff" }
                                        GradientStop { position: 1.0; color: scoreLabelItem.mainColor }
                                    }
                                    Component.onCompleted: startAnimation.start()

                                    SequentialAnimation {
                                        id: startAnimation

                                        PauseAnimation {
                                            duration: scoreLabelItem.timeout * scoreColumn.speedCoef
                                        }
                                        PropertyAnimation {
                                            target: scoreLabelRect
                                            property: "visible"
                                            to: true
                                        }
                                        ParallelAnimation {
                                            SequentialAnimation {
                                                PauseAnimation {
                                                    duration: 100 * scoreColumn.speedCoef
                                                }
                                                ScriptAction {
                                                    script:{
                                                        SoundManager.fallPlay(index)
                                                    }
                                                }
                                            }
                                            PropertyAnimation {
                                                target: scoreLabelRect
                                                property: "y"
                                                duration: 400 * scoreColumn.speedCoef
                                                easing {
                                                    amplitude: 0.3
                                                    type: Easing.InOutBack
                                                }
                                                from: -root.height
                                                to: 0
                                                onFinished: target.y = to
                                            }
                                        }
                                    }
                                    Controls.Label {
                                        id: scoreLabel

                                        anchors.centerIn: parent
                                        font.pointSize: 26
                                        textFormat: Text.AutoText
                                        text: modelData.text
                                        lineHeight: 0.8
                                        bold: true
                                        horizontalAlignment: Text.AlignHCenter
                                        color: ThemeManager.currentTheme["thirdTextColor"]
                                        layer {
                                            enabled: true
                                            effect: MultiEffect {
                                                shadowEnabled: true
                                                shadowScale: 1
                                                shadowColor: "black"
                                                shadowVerticalOffset: 4
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: buttonsColumn.height

            Column {
                id: buttonsColumn

                anchors.centerIn: parent
                bottomPadding: 60
                spacing: 20

                Controls.MenuButton {
                    width: 280
                    height: 60

                    primaryStyle: true
                    text: qsTr("FEED MY CATS!")
                    font.bold: true
                    onClicked: root.restart()
                }
                Controls.MenuButton {
                    width: 280
                    height: 60
                    icon.source: "qrc:/resources/icons/settings.svg"
                    text: qsTr("SETTINGS")
                    onClicked: root.settings()
                }
            }
        }
    }
    StateGroup {
        id: scoreStateGroup

        state: "initial"
        states: [
            State {
                name: "initial"

                PropertyChanges {
                    target: hungryLoader
                    active: false
                }
                PropertyChanges {
                    target: recordLoader
                    active: false
                }
                PropertyChanges {
                    target: coinsLoader
                    active: false
                }
                PropertyChanges {
                    target: labelsLoader
                    active: false
                }
            },
            State {
                name: "hungryCats"
                extend: "initial"

                PropertyChanges {
                    target: hungryLoader
                    active: true
                }
            },
            State {
                name: "record"
                extend: "initial"

                PropertyChanges {
                    target: recordLoader
                    active: true
                }
            },
            State {
                name: "coins"

                PropertyChanges {
                    target: hungryLoader
                    active: false
                }
                PropertyChanges {
                    target: recordLoader
                    active: Logic.topFedCat < fedCat
                }
                PropertyChanges {
                    target: coinsLoader
                    active: true
                }
                PropertyChanges {
                    target: labelsLoader
                    active: false
                }
            },
            State {
                name: "labels"

                PropertyChanges {
                    target: hungryLoader
                    active: false
                }
                PropertyChanges {
                    target: recordLoader
                    active: Logic.topFedCat < fedCat
                }
                PropertyChanges {
                    target: coinsLoader
                    active: true
                }
                PropertyChanges {
                    target: labelsLoader
                    active: true
                }
            }
        ]
    }
}
