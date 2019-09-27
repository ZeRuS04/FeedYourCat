import QtQuick 2.12
import QtQuick.Controls 2.5 as QQC2
import Singletons 1.0

QQC2.Button {
    id: root

    background: Rectangle {
        anchors.fill: parent
        color: ThemeManager.currentTheme["themeSwitcherCheckedColor"]
        opacity: ThemeManager.currentTheme["themeSwitcherOpacity"]
        visible: root.checked
    }

    contentItem: Item {
        Label {
            anchors {
                left: parent.left
                leftMargin: 30
                verticalCenter: parent.verticalCenter
            }
            text: root.text
        }
        Image {
            anchors {
                right: parent.right
                rightMargin: 30
                verticalCenter: parent.verticalCenter
            }

            height: parent.height
            width: height
            sourceSize.width: width
            sourceSize.height: height
            visible: root.checked
            source: "qrc:/resources/icons/While_loading.svg"
        }
    }
}
