import QtQuick 2.0

GridView {
    interactive: false

    width: 80
    height: contentHeight

    cellWidth: width/2
    cellHeight: cellWidth

    model: buttons
    delegate: Loader {
            width: parent.width/2 - parent.width*0.025
            source: (type === "toggle") ? "ToggleButton.qml" :
                    "NormalButton.qml"
        }
}
