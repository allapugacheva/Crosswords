import Felgo
import QtQuick
import "pages"
import "model"

App {

    id: app

    DataModel {
        id: dataModel
        onLoggedIn: function() {

            stack.push(mainPage, {dm: dataModel})
        }
        onLoginError: function() {

            loginPage.updateMops()
        }
    }

    NavigationStack {
        id: stack

        LoginPage {
            id: loginPage

            onLogin: {
                if(isRegister)
                    dataModel.registerUser(email, password)
                else
                    dataModel.loginUser(email, password)
            }
        }
    }

    Component {
        id: mainPage
        MainPage {

            backNavigationEnabled: false
            onPopped: function() {
                stack.pop()
            }
        }
    }

    Component.onCompleted: function() {

        dataModel.loadLevels()
    }
}
