import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import Singletons 1.0

ToolButton {
    id: root

    property string iconSource: ""
    property QtObject round

    checkable: true

    contentItem: Image {
        width: height
        sourceSize.width: 64
        sourceSize.height: 64
        source: root.iconSource
        mipmap: true
        layer {
            enabled: true
            effect: ColorOverlay {
                color: !root.pressed ? ThemeManager.currentTheme["toolbuttonIconColor"]
                                     : Qt.lighter(ThemeManager.currentTheme["toolbuttonIconColor"],
                                                  ThemeManager.currentThemeIndex ? 1.5 : 0.5)
            }
        }
    }
    background: null
}
