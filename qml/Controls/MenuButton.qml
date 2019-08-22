import QtQuick 2.0
import QtQuick.Controls 2.12

import Singletons 1.0

Button {
    id: root

    font.pointSize: 24

    background: Rectangle {
        color: root.pressed ? ThemeManager.currentTheme["menuButtonPressedBackgroundColor"]
                            : ThemeManager.currentTheme["menuButtonBackgroundColor"]
        border.color: ThemeManager.currentTheme["menuButtonBorderColor"]
        opacity: ThemeManager.currentTheme["menuButtonBackgroundOpacity"]
    }
}
