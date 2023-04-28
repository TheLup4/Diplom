#ifndef QMLPLOT_H
#define QMLPLOT_H

#include "packet.h"
#include "parser.h"
#include "qcustomplot.h"
#include <QMainWindow>
#include <QMessageBox>
#include <QSettings>
#include <QTime>
#include <QValidator>
#include <QVector>
#include <QtQuick>
#include <QtSerialPort>

class QCPAbstractPlottable;

class CustomPlotItem : public QQuickPaintedItem
{
    Q_OBJECT

public:
    CustomPlotItem(QQuickItem* parent = 0);
    virtual ~CustomPlotItem();

    void paint(QPainter* painter);

    Q_INVOKABLE void initCustomPlot();

    Q_INVOKABLE bool portIsOpen();
    Q_INVOKABLE void showGraph(int index, bool isShown);
    Q_INVOKABLE void setSaveDir(QString saveDirQml);
    Q_INVOKABLE void setLimits(int index, bool isShown, QString value);
public slots:
    void openPort(QString portNumber);
    QStringList updatePortCombobox();

    void closePort();

protected:
    void routeMouseEvents(QMouseEvent* event);
    void routeWheelEvents(QWheelEvent* event);

    virtual void mousePressEvent(QMouseEvent* event);
    virtual void mouseReleaseEvent(QMouseEvent* event);
    virtual void mouseMoveEvent(QMouseEvent* event);
    virtual void mouseDoubleClickEvent(QMouseEvent* event);
    virtual void wheelEvent(QWheelEvent* event);

    virtual void timerEvent(QTimerEvent* event);

private:
    QCustomPlot* m_Plot;
    ParserTelemetry* _pPortTelemetry;
    ParserTelemetry* _pRawBuffer;
    receivedData* receivedData;
    QCPGraph* limitTemp;
    QCPGraph* limitCO2;
    QCPGraph* limitCH4;
    int m_timerId;
    QString _saveDir;
    QFile _file;
    double _tempLimit;
    double _co2Limit;
    double _ch4Limit;

    void setParamNames();
    void setLineEditConnections();
    void updatePortComboboxes();
    void loadSettings();
    void saveSettings();

private slots:
    void graphClicked(QCPAbstractPlottable* plottable);
    void onCustomReplot();
    void updateCustomPlotSize();
    void onPacketReceived(dataPack packet);
    void onBufferReceived(QString rawBuffer);
signals:
    Q_INVOKABLE void signalNewBuffer(QString buffer);
};

#endif // QMLPLOT_H
