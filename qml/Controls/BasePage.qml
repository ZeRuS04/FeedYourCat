import QtQuick 2.0

import Singletons 1.0

Rectangle {
    property string pageName: "unknown"

    gradient: Gradient {
        GradientStop { position: 0.0; color: ThemeManager.currentTheme["backgroundGradColor1"] }
        GradientStop { position: 1.0; color: ThemeManager.currentTheme["backgroundGradColor2"] }
    }
}
