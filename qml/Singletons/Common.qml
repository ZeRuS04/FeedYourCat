pragma Singleton

import QtQuick 2.12
import Singletons 1.0

Item {
    property string titleFont: snapFont.name

    function getDefaultFont(isBold) {
        return isBold ? notoSansBoldFont.name
                      : notoSansRegFont.name
    }

    FontLoader {
        id: fooFont
        source: "qrc:/resources/fonts/foo.otf"
    }
    FontLoader {
        id: snapFont
        source: "qrc:/resources/fonts/snap itc.ttf"
    }
    FontLoader {
        id: notoSansRegFont
        source: "qrc:/resources/fonts/NotoSans-Regular.ttf"
    }
    FontLoader {
        id: notoSansBoldFont
        source: "qrc:/resources/fonts/NotoSans-Bold.ttf"
    }
}
