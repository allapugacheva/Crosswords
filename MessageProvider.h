// messageprovider.h
#ifndef MESSAGEPROVIDER_H
#define MESSAGEPROVIDER_H

#include <QObject>
#include <jni.h>
#include <QJniObject>

class MessageProvider : public QObject {
    Q_OBJECT
public:
    explicit MessageProvider(QObject* parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE QString getMessage() {
        QJniObject result = QJniObject::callStaticObjectMethod(
            "com/example/mylibrary/NativeLib",
            "getMessage",
            "()Ljava/lang/String;"
            );

        return result.toString();
    }
};

#endif // MESSAGEPROVIDER_H
