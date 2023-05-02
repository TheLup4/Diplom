#ifndef PACKET_H
#define PACKET_H

#include <QObject>
#include <QVector>

#pragma pack(1)
typedef struct
{
    uint16_t Header; //0xFF – заголовок данного пакета

    uint16_t CO2 = 0;         //Концентрация углекислого газа
    uint16_t temperature = 0; // Температура окружающей среды
    uint16_t CH4 = 0;         // концентрация метана
    uint16_t CheckSum_XOR16;  //Контрольная сумма (XOR 16 бит)
} dataPack;

struct receivedData
{

    QVector<double> CO2;
    QVector<double> temperature;
    QVector<double> CH4;
};
#pragma pack(0)

#endif // PACKET_H
