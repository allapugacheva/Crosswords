// messageprovider.h
#ifndef MESSAGEPROVIDER_H
#define MESSAGEPROVIDER_H

#include <QObject>

extern "C" {
    const char* getNewMops();  // Объявляем функцию из библиотеки
}

class MessageProvider : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE QString getMessage() const {
        return QString::fromUtf8(getNewMops());  // Вызов C-функции
    }
};

#endif // MESSAGEPROVIDER_H
