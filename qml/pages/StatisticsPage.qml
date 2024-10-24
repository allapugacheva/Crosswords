import QtQuick
import Felgo

AppPage {

    id: statisticsPage
    title: qsTr("Статистика игр")

    property var userData: []

    Column {
        id: contentCol
        anchors.fill: parent
        anchors.margins: dp(12)
        spacing: dp(12)

        AppText {
            text: "Лучшее время: " + userData[0]
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: sp(20)
        }

        AppText {
            text: "Худшее время: " + userData[1]
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: sp(20)
        }

        AppText {
            text: "Среднее время: " + userData[2]
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: sp(20)
        }

        AppText {
            text: "Использовано подсказок: " + userData[3]
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: sp(20)
        }

        AppText {
            text: "Пройдено уровней: " + userData[4]
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: sp(20)
        }

        AppButton {
            text: "Выйти из аккаунта"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: stack.popAllExceptFirst()
        }
    }
}
