import Felgo
import QtQuick

AppPage {
    id: myDialog
    title: qsTr("Кроссворды")
    backgroundColor: "white"

    signal hintSelected(int hint)

    Column {
        anchors.fill: parent
        anchors.top: parent.top
        anchors.topMargin: parent.height / 4
        spacing: dp(20)
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Выберите подсказку:")
            font.pixelSize: dp(27)
            wrapMode: Text.WordWrap
        }

        AppButton {
            text: qsTr("Открыть букву")
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 1.3
            height: parent.height / 9
            textSize: dp(20)

            onClicked: {
                console.log("Option 1 selected")
                hintSelected(1)
            }
        }
        AppButton {
            text: qsTr("Убрать лишние буквы")
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 1.3
            height: parent.height / 9
            textSize: dp(20)

            onClicked: {
                console.log("Option 2 selected")
                hintSelected(2)
            }
        }
        AppButton {
            text: qsTr("Показать ответ")
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 1.3
            height: parent.height / 9
            textSize: dp(20)

            onClicked: {
                console.log("Option 3 selected")
                hintSelected(3)
            }
        }
    }
}

