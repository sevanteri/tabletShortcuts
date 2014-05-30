import QtQuick 2.0

GridView {
    interactive: false

    width: parent.width
    height: cellHeight * Math.ceil(model.count*cellWidth/width)

    cellWidth: root.buttonWidth + 5
    cellHeight: cellWidth

    model: buttons
    delegate: Loader {
            width: root.buttonWidth
            source: (type === "toggle") ? "ToggleButton.qml" :
                    "NormalButton.qml"
        }
}
