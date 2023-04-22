#include "qmlplot.h"
#include "qcustomplot.h"
#include <QDebug>

CustomPlotItem::CustomPlotItem(QQuickItem* parent) : QQuickPaintedItem(parent), m_CustomPlot(nullptr), m_timerId(0)
{
    setFlag(QQuickItem::ItemHasContents, true);
    setAcceptedMouseButtons(Qt::AllButtons);
    _pPortTelemetry = new ParserTelemetry();

    connect(this, &QQuickPaintedItem::widthChanged, this, &CustomPlotItem::updateCustomPlotSize);
    connect(this, &QQuickPaintedItem::heightChanged, this, &CustomPlotItem::updateCustomPlotSize);
    connect(_pPortTelemetry, &ParserTelemetry::sendPacket, this, &CustomPlotItem::onPacketReceived);
    connect(_pPortTelemetry, &ParserTelemetry::sendRawBuffer, this, &CustomPlotItem::onBufferReceived);
}

CustomPlotItem::~CustomPlotItem()
{
    delete m_CustomPlot;
    m_CustomPlot = nullptr;

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
        _pPortTelemetry->openPort(portNumber, QSerialPort::Baud115200, QSerialPort::Data8, QSerialPort::OneStop,
                                  QSerialPort::NoParity);
}

bool CustomPlotItem::portIsOpen() { return _pPortTelemetry->portIsOpen(); }
void CustomPlotItem::initCustomPlot()
{

    m_CustomPlot = new QCustomPlot();

    updateCustomPlotSize();
    m_CustomPlot->addGraph();
    m_CustomPlot->graph(0)->setPen(QPen(Qt::red));
    m_CustomPlot->xAxis->setLabel("Время, сек.");
    m_CustomPlot->yAxis->setLabel("Концентрация мг/куб. м");
    m_CustomPlot->xAxis->setRange(0, 60);
    m_CustomPlot->yAxis->setRange(0, 10);
    m_CustomPlot->setInteractions(QCP::iRangeDrag | QCP::iRangeZoom);

    startTimer(1000);

    connect(m_CustomPlot, &QCustomPlot::afterReplot, this, &CustomPlotItem::onCustomReplot);

    m_CustomPlot->replot();
}

void CustomPlotItem::paint(QPainter* painter)
{
    if (m_CustomPlot)
    {
        QPixmap picture(boundingRect().size().toSize());
        QCPPainter qcpPainter(&picture);

        m_CustomPlot->toPainter(&qcpPainter);
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

void CustomPlotItem::onPacketReceived(dataPack packet)
{

    receivedData->temperature.append(packet.temperature);
    receivedData->CO2.append(packet.CO2);
    receivedData->CH4.append(packet.CH4);
}
void CustomPlotItem::timerEvent(QTimerEvent* event)
{
    static int t = 0;
    double U;
    U = ((double)rand() / RAND_MAX) * 10;
    // U = receivedData->temperature.at(t);
    //m_CustomPlot->graph(0)->addData(t, U);
    //qDebug() << Q_FUNC_INFO << QString("Adding dot t = %1, S = %2").arg(t).arg(U);
    t++;
    m_CustomPlot->replot();
}

void CustomPlotItem::graphClicked(QCPAbstractPlottable* plottable)
{
    //qDebug() << Q_FUNC_INFO << QString("Clicked on graph '%1 ").arg(plottable->name());
}

void CustomPlotItem::routeMouseEvents(QMouseEvent* event)
{
    if (m_CustomPlot)
    {
        QMouseEvent* newEvent =
            new QMouseEvent(event->type(), event->localPos(), event->button(), event->buttons(), event->modifiers());
        QCoreApplication::postEvent(m_CustomPlot, newEvent);
    }
}

void CustomPlotItem::routeWheelEvents(QWheelEvent* event)
{
    if (m_CustomPlot)
    {
        QWheelEvent* newEvent =
            new QWheelEvent(event->pos(), event->delta(), event->buttons(), event->modifiers(), event->orientation());
        QCoreApplication::postEvent(m_CustomPlot, newEvent);
    }
}

void CustomPlotItem::updateCustomPlotSize()
{
    if (m_CustomPlot)
    {
        m_CustomPlot->setGeometry(0, 0, (int)width(), (int)height());
        m_CustomPlot->setViewport(QRect(0, 0, (int)width(), (int)height()));
    }
}

void CustomPlotItem::onCustomReplot()
{
    //qDebug() << Q_FUNC_INFO;
    update();
}
