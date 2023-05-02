#include "qmlplot.h"
#include "qcustomplot.h"
#include <QDateTime>
#include <QDebug>
#include <QFile>
#include <QTextStream>

CustomPlotItem::CustomPlotItem(QQuickItem* parent) : QQuickPaintedItem(parent), m_Plot(nullptr), m_timerId(0)
{
    setFlag(QQuickItem::ItemHasContents, true);
    setAcceptedMouseButtons(Qt::AllButtons);
    _pPortTelemetry = new ParserTelemetry();
    m_Plot = new QCustomPlot();
    _saveDir = "";

    connect(this, &QQuickPaintedItem::widthChanged, this, &CustomPlotItem::updateCustomPlotSize);
    connect(this, &QQuickPaintedItem::heightChanged, this, &CustomPlotItem::updateCustomPlotSize);
    connect(_pPortTelemetry, &ParserTelemetry::sendPacket, this, &CustomPlotItem::onPacketReceived);
    connect(_pPortTelemetry, &ParserTelemetry::sendRawBuffer, this, &CustomPlotItem::onBufferReceived);
}

CustomPlotItem::~CustomPlotItem()
{
    delete m_Plot;
    m_Plot = nullptr;

    if (m_timerId != 0)
    {
        killTimer(m_timerId);
    }
}
QStringList CustomPlotItem::updatePortCombobox()
{

    QStringList list;
    const auto avaliblePorts = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo& info : avaliblePorts)
    {

        list << info.portName();
    }
    return list;
}
void CustomPlotItem::openPort(QString portNumber)
{
    if (!_pPortTelemetry->portIsOpen())
        _pPortTelemetry->openPort(portNumber, 50000, QSerialPort::Data8, QSerialPort::OneStop, QSerialPort::NoParity);

    if (_pPortTelemetry->portIsOpen())
        m_timerId = startTimer(1000);
}

void CustomPlotItem::closePort()
{
    if (_pPortTelemetry->portIsOpen())
    {
        _pPortTelemetry->closePort();
        // killTimer(m_timerId);
    }
}

bool CustomPlotItem::portIsOpen() { return _pPortTelemetry->portIsOpen(); }
void CustomPlotItem::initCustomPlot()
{

    updateCustomPlotSize();
    m_Plot->addGraph();
    m_Plot->addGraph();
    m_Plot->addGraph();

    m_Plot->graph(0)->setPen(QPen(Qt::red));
    m_Plot->graph(1)->setPen(QPen(Qt::green));
    m_Plot->graph(2)->setPen(QPen(Qt::blue));

    //ограничения
    limitTemp = new QCPGraph(m_Plot->xAxis, m_Plot->yAxis);
    limitTemp->setPen(QPen(Qt::red));
    limitTemp->setLineStyle(QCPGraph::lsStepLeft);
    limitCO2 = new QCPGraph(m_Plot->xAxis, m_Plot->yAxis);
    limitCO2->setPen(QPen(Qt::green | Qt::DashLine));
    limitCH4 = new QCPGraph(m_Plot->xAxis, m_Plot->yAxis);
    limitCH4->setPen(QPen(Qt::blue | Qt::DashLine));

    //    m_Plot->addGraph(m_Plot->xAxis2,m_Plot->yAxis);
    //    m_Plot->graph(6)->setVisible(false);
    //    m_Plot->xAxis2->setVisible(false);

    m_Plot->xAxis->setLabel("Время, сек.");
    m_Plot->yAxis->setLabel("Концентрация мг/куб. м");
    //    m_Plot->xAxis->setRange(0, 60);
    //    m_Plot->yAxis->setRange(0, 25);
    //    m_Plot->xAxis2->setRange(0, 60);
    m_Plot->setInteractions(QCP::iRangeDrag | QCP::iRangeZoom);

    connect(m_Plot, &QCustomPlot::afterReplot, this, &CustomPlotItem::onCustomReplot);

    m_Plot->replot();
    qDebug() << m_Plot;
}

void CustomPlotItem::paint(QPainter* painter)
{
    if (m_Plot)
    {
        QPixmap picture(boundingRect().size().toSize());
        QCPPainter qcpPainter(&picture);

        m_Plot->toPainter(&qcpPainter);
        setRenderTarget(QQuickPaintedItem::FramebufferObject);

        painter->drawPixmap(QPoint(), picture);
    }
}

void CustomPlotItem::onBufferReceived(QString rawBuffer) { emit signalNewBuffer(rawBuffer + "\r\n"); }

void CustomPlotItem::mousePressEvent(QMouseEvent* event)
{
    //qDebug() << Q_FUNC_INFO;
    routeMouseEvents(event);
}

void CustomPlotItem::mouseReleaseEvent(QMouseEvent* event)
{
    //qDebug() << Q_FUNC_INFO;
    routeMouseEvents(event);
}

void CustomPlotItem::mouseMoveEvent(QMouseEvent* event) { routeMouseEvents(event); }

void CustomPlotItem::mouseDoubleClickEvent(QMouseEvent* event)
{
    //qDebug() << Q_FUNC_INFO;
    routeMouseEvents(event);
}

void CustomPlotItem::wheelEvent(QWheelEvent* event) { routeWheelEvents(event); }

void CustomPlotItem::onPacketReceived(receivedData receivedData)
{
    static int count = 0;

    qDebug() << receivedData.temperature.last() << count;

    m_Plot->graph(0)->addData(count, receivedData.temperature.last());
    QTextStream writeStream(&_file);
    if (_saveDir != "")
        if (_file.isOpen())
            writeStream << QDateTime::currentDateTime().toString("hh:mm:ss.zz_dd.MM.yyyy ") + "," +
                               QString::number(receivedData.temperature.last(), 'f', 4) + "," +
                               QString::number(receivedData.CO2.last(), 'f', 4) + "," +
                               QString::number(receivedData.CH4.last(), 'f', 4) + "\r\n";
    if (!_pPortTelemetry->portIsOpen())
        _file.close();
    QMessageBox warning;
    if (receivedData.temperature.last() > _tempLimit && limitTemp->visible() && !warning.isVisible())
    {
        warning.setWindowTitle("Внимание");
        warning.setText(QString("Температура превышает допустимое значение!"));
        warning.exec();
    }
    //            if (u2 > _co2Limit && limitCO2->visible())
    //                QMessageBox::warning(nullptr, "Внимание", "Концентрация CO2 превышает допустимое значение");
    //            if (u3 > _ch4Limit && limitCH4->visible())
    //                QMessageBox::warning(nullptr, "Внимание", "Концентрация CH4 превышает допустимое значение");
    count++;
    m_Plot->rescaleAxes(true);
    m_Plot->replot();
}
void CustomPlotItem::showGraph(int index, bool isShown) { m_Plot->graph(index)->setVisible(isShown); }

void CustomPlotItem::setLimits(int index, bool isShown, QString value)
{
    switch (index)
    {
        case 3:
            limitTemp->setVisible(isShown);
            limitTemp->setData({0, 100000000}, {value.toDouble(), value.toDouble()});
            _tempLimit = value.toDouble();

            break;
        case 4:
            limitCO2->setVisible(isShown);
            limitCO2->setData({0, 100000000}, {value.toDouble(), value.toDouble()});
            _co2Limit = value.toDouble();
            break;
        case 5:
            limitCH4->setVisible(isShown);
            limitCH4->setData({0, 100000000}, {value.toDouble(), value.toDouble()});
            _ch4Limit = value.toDouble();
            break;
    }
}
void CustomPlotItem::timerEvent(QTimerEvent* event)
{
    static int t = 0;

    double u1, u2, u3;
    if (_pPortTelemetry->portIsOpen())
    {
        // if (receivedData.temperature.size() > 0)
        //        m_Plot->graph(0)->addData(t, receivedData.temperature.last());
        //            m_Plot->graph(1)->addData(t, receivedData->CO2.at(t));
        //            m_Plot->graph(2)->addData(t, receivedData->CH4.at(t));
        //u1 = ((double)rand() / RAND_MAX) * 5;
        //        u2 = ((double)rand() / RAND_MAX) * 5;
        //        u3 = ((double)rand() / RAND_MAX) * 5;
        //        //m_Plot->graph(0)->addData(t, u1);
        //        m_Plot->graph(1)->addData(t, u2);
        m_Plot->graph(6)->addData(t / 10, 0);
    }

    // qDebug() << Q_FUNC_INFO << QString("Adding dot t = %1, S = %2").arg(t).arg(U);
    t++;

    m_Plot->replot();
}

void CustomPlotItem::graphClicked(QCPAbstractPlottable* plottable)
{

    qDebug() << Q_FUNC_INFO << QString("Clicked on graph '%1 ").arg(plottable->name());
    m_Plot->rescaleAxes();
}

void CustomPlotItem::routeMouseEvents(QMouseEvent* event)
{
    if (m_Plot)
    {
        QMouseEvent* newEvent =
            new QMouseEvent(event->type(), event->localPos(), event->button(), event->buttons(), event->modifiers());
        QCoreApplication::postEvent(m_Plot, newEvent);
    }
}

void CustomPlotItem::routeWheelEvents(QWheelEvent* event)
{
    if (m_Plot)
    {
        QWheelEvent* newEvent =
            new QWheelEvent(event->pos(), event->delta(), event->buttons(), event->modifiers(), event->orientation());
        QCoreApplication::postEvent(m_Plot, newEvent);
    }
}

void CustomPlotItem::updateCustomPlotSize()
{
    if (m_Plot)
    {
        m_Plot->setGeometry(0, 0, (int)width(), (int)height());
        m_Plot->setViewport(QRect(0, 0, (int)width(), (int)height()));
    }
}

void CustomPlotItem::onCustomReplot()
{
    //qDebug() << Q_FUNC_INFO;
    update();
}

void CustomPlotItem::setSaveDir(QString saveDirQml)
{
    qDebug() << saveDirQml;
    _saveDir = saveDirQml.remove("file:///");
    qDebug() << _saveDir + "/Tlmt_" + QDateTime::currentDateTime().toString("hh.mm_dd.MM.yyyy ") + ".txt";
    _file.setFileName(_saveDir + "/Tlmt_" + QDateTime::currentDateTime().toString("hh:mm_dd.MM.yyyy ") + ".txt");
    if (!_file.open(QIODevice::WriteOnly | QIODevice::Text))
        QMessageBox::warning(nullptr, "Ошибка", "Не удалось создать файл");
}
