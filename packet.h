#ifndef PACKET_H
#define PACKET_H

#include <QObject>
#include <QVector>

#pragma pack(1)
typedef struct
{
    uint16_t Header;        //0xFF – заголовок данного пакета
    double temperature = 0; // Температура окружающей среды
    double CO2 = 0;         //Концентрация углекислого газа
    double CH4 = 0;         // концентрация метана
    uint8_t CheckSum_XOR8;  //Контрольная сумма (XOR 8 бит)
} dataPack;

struct receivedData
{
    QVector<double> temperature;
    QVector<double> CO2;
    QVector<double> CH4;
};
#pragma pack(0)

#endif // PACKET_H
