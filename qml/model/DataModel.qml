import QtQuick
import Felgo

Item {

    id: dataModel

    signal loggedIn

    property string userId: ""

    property var dataList: []

    property var levelsList

    function registerUser(email, password) {

        var request = new XMLHttpRequest();
        request.open("POST", "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBEKFvBzfYM777v2OZLC6qPauzrF4l-qiw", true)
        request.setRequestHeader("Content-Type", "application/json")

        request.onreadystatechange = function() {
            if(request.readyState === XMLHttpRequest.DONE) {
                if(request.status === 200) {

                    var respObj = JSON.parse(request.responseText)
                    userId = respObj.localId
                    dataList = []
                    dataList = dataList.concat("99999")
                    dataList = dataList.concat("0")
                    dataList = dataList.concat("0")
                    dataList = dataList.concat(0)
                    dataList = dataList.concat(0)

                    var createRequest = new XMLHttpRequest()
                    createRequest.open("PUT", "https://crosswords-da127-default-rtdb.europe-west1.firebasedatabase.app/users/" + userId + ".json", true)
                    createRequest.setRequestHeader("Content-Type", "application/json")

                    createRequest.onerror = function() {
                        console.debug("Register user put data request error")
                    }

                    var data = JSON.stringify({
                                                  bestResult: "99999",
                                                  worstResult: "0",
                                                  averageResult: "0",
                                                  hintsUsed: 0,
                                                  levelsComplete: 0
                                              })

                    createRequest.send(data)
                    loggedIn()
                } else {
                    var errObj = JSON.parse(request.responseText)

                    NativeUtils.displayMessageBox(qsTr("Login fail"), qsTr("Reason: " + errObj.error.message))
                }
            }
        }

        request.onerror = function() {
            console.debug("Register user request error")
        }

        var data = JSON.stringify({
                                      email: email,
                                      password: password,
                                      returnSecureToken: true
                                  })

        request.send(data)
    }

    function loginUser(email, password) {

        var request = new XMLHttpRequest();
        request.open("POST", "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBEKFvBzfYM777v2OZLC6qPauzrF4l-qiw", true)
        request.setRequestHeader("Content-Type", "application/json")

        request.onreadystatechange = function() {
            if(request.readyState === XMLHttpRequest.DONE) {
                if(request.status === 200) {

                    var respObj = JSON.parse(request.responseText)
                    userId = respObj.localId

                    var getRequset = new XMLHttpRequest()
                    getRequset.open("GET", "https://crosswords-da127-default-rtdb.europe-west1.firebasedatabase.app/users/" + userId + ".json", true)
                    getRequset.setRequestHeader("Content-Type", "application/json")

                    getRequset.onreadystatechange = function() {
                        if(getRequset.readyState === XMLHttpRequest.DONE) {

                            var respObj = JSON.parse(getRequset.responseText)
                            dataList = []
                            dataList = dataList.concat(respObj.bestResult)
                            dataList = dataList.concat(respObj.worstResult)
                            dataList = dataList.concat(respObj.averageResult)
                            dataList = dataList.concat(respObj.hintsUsed)
                            dataList = dataList.concat(respObj.levelsComplete)
                        }
                    }

                    getRequset.onerror = function() {
                        console.debug("Register user put data request error")
                    }

                    getRequset.send()
                    loggedIn()
                } else {
                    var errObj = JSON.parse(request.responseText)

                    NativeUtils.displayMessageBox(qsTr("Login fail"), qsTr("Reason: " + errObj.error.message))
                }
            }
        }

        request.onerror = function() {
            console.debug("Register user request error")
        }

        var data = JSON.stringify({
                                      email: email,
                                      password: password,
                                      returnSecureToken: true
                                  })

        request.send(data)
    }

    function updateUser() {

        var updateRequest = new XMLHttpRequest()
        updateRequest.open("PUT", "https://crosswords-da127-default-rtdb.europe-west1.firebasedatabase.app/users/" + userId + ".json", true)
        updateRequest.setRequestHeader("Content-Type", "application/json")

        updateRequest.onerror = function() {
            console.debug("Update request error")
        }

        var data = JSON.stringify({
                                      bestResult: dataList[0],
                                      worstResult: dataList[1],
                                      averageResult: dataList[2],
                                      hintsUsed: dataList[3],
                                      levelsComplete: dataList[4]
                                  })

        updateRequest.send(data)
    }

    function loadLevels() {

        var getRequset = new XMLHttpRequest()
        getRequset.open("GET", "https://crosswords-da127-default-rtdb.europe-west1.firebasedatabase.app/levels.json", true)
        getRequset.setRequestHeader("Content-Type", "application/json")

        getRequset.onreadystatechange = function() {
            if(getRequset.readyState === XMLHttpRequest.DONE) {

                levelsList = JSON.parse(getRequset.responseText)
            }
        }

        getRequset.onerror = function() {
            console.debug("Get levels request error")
        }

        getRequset.send()
    }
}
