import QtQuick 2.0
import QtQuick.Controls 2.12

import Singletons 1.0

Slider {
    id: control

    property bool bold: false

    font.family: Common.getDefaultFont(bold)
    font.pointSize: 20

    background: Row {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2

        spacing: 5

        Image {
            anchors.verticalCenter: parent.verticalCenter
            width: 28
            height: 21

            sourceSize.width: width
            sourceSize.height: height
            source: "qrc:/resources/icons/%1/volume_min.svg".arg(ThemeManager.currentTheme.catalogName)
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: 200
            implicitHeight: 2
            width: control.availableWidth - 33 - 35
            height: implicitHeight
            radius: 2
            color: ThemeManager.currentTheme["mainTextColor"]
        }

        Image {
            anchors.verticalCenter: parent.verticalCenter
            width: 30
            height: 21

            sourceSize.width: width
            sourceSize.height: height
            source: "qrc:/resources/icons/%1/volume_max.svg".arg(ThemeManager.currentTheme.catalogName)
        }
    }

    handle: Image {
        x: control.leftPadding + 33 + control.visualPosition * (control.availableWidth - width - 35 - 33)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        width: 36
        height: 38

        sourceSize.width: width
        sourceSize.height: height
        source: "qrc:/resources/icons/%1/paw.svg".arg(ThemeManager.currentTheme.catalogName)
    }
}
