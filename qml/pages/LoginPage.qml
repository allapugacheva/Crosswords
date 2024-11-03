import QtQuick
import Felgo
import MyLib

AppPage {

    id: loginPage
    title: qsTr("Авторизация")

    property string mopsSource: "https://i.ibb.co/SKCQQTc/9cfe88727e169790f0ce44e9aedf1f1e.png"

    signal login(bool isRegister, string email, string password)

    MessageProvider {
        id: lib
    }

    Column {
        anchors.fill: parent
        anchors.margins: dp(12)
        spacing: dp(12)

        AppTextField {
            id: textFieldEmail
            width: parent.width
            placeholderText: qsTr("e-mail")
            inputMethodHints: Qt.ImhEmailCharactersOnly
        }

        AppTextField {
            id: textFieldPassword
            width: parent.width
            placeholderText: qsTr("пароль")
            echoMode: TextInput.Password
        }

        AppCheckBox {
            id: checkBoxRegister
            text: qsTr("Регистрация нового пользователя")
            anchors.horizontalCenter: parent.horizontalCenter
            checked: false
        }

        AppButton {
            text: checkBoxRegister.checked ? qsTr("Регистрация") : qsTr("Вход")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: loginPage.login(checkBoxRegister.checked, textFieldEmail.text, textFieldPassword.text)
        }

        Image {
            id: mops
            source: mopsSource
            width: parent.width
            height: parent.width
        }
    }

    function updateMops() {

        mopsSource = lib.getMessage()
    }
}
