import QtQuick 2.0
import QtQuick.Controls 2.12
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
