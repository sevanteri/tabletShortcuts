import QtQuick 2.0

Rectangle {
    id: buttonRect
    color: root.buttonColor

    // anchors.fill: parent

    property alias text: titleText.text

    signal clicked

    Label {
        id: titleText
        text: title
    }
    MouseArea {
        anchors.fill: parent
        onClicked: buttonRect.clicked()
    }
}