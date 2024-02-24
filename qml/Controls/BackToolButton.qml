import QtQuick 2.0
import QtQuick.Controls 2.12
import Singletons 1.0

BaseToolButton {
    id: control

    iconSource: "qrc:/resources/icons/arrow.svg"
    onClicked: {
        SoundManager.buttonClickPlay();
    }
}
