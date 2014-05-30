import QtQuick 2.0

Rectangle {
    id: root

    signal runCommand(string cmd);
    signal hideView();
    signal quitClicked()

    property int padding: 20
    property int buttonWidth: Math.ceil((width - padding*2)/(60*8))*60
    property string buttonColor: "#000000"
    property string buttonColorToggled: "#552222"

    width: 800
    height: 600

    color: "#555555"

    Buttons {id: buttonModel}

    GridView {
        id: listView
        model: buttonModel
        // anchors.fill: parent
        height: parent.height - padding*2
        width: Math.floor((parent.width - padding*2) / cellWidth) * cellWidth

        anchors.centerIn: parent
        // orientation: Qt.Horizontal
        
        cellWidth: root.buttonWidth + 10
        cellHeight: cellWidth

        delegate: Loader {
            width: root.buttonWidth
            source: (type === "toggle") ? "ToggleButton.qml" :
                    (type === "slider") ? "Slider.qml" :
                    "NormalButton.qml"
        }
    }
}