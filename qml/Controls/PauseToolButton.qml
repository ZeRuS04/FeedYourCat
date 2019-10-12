import QtQuick 2.0
import QtQuick.Controls 2.12
import Singletons 1.0

BaseToolButton {
    id: root

    checkable: true

    contentItem: Image {
        sourceSize.width: width
        sourceSize.height: height
        source: (checked ? "qrc:/resources/icons/%1/play.svg"
                         : "qrc:/resources/icons/%1/pause.svg").arg(ThemeManager.currentTheme.catalogName)
    }
}
