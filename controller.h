#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QRect>

class Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QObject *parent = 0);

    Q_INVOKABLE void recordScreen(QRect rec,
                             QString fileName,
                             int duration,
                             QString comm,
                             bool recordAudio,
                             bool recordCursor);

    Q_INVOKABLE void saveConfig();

signals:
    void recordFinished(int exitCode, QString errorString);

private slots:
    void onRecordFinish();
};

#endif // CONTROLLER_H
