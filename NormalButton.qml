import QtQuick 2.0

Rectangle {
    id: buttonRect
    property bool toggled: false
    color: toggled ? "#552222" : "#000000"

    width: 80
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
            // console.log(hide);
            
            if (action === 'quit') {
                Qt.quit();
            }
            else if (action === 'hide') {
                root.hideView();
            } else {
                if (hide)
                    root.hideView();
                console.log("Running cmd '" + action + "'");
                // run action
                root.runCommand(action);
            }
        }
    }
}