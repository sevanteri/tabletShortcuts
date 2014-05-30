import QtQuick 2.0

Rectangle {
    id: buttonRect
    color: root.buttonColor

    width: root.buttonWidth
    height: width

    // anchors.fill: parent

    Text {
        anchors.centerIn: parent
        text: title
        color: "white"
        wrapMode: Text.WordWrap
        font.pointSize: 12
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {

            var hide = typeof(doNotHide) !== 'undefined' ? !doNotHide : true;
            // console.debug(hide);
            
            if (action === 'quit') {
                Qt.quit();
            }
            else if (action === 'hide') {
                root.hideView();
            } else {
                if (hide)
                    root.hideView();
                console.debug("Running cmd '" + action + "'");
                // run action
                root.runCommand(action);
            }
        }
    }
}