#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys

from PyQt5.QtCore import QUrl

from PyQt5.QtDBus import QDBusConnection

from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQuick import QQuickView

from subprocess import Popen, PIPE
import re
import shlex

from utils import MyDBUSServer


class TabletShortcuts(QGuiApplication):
    def __init__(self, argv):
        QGuiApplication.__init__(self, argv)

        self.view = QQuickView()

        self.bus = QDBusConnection.sessionBus()
        self.server = MyDBUSServer(self)
        self.bus.registerObject("/app", self.server)
        self.bus.registerService("sevanteri.TabletShortcuts")

        self.view.setTitle("TabletShortcuts")
        self.view.setResizeMode(QQuickView.SizeRootObjectToView)
        self.view.setSource(QUrl('main.qml'))

        self.root = self.view.rootObject()
        self.showView()

        self.root.runCommand.connect(self.run)
        self.root.hideView.connect(self.view.hide)

        self.view.engine().quit.connect(self.quit)

    def run(self, cmd):
        return Popen(shlex.split(cmd))

    def quit(self):
        self.exit()

    def showView(self):
        if self.view.isVisible():
            self.view.hide()
        else:
            width, height = TabletShortcuts.getScreenGeometry()

            self.view.setGeometry(1, 1, width, height)
            self.view.show()

    def getScreenGeometry():
        output = Popen("xrandr | grep 'current'", shell=True, stdout=PIPE)\
            .communicate()[0].decode('UTF-8')

        m = re.search('current.([0-9]+).x.([0-9]+)', output)
        width = int(m.group(1))
        height = int(m.group(2))

        return (width, height)


def main():
    # root.setAttribute(Qt.WA_ShowWithoutActivating)
    app = TabletShortcuts(sys.argv)

    sys.exit(app.exec_())

if __name__ == '__main__':
    main()
