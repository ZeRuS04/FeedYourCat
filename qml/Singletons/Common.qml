pragma Singleton

import QtQuick
import Singletons 1.0

Item {
    property string titleFont: snapFont.name

    function getDefaultFont() {
        return mulishRegularFont.name
    }

    FontLoader {
        id: snapFont
        source: "qrc:/resources/fonts/snap itc.ttf"
    }
    FontLoader {
        id: mulishBlackFont
        source: "qrc:/resources/fonts/Mulish-Black.ttf"
    }
    FontLoader {
        id: mulishRegularFont
        source: "qrc:/resources/fonts/Mulish-Regular.ttf"
    }
}
