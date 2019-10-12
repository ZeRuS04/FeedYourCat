import QtQuick 2.0
import QtQuick.Controls 2.12
import Singletons 1.0

BaseToolButton {
    contentItem: Image {
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.Pad
        source: "qrc:/resources/icons/%1/back.svg".arg(ThemeManager.currentTheme.catalogName)
    }
}
