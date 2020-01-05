import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Singletons 1.0

import "../controls" as Controls

Controls.BasePage {
    id: root

    property string title: qsTr("SETTINGS")

    pageName: "settings"
/*
    Column {
        padding: 30

        width: parent.width
        spacing: 15

        RowLayout {
            height: 30

            Controls.Label {
                font.pointSize: 12
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: "start time (sec)"
            }

            TextField {
                id: timeField
                width: 120
                height: parent.height
                validator: IntValidator{bottom: 1; top: 1000;}
                text: Logic.time
            }
        }

        RowLayout {
            height: 30

            Controls.Label {
                font.pointSize: 12
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: "start cats count"
            }

            TextField {
                id: startCatField
                width: 120
                height: parent.height
                validator: IntValidator{bottom: 1; top: 1000;}
                text: Logic.startCats
            }
        }

        RowLayout {
            height: 30

            Controls.Label {
                font.pointSize: 12
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: "new Cat Interval (sec)"
            }

            TextField {
                id: newCatIntervalField
                width: 120
                height: parent.height
                validator: IntValidator{bottom: 1; top: 1000;}
                text: Logic.newCatInterval
            }
        }


        RowLayout {
            height: 30

            Controls.Label {
                font.pointSize: 12
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: "reward For Feed Cat (sec)"
            }

            TextField {
                id: rewardForFeedCatField
                width: 120
                height: parent.height
                validator: IntValidator{bottom: -1000; top: 1000;}
                text: Logic.rewardForFeedCat
            }
        }

        RowLayout {
            height: 30

            Controls.Label {
                font.pointSize: 12
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: "reward For skip Cat (sec)"
            }

            TextField {
                id: rewardForskipCatField
                width: 120
                height: parent.height
                validator: IntValidator{bottom: -1000; top: 1000;}
                text: Logic.rewardForSkipCat
            }
        }

        RowLayout {
            height: 30

            Controls.Label {
                font.pointSize: 12
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: "reward For feed tiger (sec)"
            }

            TextField {
                id: rewardForFeedTigerField
                width: 120
                height: parent.height
                validator: IntValidator{bottom: -1000; top: 1000;}
                text: Logic.rewardForTiger
            }
        }
        RowLayout {
            height: 30

            Controls.Label {
                font.pointSize: 12
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: "new stages intervals (sec,sec,...,sec)"
            }

            TextField {
                id: stagesIntervalField
                width: 120
                height: parent.height
                text: Logic.stagesInterval.join(",")
            }
        }
        RowLayout {
            height: 30

            Controls.Label {
                font.pointSize: 12
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: "cat count on stage (count,count,...,count)"
            }

            TextField {
                id: newStageCatCountField
                width: 120
                height: parent.height
                text: Logic.newStageCatCount.join(",")
            }
        }
        RowLayout {
            height: 30

            Controls.Label {
                font.pointSize: 12
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: "tiger chance on stage (%,%,...,%)"
            }

            TextField {
                id: newTigerChanceField
                width: 120
                height: parent.height
                text: Logic.newStageTigerChance.join(",")
            }
        }

        RowLayout {
            height: 30

            Controls.Label {
                font.pointSize: 12
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: "cat delay (msec-msec)"
            }

            TextField {
                id: catDelayField
                width: 120
                height: parent.height
                text: Logic.minimumCatDelay + "-" + Logic.maximumCatDelay
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter

            width: 200
            height: 30

            text: "SUBMIT"

            onClicked: {
                Logic.time = timeField.text;
                Logic.startCats = startCatField.text;
                Logic.newCatInterval = newCatIntervalField.text;
                Logic.rewardForFeedCat = rewardForFeedCatField.text;
                Logic.rewardForSkipCat = rewardForskipCatField.text;
                Logic.rewardForTiger = rewardForFeedTigerField.text;
                Logic.stagesInterval = stagesIntervalField.text.split(",");
                Logic.newStageCatCount = newStageCatCountField.text.split(",");
                Logic.newStageTigerChance = newTigerChanceField.text.split(",");
                Logic.minimumCatDelay = catDelayField.text.split("-")[0];
                Logic.maximumCatDelay = catDelayField.text.split("-")[1] || catDelayField.text.split("-")[0];
            }
        }
    }
*/

    Column {
        id: mainColumn

        anchors {
            top: parent.top
            topMargin: 30
        }
        width: parent.width

        Column {
            id: languageColumn

            width: parent.width

            Controls.Label {
                anchors {
                    right: parent.right
                    rightMargin: 30
                }

                text: qsTr("Language")
                color: ThemeManager.currentTheme["toolbarTextColor"]
            }

            Controls.CheckThemeButton {
                id: russianBtn

                height: 80
                width: parent.width
                text: "Русский"
                description: "Мяу"
                autoExclusive: true
                checked: Logic.lang === "ru"

                onClicked: Logic.lang = "ru"
            }

            Controls.CheckThemeButton {
                id: englishBtn

                height: 80
                width: parent.width
                text: "English"
                description: "Meow"
                autoExclusive: true
                checked: Logic.lang === "en"

                onClicked: Logic.lang = "en"
            }
        }

        Column {
            id: volumeColumn

            width: parent.width

            Controls.Label {
                anchors {
                    right: parent.right
                    rightMargin: 30
                }

                text: qsTr("Volume")
                color: ThemeManager.currentTheme["toolbarTextColor"]
            }

            Controls.VolumeSlider {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: 30
                }
                value: Logic.soundVolume
                onMoved: {
                    SoundManager.updateVolume(position);
                    SoundManager.feedCatPlay();
                    Logic.soundVolume = position;
                }
            }

            Controls.CheckBox {
                anchors {
                    left: parent.left
                    margins: 30
                }

                height: 30
                text: qsTr("Vibration")
                checked: Logic.vibrationEnabled
                onCheckedChanged: {
                    Logic.vibrationEnabled = checked;
                    Vibrator.setEnabled(checked);
                    if (checked) {
                        Vibrator.vibrate(120);
                    }
                }
            }
        }

        Column {
            id: themeColumn

            width: parent.width

            Controls.Label {
                anchors {
                    right: parent.right
                    rightMargin: 30
                }

                text: qsTr("Theme")
                color: ThemeManager.currentTheme["toolbarTextColor"]
            }

            Controls.CheckThemeButton {
                id: lightThemeBtn

                height: 50
                width: parent.width
                text: qsTr("Light")
                autoExclusive: true
                checked: ThemeManager.currentThemeIndex === 0

                onClicked: ThemeManager.currentThemeIndex = 0
            }

            Controls.CheckThemeButton {
                id: darkThemeBtn

                height: 50
                width: parent.width
                text: qsTr("Dark")
                autoExclusive: true
                checked: ThemeManager.currentThemeIndex === 1

                onClicked: ThemeManager.currentThemeIndex = 1
            }
        }
    }

    Rectangle {
        id: footer

        anchors.bottom: parent.bottom
        height: 70
        width: parent.width

        color: ThemeManager.currentTheme["themeSwitcherCheckedColor"]
        opacity: ThemeManager.currentTheme["themeSwitcherOpacity"]

    }

    Column {
        anchors.verticalCenter: footer.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 3

            Controls.Label {
                anchors.verticalCenter: parent.verticalCenter
                text:  qsTr("designed by ")
                font.pointSize: 12
            }

            Controls.Label {
                anchors.verticalCenter: parent.verticalCenter
                text: "Lii.Design"

                font.pointSize: 13
                color: "#FF8C00"

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -5

                    onClicked: Qt.openUrlExternally("https://www.behance.net/liisign")
                }
            }

            Controls.Label {
                anchors.verticalCenter: parent.verticalCenter
                text:  qsTr("and")
                font.pointSize: 12
            }

            Controls.Label {
                anchors.verticalCenter: parent.verticalCenter
                text: "Eugene.Sinel"

                font.pointSize: 13
                color: "#47BFD9"

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -5

                    onClicked: Qt.openUrlExternally("mailto:zerus04@gmail.com")
                }
            }
        }

        Controls.Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("music freesfx.co.uk")
            font.pointSize: 12
        }
    }
}
