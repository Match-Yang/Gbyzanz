#include <QtQml>
#include <QApplication>
#include <QQmlApplicationEngine>

#include "controller.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // install translators
    QTranslator translator;
    translator.load("/usr/share/Gbyzanz/translations/gbyzanz_" + QLocale::system().name());
    app.installTranslator(&translator);

    qmlRegisterType<Controller>("Controller", 1, 0, "Controller");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
