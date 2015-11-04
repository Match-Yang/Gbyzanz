TEMPLATE = app

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

target.path=$$BINDIR
INSTALLS += target

HEADERS += \
    controller.h
