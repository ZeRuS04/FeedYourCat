import QtQuick
import QtQuick.Controls
import Singletons 1.0

Label {
    id: root

    color: ThemeManager.currentTheme["mainTextColor"]
    font.family: Common.titleFont
    font.pointSize: 40
    horizontalAlignment: Text.AlignHCenter
}
