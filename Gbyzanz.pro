TEMPLATE = app

TARGET = gbyzanz

QT += qml quick widgets

SOURCES += main.cpp \
    controller.cpp

RESOURCES += qml.qrc

QMAKE_CXXFLAGS += -std=c++11

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

isEmpty(PREFIX) {
    PREFIX=/usr
}

BINDIR = $$PREFIX/bin

desktop.path = $${PREFIX}/share/applications/
desktop.files = gbyzanz.desktop

icon.path = $${PREFIX}/share/icons/hicolor/scalable/apps/
icon.files = gbyzanz.svg

target.path=$$BINDIR
INSTALLS += target desktop icon

HEADERS += \
    controller.h
