import QtQuick 2.0

Rectangle {
    id: buttonRect
    color: root.buttonColor

    // anchors.fill: parent

    property alias text: titleText.text

    signal clicked

    Text {
        id: titleText
        // anchors.centerIn: parent
        anchors.margins: 10
        anchors.fill: parent
        text: title
        color: "white"
        wrapMode: Text.WordWrap
        font.pointSize: root.fontSize
    }
    MouseArea {
        anchors.fill: parent
        onClicked: buttonRect.clicked()
    }
}