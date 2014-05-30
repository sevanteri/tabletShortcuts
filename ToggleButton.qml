import QtQuick 2.0

Rectangle {
    id: buttonRect
    property bool toggled: false
    color: toggled ? root.buttonColorToggled : root.buttonColor

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
            // console.log(hide);

            if (hide)
                root.hideView();

            var action = toggled ? toggleOn : toggleOff;
            toggled = !toggled;
            
            console.log("Running cmd '" + action + "'");
            root.runCommand(action);
            
        }
    }
}