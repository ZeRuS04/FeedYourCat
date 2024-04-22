import QtQuick
import QtQuick.Controls
import Singletons 1.0

BaseToolButton {
    id: control

    checkable: true
    iconSource: checked ? "qrc:/resources/icons/play.svg"
                        : "qrc:/resources/icons/pause.svg"
    onClicked: {
        SoundManager.buttonClickPlay();
    }
}
