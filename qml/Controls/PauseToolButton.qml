import QtQuick 2.0
import QtQuick.Controls 2.12

ToolButton {
    checkable: true
    background: null

    contentItem: Image {
        width: 28
        height: 35
        source: checked ? "qrc:/resources/icons/Continue.svg"
                        : "qrc:/resources/icons/Pause.svg"
    }
}
