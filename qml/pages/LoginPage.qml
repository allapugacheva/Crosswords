import QtQuick
import Felgo

AppPage {

    id: loginPage
    title: qsTr("Авторизация")

    signal login(bool isRegister, string email, string password)

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
    }
}
