import QtQuick 2.12
import QtQuick.Controls 2.5 as QQC2
import Singletons 1.0

QQC2.Button {
    id: root

    property string description: ''

    background: Rectangle {
        anchors.fill: parent
        color: ThemeManager.currentTheme["themeSwitcherCheckedColor"]
        opacity: ThemeManager.currentTheme["themeSwitcherOpacity"]
        visible: root.checked
    }

    contentItem: Item {
        Column {
            anchors {
                left: parent.left
                leftMargin: 30
                verticalCenter: parent.verticalCenter
            }
            Label {
                id: mainLabel

                text: root.text
                font.pointSize: 26
            }
            Label {
                visible: text.length > 0
                text: root.description
                opacity: 0.5
            }
        }

        Image {
            anchors {
                right: parent.right
                rightMargin: 30
                verticalCenter: parent.verticalCenter
            }

            height: mainLabel.height / 1.5
            width: height
            sourceSize.width: width
            sourceSize.height: height
            visible: root.checked
            source: "qrc:/resources/icons/%1/paw.svg".arg(ThemeManager.currentTheme.catalogName)
        }
    }
}
