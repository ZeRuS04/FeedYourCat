import QtQuick
import QtQuick.Controls
import Singletons 1.0

BaseToolButton {
    id: control

    iconSource: "qrc:/resources/icons/arrow.svg"
    onClicked: {
        SoundManager.buttonClickPlay();
    }
}
