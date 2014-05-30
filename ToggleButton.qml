import QtQuick 2.0

Button {
    property bool toggled: false
    color: toggled ? root.buttonColorToggled : root.buttonColor

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