#ifndef PARSER_H
#define PARSER_H

#include <QBitArray>
#include <QDateTime>
#include <QDebug>
#include <QFile>
#include <QMessageBox>
#include <QMutex>
#include <QObject>
#include <QSerialPort>
#include <QTimer>

#include "packet.h"

class ParserTelemetry : public QObject
{
    Q_OBJECT
public:
    explicit ParserTelemetry(QObject* parent = nullptr);
    ~ParserTelemetry();
    QMutex _mutex;

    void stop();
    void setFileName(QString fName);
    bool portIsOpen();

signals:
    void setMessage(QString msg);
    void changeStatePort(bool isRunning);
    void sendPacket(receivedData receivedData);
    void sendCountErrors(int _errorCounter);
    void sendRawBuffer(QString rawBuffer);

public slots:
    bool openPort(QString name, int baudrate, int databits, int stopbits, int parity);
    void closePort();

private slots:
    void onReadyRead();

private:
    QSerialPort* _pPort;
    QTimer* _pTimer;
    double _VLV;
    char chbuf[100];
    dataPack _packet;
    receivedData _dataPack;
    slideAverage _average;
    void countSlideAverage();
    bool parseTlmt(QByteArray& pack);
    void checkRawBaseData();
    bool getIsHaveFullBasePack();

    void checkBasePack(QByteArray pack);

    uint16_t checkCRC(uint8_t* buf, uint8_t size);

    void countTemp(dataPack* packet);

protected:
    QByteArray _rawBuffer;
    QString _strRawBuffer;
    quint64 _errorCounter;
    quint64 _packCounter;
    quint16 _lastPackCounter;
    quint64 _nNumErrors;
};

#endif // PARSER_H
