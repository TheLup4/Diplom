#include "parser.h"
#include <QtMath>

const int kFulTlmtPacketSize = sizeof(dataPack);
QByteArray kTlmtHeader = "\xFF\xFF";
QString strTlmtHeader = "FF";
QString strEndLine = "\r\n";

const double kA = 0.001032;
const double kB = 0.0002387;
const double kC = 0.000000158;

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
        //        QMessageBox warning;
        //        warning.setWindowTitle("");
        //        warning.setText(QString("Порт %1 открыт").arg(name));
        //        warning.exec();
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
            QMessageBox warning;
            warning.setWindowTitle("");
            warning.setText(QString("Порт закрыт"));
            warning.exec();
        }
}

void ParserTelemetry::onReadyRead()
{
    _rawBuffer.append(_pPort->readAll());
    //qDebug() << _rawBuffer.toHex(',');
    emit sendRawBuffer(_rawBuffer.toHex(','));
    if (getIsHaveFullBasePack())
        checkRawBaseData();

    //    _strRawBuffer.append(_pPort->readLine());
    //    //qDebug() << _strRawBuffer;
    //    if (getIsHaveFullBasePack())
    //        checkRawBaseData();
}

void ParserTelemetry::checkRawBaseData()
{
    while (_rawBuffer.contains(kTlmtHeader))
    {
        //qDebug() << _rawBuffer;

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
        countTemp(&packet);

        if (kFulTlmtPacketSize -
            2 /*checkCRC(reinterpret_cast<unsigned char*>(pack.data()), kFulTlmtPacketSize - 1 < packet.CheckSum_XOR16)*/)
        {
            _errorCounter++;
            emit sendCountErrors(_errorCounter);
        }
        else
        {}
        emit sendPacket(_dataPack);

        //qDebug() << packet.temperature << packet.CO2 << packet.CH4;

        _rawBuffer.clear();
    }

    //    while (_strRawBuffer.contains(strTlmtHeader))
    //    {
    //        _strRawBuffer.remove(strTlmtHeader + ",");
    //        _strRawBuffer.remove("\r\n");
    //        QStringList strData = _strRawBuffer.split(",");
    //        dataPack packet;
    //        packet.temperature = strData.at(0).toDouble();
    //        packet.CO2 = strData.at(1).toDouble();
    //        packet.CH4 = strData.at(2).toDouble();
    //    }
}

bool ParserTelemetry::getIsHaveFullBasePack()
{
    if (_rawBuffer.contains(kTlmtHeader))
    {
        if (_rawBuffer.length() >= kFulTlmtPacketSize)
            return true;
    }

    if (_strRawBuffer.contains(strTlmtHeader) && _strRawBuffer.contains(strEndLine))
        return true;

    return false;
}

void ParserTelemetry::countTemp(dataPack* packet)
{

    double voltage = (double)packet->temperature / 4095 * 3.3;
    double resist = 33000 / voltage - 10000;
    _dataPack.temperature.append((1 / (kA + kB * log(resist) + kC * pow(log(resist), 3))) - 273.15);
    //qDebug() << _dataPack.temperature.last() << "sss";
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
