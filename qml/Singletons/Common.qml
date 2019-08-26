pragma Singleton

import QtQuick 2.0

Item {

    property string titleFont: fooFont.name

    FontLoader {
        id: fooFont;
        source: "qrc:/resources/fonts/foo.otf"
    }
}
