#include "qmltranslator.h"
#include <QGuiApplication>
#include <QDebug>

QmlTranslator::QmlTranslator(QQmlApplicationEngine *engine, QObject *parent) :
    m_engine(engine),
    QObject(parent)
{

}

void QmlTranslator::setTranslation(QString translation)
{
    if (!m_translator.isEmpty())
        QCoreApplication::removeTranslator(&m_translator);
    m_translator.load(QStringLiteral(":/QmlLanguage_") + translation);
    QCoreApplication::installTranslator(&m_translator);
    m_engine->retranslate();
}
