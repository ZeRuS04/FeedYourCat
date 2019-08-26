import QtQuick 2.0
import QtQuick.Controls 2.12

import Singletons 1.0

Label {
    id: root

    font.pointSize: 20
    color: ThemeManager.currentTheme["mainTextColor"]
}
