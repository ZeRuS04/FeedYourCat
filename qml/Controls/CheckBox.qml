import QtQuick 2.0
import QtQuick.Controls 2.12

import Singletons 1.0
import "." as Controls

CheckBox {
    id: control

    indicator: Rectangle {
        implicitWidth: 22
        implicitHeight: 22
        x: control.leftPadding
        y: (control.height - height) / 2
        radius: width / 2
        border.color: ThemeManager.currentTheme["mainTextColor"]
        color: "#00000000"

        Rectangle {
            anchors.centerIn: parent
            width: 16
            height: 16
            radius: width / 2
            color: ThemeManager.currentTheme["mainTextColor"]
            visible: control.checked
        }
    }

    contentItem: Controls.Label {
        anchors.verticalCenter: parent.verticalCenter
        text: control.text
        opacity: enabled ? 1.0 : 0.3
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
