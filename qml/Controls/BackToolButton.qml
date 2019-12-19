import QtQuick 2.0
import QtQuick.Controls 2.12
import Singletons 1.0

BaseToolButton {
    id: control

    contentItem: Image {
        sourceSize.width: width
        sourceSize.height: height
        source: (control.pressed ? "qrc:/resources/icons/%1/arrowAction.svg"
                                 : "qrc:/resources/icons/%1/arrow.svg").arg(ThemeManager.currentTheme.catalogName)
    }
}
