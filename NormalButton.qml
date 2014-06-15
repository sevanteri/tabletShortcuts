import QtQuick 2.0

Button {
    onClicked: {
        var hide = typeof(hideAfter) !== 'undefined' ? hideAfter : false;
        // console.debug(hide);

        if (hide)
            root.hideView();

        console.debug("Running cmd '" + action + "'");
        // run action
        root.runCommand(action);
    }
}