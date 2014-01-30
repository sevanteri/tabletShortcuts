#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys

from PyQt5.QtCore import pyqtProperty, QObject, QUrl, pyqtSlot, Q_CLASSINFO
from PyQt5.QtCore import Qt
from PyQt5.QtQml import qmlRegisterType, QQmlComponent, QQmlEngine

from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQuick import QQuickView

from PyQt5.QtDBus import QDBus, QDBusConnection, QDBusInterface
from PyQt5.QtDBus import QDBusAbstractAdaptor, QDBusMessage

from subprocess import Popen, PIPE
import re, shlex

from pymouse import PyMouseEvent
import threading


class EdgeClickHandler(PyMouseEvent):
    def __init__(self, app):
        PyMouseEvent.__init__(self)
        self.app = app

    def click(self, x, y, button, press):
        if x == 0 and (1 < y < 767) \
            and button == 1 and press:
            self.showView()
        elif y == 767 and (1 < x < 1365) \
            and button == 1 and press:
            self.showKeyboard()

    def showView(self):
        self.app.showView()

    def showKeyboard(self):
        self.app.run("/usr/bin/onboard")


class EdgeClickThread(threading.Thread):
    def __init__(self, app):
        threading.Thread.__init__(self)
        self.handler = EdgeClickHandler(app)

    def run(self):
        self.handler.run()

    def end(self):
        self.handler.stop()
        #self.stop()


class ServerAdaptor(QDBusAbstractAdaptor):
    """ This provides the DBus adaptor to the outside world"""

    Q_CLASSINFO("D-Bus Interface", "sevanteri.TabletShortcuts")
    Q_CLASSINFO("D-Bus Introspection",
    '  <interface name="sevanteri.TabletShortcuts">\n'
    '    <method name="hideshow" />\n'
    '  </interface>\n')

    def __init__(self, parent, app):
        super().__init__(parent)
        self.app = app

    @pyqtSlot()
    def hideshow(self):
        self.app.showView()


class MyServer(QObject):

    def __init__(self, app):
        QObject.__init__(self)
        self.__dbusAdaptor = ServerAdaptor(self, app)
        self.app = app


class TabletShortcuts(QGuiApplication):
    def __init__(self, argv):
        QGuiApplication.__init__(self, argv)

        self.view = QQuickView()

        self.bus = QDBusConnection.sessionBus()
        self.server = MyServer(self)
        self.bus.registerObject("/app", self.server)
        self.bus.registerService("sevanteri.TabletShortcuts")

        self.th = EdgeClickThread(self)
        self.th.start();

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
        try:
            self.th.handler.stop()
            self.th.handler.stop()
        except: pass

        self.th.join()
        self.exit()
        # self.th.end()

    def showView(self):
        if self.view.isVisible():
            self.view.hide()
        else:
            output = Popen("xrandr | grep 'current'", shell=True, stdout=PIPE)\
                        .communicate()[0].decode('UTF-8')

            m = re.search('current.([0-9]+).x.([0-9]+)', output)
            SWIDTH = int(m.group(1))
            SHEIGHT = int(m.group(2))

            X = Y = 1

            self.view.setGeometry(X, Y, 80, SHEIGHT)
            self.view.show()

def main():
    # root.setAttribute(Qt.WA_ShowWithoutActivating)
    app = TabletShortcuts(sys.argv)

    sys.exit(app.exec_())

if __name__ == '__main__':
    main()