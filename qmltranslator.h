#ifndef QMLTRANSLATOR_H
#define QMLTRANSLATOR_H

#include <QObject>
#include <QTranslator>
#include <QQmlApplicationEngine>


class QmlTranslator : public QObject
{
    Q_OBJECT

public:
    explicit QmlTranslator(QQmlApplicationEngine *engine, QObject *parent = 0);

signals:
    void languageChanged();

public:
    Q_INVOKABLE void setTranslation(QString translation);

private:
    QTranslator m_translator;
    QQmlApplicationEngine *m_engine;
};

#endif // QMLTRANSLATOR_H
