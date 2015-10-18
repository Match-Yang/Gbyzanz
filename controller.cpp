#include <QProcess>
#include <QDebug>
#include "controller.h"

Controller::Controller(QObject *parent) : QObject(parent)
{

}

void Controller::recordScreen(QRect rec, QString fileName, int duration, QString comm, bool recordAudio, bool recordCursor)
{
    QProcess * byzanzProcess = new QProcess(this);
    connect(byzanzProcess, SIGNAL(finished(int)), byzanzProcess, SLOT(deleteLater()));
    connect(byzanzProcess, SIGNAL(finished(int)), this, SLOT(onRecordFinish()));

    QStringList arguments;
    arguments << QString("--x=%1").arg(rec.x()) << QString("--y=%1").arg(rec.y());
    arguments << QString("--width=%1").arg(rec.width()) << QString("--height=%1").arg(rec.height());
    duration > 0 ? arguments << QString("--duration=%1").arg(duration) : arguments << QString("--exec=%1").arg(comm);
    if (recordAudio)
        arguments << "--audio";
    if (recordCursor)
        arguments << "--cursor";
    arguments << fileName;

    byzanzProcess->start("byzanz-record", arguments);
}

void Controller::saveConfig()
{

}

void Controller::onRecordFinish()
{
    QProcess * process = qobject_cast<QProcess *>(sender());
    if (process) {
        emit recordFinished(process->exitCode(), process->errorString());
        qWarning() << "record finish!" << process->exitCode() << process->errorString();
    }
}

