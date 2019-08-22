import QtQuick 2.0
import QtQuick.Controls 2.12

import "pages" as Pages

StackView {
    id: root

    initialItem: menuComponent

    Component {
        id: menuComponent

        Pages.MainMenu {

        }
    }

}
