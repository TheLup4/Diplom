#include "parser.h"

const int kFulTlmtPacketSize = sizeof(dataPack);
QByteArray kTlmtHeader = "\xFF";

ParserTelemetry::ParserTelemetry(QObject* parent) : QObject(parent)
{

    _pPort = new QSerialPort();
    _pTimer = new QTimer();
}

ParserTelemetry::~ParserTelemetry()
{
    if (_pPort)
    {
        if (_pPort->isOpen())
            _pPort->close();
        _pPort->deleteLater();
    }
    _pTimer->deleteLater();
}
bool ParserTelemetry::portIsOpen() { return _pPort->isOpen(); }

bool ParserTelemetry::openPort(QString name, int baudrate, int databits, int stopbits, int parity)
{
    if (_pPort->isOpen())
        _pPort->close();

    _pPort->setPortName(name);
    _pPort->setBaudRate(baudrate);
    _pPort->setDataBits(static_cast<QSerialPort::DataBits>(databits));
    _pPort->setStopBits(static_cast<QSerialPort::StopBits>(stopbits));
    _pPort->setParity(static_cast<QSerialPort::Parity>(parity));

    if (_pPort->open(QSerialPort::ReadWrite))
    {
        _errorCounter = 0;
        connect(_pPort, &QSerialPort::readyRead, this, &ParserTelemetry::onReadyRead, Qt::UniqueConnection);
        qDebug() << "port opened:" << _pPort->isOpen();
        QMessageBox warning;
        warning.setWindowTitle("");
        warning.setText(QString("Порт %1 открыт").arg(name));
        warning.exec();
        return true;
    }
    else
    {
        QMessageBox warning;
        warning.setWindowTitle("");
        warning.setText(QString("Не удалось открыть порт %1").arg(name));
        warning.exec();
    }

    return false;
}

void ParserTelemetry::closePort()
{
    if (_pPort)
        if (_pPort->isOpen())
        {
            _pPort->close();
        }
}

void ParserTelemetry::onReadyRead()
{
    _rawBuffer.append(_pPort->readAll());
    qDebug() << _rawBuffer.toHex(',');
    emit sendRawBuffer(_rawBuffer.toHex(','));
    if (getIsHaveFullBasePack())
        checkRawBaseData();
}

void ParserTelemetry::checkRawBaseData()
{
    while (_rawBuffer.contains(kTlmtHeader))
    {
        qDebug() << _rawBuffer;

        int indexOfPackStart = _rawBuffer.indexOf(kTlmtHeader);

        _rawBuffer.remove(0, indexOfPackStart);

        if (_rawBuffer.length() < kFulTlmtPacketSize)
            return; //Рано тебе ещё парситься, не дорос ещё)

        QByteArray pack = _rawBuffer.mid(0, kFulTlmtPacketSize);

        _rawBuffer.remove(0, kFulTlmtPacketSize);

        dataPack packet;
        memcpy(&packet, pack.data(), kFulTlmtPacketSize);
        //packet = reinterpret_cast<navigationData*>((uint8_t*)(pack.data()));
        //qDebug() << pack.toHex(',');
        if (checkCRC(reinterpret_cast<unsigned char*>(pack.data()), kFulTlmtPacketSize - 1 < packet.CheckSum_XOR8))
        {
            _errorCounter++;
            emit sendCountErrors(_errorCounter);
        }
        else
        {

            emit sendPacket(packet);
        }
        _rawBuffer.clear();
    }
}
bool ParserTelemetry::getIsHaveFullBasePack()
{
    if (_rawBuffer.contains(kTlmtHeader))
    {
        if (_rawBuffer.length() >= kFulTlmtPacketSize)
            return true;
    }
    return false;
}

uint16_t ParserTelemetry::checkCRC(uint8_t* buf, uint8_t size)
{
    uint16_t res;
    uint16_t* crc;
    crc = (uint16_t*)buf;
    res = crc[0];
    for (int i = 1; i < size; i++)
    {
        res = res ^ crc[i];
    }
    return res;
}
