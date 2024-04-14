import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Singletons 1.0

ToolButton {
    id: root

    property string iconSource: ""
    property QtObject round

    checkable: true

    contentItem: IconImage {
        width: height
        sourceSize.width: 64
        sourceSize.height: 64
        source: root.iconSource
        mipmap: true
        color: !root.pressed ? ThemeManager.currentTheme["toolbuttonIconColor"]
                             : Qt.lighter(ThemeManager.currentTheme["toolbuttonIconColor"],
                                          ThemeManager.currentThemeIndex ? 1.5 : 0.5)
    }
    background: null
}
