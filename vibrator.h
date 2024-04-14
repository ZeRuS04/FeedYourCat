#ifndef VIBRATOR_H
#define VIBRATOR_H

#include <QObject>

#if defined(Q_OS_ANDROID)
#include <QJniEnvironment>
#include <QJniObject>
#endif
class Vibrator : public QObject
{
    Q_OBJECT
public:
    explicit Vibrator(QObject *parent = 0);
signals:
public slots:
    void vibrate(int milliseconds);
    void setEnabled(bool value);
private:
    bool m_enabled;
#if defined(Q_OS_ANDROID)
    QJniObject vibratorService;
#endif
};

#endif // VIBRATOR_H
