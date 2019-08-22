import QtQuick 2.0
import QtQuick.Controls 2.12
import Singletons 1.0

Label {
    id: root

    color: ThemeManager.currentTheme["mainTextColor"]
    font.pointSize: 40
    horizontalAlignment: Text.AlignHCenter

}
