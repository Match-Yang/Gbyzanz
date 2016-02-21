#include <QProcess>
#include <QFile>
#include <QDebug>
#include "controller.h"

Controller::Controller(QObject *parent) : QObject(parent)
{
    initSettings();
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

void Controller::saveConfig(const QRect &rec,
                            const QString &fileFormat,
                            bool useDuration,
                            int duration,
                            bool useCommand,
                            const QString &command,
                            bool recordAudio,
                            bool recordCursor)
{
    m_settings->beginGroup("RecordRect");
    m_settings->setValue("x", rec.x());
    m_settings->setValue("y", rec.y());
    m_settings->setValue("width", rec.width());
    m_settings->setValue("height", rec.height());
    m_settings->endGroup();

    m_settings->beginGroup("File");
    m_settings->setValue("file_format", fileFormat);
    m_settings->endGroup();

    m_settings->beginGroup("DurationType");
    m_settings->setValue("use_duration", useDuration);
    m_settings->setValue("duration", duration);
    m_settings->setValue("use_command", useCommand);
    m_settings->setValue("command", command);
    m_settings->endGroup();

    m_settings->beginGroup("ExtendRecord");
    m_settings->setValue("record_audio", recordAudio);
    m_settings->setValue("record_cursor", recordCursor);
    m_settings->endGroup();
}

void Controller::saveThemeColor(const QString &primaryColor, const QString &accentColor, const QString &backgroundColor)
{
    m_settings->beginGroup("Theme");
    m_settings->setValue("primary_color", primaryColor);
    m_settings->setValue("accent_color", accentColor);
    m_settings->setValue("background_color", backgroundColor);
    m_settings->endGroup();
}

void Controller::saveFilePath(const QString &path)
{
    m_settings->beginGroup("File");
    m_settings->setValue("save_path", path);
    m_settings->endGroup();
}

QRect Controller::getRecordRect() const
{
    QRect rect;
    m_settings->beginGroup("RecordRect");
    rect.setX(m_settings->value("x").toInt());
    rect.setY(m_settings->value("y").toInt());
    rect.setWidth(m_settings->value("width").toInt());
    rect.setHeight(m_settings->value("height").toInt());
    m_settings->endGroup();
    return rect;
}

QString Controller::getSavePath() const
{
    return m_settings->value("File/save_path").toString();
}

QString Controller::getFileFormat() const
{
    return m_settings->value("File/file_format").toString();
}

bool Controller::useDuration() const
{
    return m_settings->value("DurationType/use_duration").toBool();
}

int Controller::duration() const
{
    return m_settings->value("DurationType/duration").toInt();
}

bool Controller::useCommand() const
{
    return m_settings->value("DurationType/use_command").toBool();
}

QString Controller::command() const
{
    return m_settings->value("DurationType/command").toString();
}

bool Controller::recordAudio() const
{
    return m_settings->value("ExtendRecord/record_audio").toBool();
}

bool Controller::recordCursor() const
{
    return m_settings->value("ExtendRecord/record_cursor").toBool();
}

QString Controller::getThemePrimaryColor() const
{
    return m_settings->value("Theme/primary_color").toString();
}

QString Controller::getThemeAccentColor() const
{
    return m_settings->value("Theme/accent_color").toString();
}

QString Controller::getThemeBackgroundColor() const
{
    return m_settings->value("Theme/background_color").toString();
}

void Controller::onRecordFinish()
{
    QProcess * process = qobject_cast<QProcess *>(sender());
    if (process) {
        emit recordFinished(process->exitCode(), process->errorString());
        qWarning() << "record finish!" << process->exitCode() << process->errorString();
    }
}

void Controller::initSettings()
{
    m_settings = new QSettings("MatchYang", "Gbyzanz", this);
    if (!QFile::exists(m_settings->fileName())) {
        m_settings->beginGroup("RecordRect");
        m_settings->setValue("x", 0);
        m_settings->setValue("y", 0);
        m_settings->setValue("width", 0);
        m_settings->setValue("height", 0);
        m_settings->endGroup();

        m_settings->beginGroup("File");
        m_settings->setValue("save_path", DEFAULT_SAVE_PATH);
        m_settings->setValue("file_format", ".gif");
        m_settings->endGroup();

        m_settings->beginGroup("DurationType");
        m_settings->setValue("use_duration", true);
        m_settings->setValue("duration", 10);
        m_settings->setValue("use_command", false);
        m_settings->setValue("command", "");
        m_settings->endGroup();

        m_settings->beginGroup("ExtendRecord");
        m_settings->setValue("record_audio", false);
        m_settings->setValue("record_cursor", true);
        m_settings->endGroup();
    }


    QDir dir;
    if (!dir.exists(getSavePath())) {
        dir.mkpath(getSavePath());
    }

//    qWarning() << "Configure File: " << m_settings->fileName();
}

