import QtQuick
import Felgo
import QtMultimedia

AppPage {

    id: levelPage
    title: "Кроссворды"

    property var levelData

    property var questions: Object.keys(levelData["?"])
    property var finishedQuestions: []
    property int cur: 0
    property var prevQuestion
    property string curText
    property var answers: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
                           "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
                           "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
                           "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    property var letters: ["", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    property var curWord: ["", "", "", "", "", "", ""]
    property int curWordIndex: 0
    property var curAnswer

    property int currentTime: 0
    property int hints: 0

    property var wdth: width < height ? width : height

    signal endGame(string time, int hints)

    MediaPlayer {
        id: fail
        source: "https://od.lk/d/NzJfNDU3NTU1NTZf/padenie-truby.mp3"
        audioOutput: AudioOutput{}
    }

    MediaPlayer {
        id: audio
        source: "https://od.lk/d/NzJfNDU3NTU0MjFf/prazdnichnyiy-salyut-ili-boevoy-feyerverk-pobedyi-40858.mp3"
        audioOutput: AudioOutput{}
    }

    AnimatedImage {
        id: salutImage
        source: "https://i.ibb.co/vP55S07/saliut.gif"
        anchors.fill: parent
        visible: false
        z: 10
    }

    AppText {
        id: salutText
        text: qsTr("ПОБЕДА!!!")
        font.pixelSize: dp(50)
        color: "orange"
        anchors.centerIn: parent
        visible: false
    }

    Timer {
        id: salutTimer
        interval: 7000
        onTriggered: {
            salutImage.visible = false
            salutText.visible = false
        }
    }

    Component.onCompleted: {
        onLeftButtonClicked()
    }

    Component {
        id: dialog

        HintDialogPage {
            onHintSelected: function(hint) {

                stack.pop()
                hints++

                if(hint === 1) {

                    for(var i = 0; i < curAnswer.length; i++) {

                        if(!curWord[i]) {

                            for(var j = 0; j < 14; j++) {

                                if(letters[j] === curAnswer[i]) {
                                    onLettersGridClicked(j)
                                    break
                                }
                            }

                            break
                        }
                    }

                } else if(hint === 2) {

                    for(var a = 0; a < 14; a++) {

                        if(!curAnswer.includes(letters[a])) {

                            letters.splice(a, 1)
                            letters.splice(a, 0, "")

                            letters = letters.concat("")
                            letters.pop()

                            hlettersGrid.children[a].color = "transparent"
                            lettersGrid.children[a].color = "transparent"
                        }
                    }

                } else {

                    updateColor(questions[cur])
                    var temp = curAnswer

                    for(var x = 0; x < curAnswer.length; x++) {

                        if(temp !== curAnswer)
                            break

                        if(!curWord[x]) {

                            for(var y = 0; y < 14; y++) {

                                if(letters[y] === curAnswer[x]) {
                                    onLettersGridClicked(y)
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    onWidthChanged: {
        adjustLayoutForOrientation();
    }

    onHeightChanged: {
        adjustLayoutForOrientation();
    }

    Timer {
        id: timer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            timerLabel.text = ++currentTime
        }
    }

    Timer {
        id: pressTimer
        interval: 500
        onTriggered: {
            stack.push(dialog)
        }
    }

    rightBarItem: NavigationBarRow {

        AppText {
            id: timerLabel
            width: dp(100)
            font.pixelSize: dp(20)
            font.weight: Font.Bold
            anchors.centerIn: parent
            color: "white"
        }
    }

    Column {
        id: col
        anchors.fill: parent
        spacing: (parent.height - cellSize * 5 - cellSize * 9) / 3 - 15
        anchors.margins: dp(2)
        property int cellSize: (wdth - 14) / 11

        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            width: wdth
            height: col.cellSize * 8 + 10
            color: "transparent"

            Grid {
                id: gr
                anchors.left: parent.left
                anchors.right: parent.right

                rows: 8
                columns: 11

                spacing: dp(1)

                Repeater {
                    model: 88

                    Rectangle {
                        width: col.cellSize
                        height: col.cellSize

                        property var params: levelData[Math.floor(index / 11)][index % 11].split(" ")
                        property int currentQuestion: 1

                        color: params[0] ? "lightblue" : "transparent"
                        radius: dp(5)

                        Text {
                            text: answers[index]
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                onFieldGridClicked(parent)
                            }

                            onPressed: {
                                pressTimer.start()
                            }

                            onReleased: {
                                pressTimer.stop()
                            }

                            onCanceled: {
                                pressTimer.stop()
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            width: wdth
            height: col.cellSize
            color: "transparent"

            Row {
                width: wdth
                height: parent.height

                AppButton {
                    anchors.left: parent.left
                    minimumWidth: dp(50)
                    minimumHeight: col.cellSize
                    width: dp(50)
                    height: col.cellSize

                    iconType: IconType.angleleft

                    onClicked: {
                        onLeftButtonClicked()
                    }
                }

                AppText {
                    text: curText
                    width: wdth - 100
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    wrapMode: Text.WordWrap
                    font.pixelSize: dp(17)
                }

                AppButton {
                    anchors.right: parent.right
                    minimumWidth: dp(50)
                    minimumHeight: col.cellSize
                    width: dp(50)
                    height: col.cellSize

                    iconType: IconType.angleright

                    onClicked: {
                        onRightButtonClicked()
                    }
                }
            }
        }

        Rectangle {
            width: wdth
            height: col.cellSize * 1.5
            color: "white"

            Grid {
                id: enterGr
                spacing: dp(1)
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.centerIn: parent

                rows: 1

                Repeater {
                    id: repeater
                    model: 7

                    Rectangle {
                        width: col.cellSize * 1.5
                        height: col.cellSize * 1.5
                        radius: dp(5)
                        color: "lightblue"

                        Text {
                            text: curWord[index]
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                onEnterGridClicked(index)
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            width: wdth
            height: col.cellSize * 3
            color: "white"

            Grid {
                id: lettersGrid
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.centerIn: parent

                rows: 2
                columns: 7

                spacing: dp(1)

                Repeater {
                    model: 14

                    Rectangle {
                        width: col.cellSize * 1.5
                        height: col.cellSize * 1.5
                        color: "lightblue"
                        radius: dp(5)

                        Text {
                            text: letters[index]
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                onLettersGridClicked(index)
                            }
                        }
                    }
                }
            }
        }
    }

    Row {
        id: row

        anchors.fill: parent
        spacing: (parent.height - cellSize * 5 - cellSize * 9) / 3 - 15
        anchors.margins: dp(2)
        property int cellSize: ((wdth - 14) / 11) * 1.5

        anchors.verticalCenter: parent.verticalCenter

        Column {
            width: wdth * 1.6
            anchors.top: parent.top
            anchors.topMargin: (parent.height - parent.cellSize * 7) / 2

            Rectangle {
                width: wdth * 1.5
                height: (row.cellSize * 8 + 10) * 1.5
                color: "transparent"

                Grid {
                    id: hgr
                    anchors.left: parent.left
                    anchors.right: parent.right

                    rows: 8
                    columns: 11

                    spacing: dp(1)

                    Repeater {
                        model: 88

                        Rectangle {
                            width: col.cellSize * 1.2
                            height: col.cellSize * 1.2

                            property var params: levelData[Math.floor(index / 11)][index % 11].split(" ")
                            property int currentQuestion: 1

                            color: params[0] ? "lightblue" : "transparent"
                            radius: dp(5)

                            Text {
                                text: answers[index]
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    onFieldGridClicked(parent)
                                }

                                onPressed: {
                                    pressTimer.start()
                                }

                                onReleased: {
                                    pressTimer.stop()
                                }

                                onCanceled: {
                                    pressTimer.stop()
                                }
                            }
                        }
                    }
                }
            }
        }

        Column {
            width: wdth
            spacing: (parent.height - parent.cellSize * 5) / 3 - 15
            anchors.margins: dp(2)
            anchors.top: parent.top
            anchors.topMargin: (parent.height - parent.cellSize * 4 - 2 * spacing) / 2

            Rectangle {
                width: wdth
                height: col.cellSize
                color: "transparent"

                Row {
                    width: wdth
                    height: parent.height

                    AppButton {
                        anchors.left: parent.left
                        minimumWidth: dp(50)
                        minimumHeight: col.cellSize
                        width: dp(50)
                        height: col.cellSize

                        iconType: IconType.angleleft

                        onClicked: {
                            onLeftButtonClicked()
                        }
                    }

                    AppText {
                        text: curText
                        width: wdth - 100
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: dp(12)
                    }

                    AppButton {
                        anchors.right: parent.right
                        minimumWidth: dp(50)
                        minimumHeight: col.cellSize
                        width: dp(50)
                        height: col.cellSize

                        iconType: IconType.angleright

                        onClicked: {
                            onRightButtonClicked()
                        }
                    }
                }
            }

            Rectangle {
                width: wdth
                height: col.cellSize * 1.5
                color: "white"

                Grid {
                    id: henterGr
                    spacing: dp(1)
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.centerIn: parent

                    rows: 1

                    Repeater {
                        id: hrepeater
                        model: 7

                        Rectangle {
                            width: col.cellSize * 1.5
                            height: col.cellSize * 1.5
                            radius: dp(5)
                            color: "lightblue"

                            Text {
                                text: curWord[index]
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    onEnterGridClicked(index)
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: wdth
                height: col.cellSize * 3
                color: "white"

                Grid {
                    id: hlettersGrid
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.centerIn: parent

                    rows: 2
                    columns: 7

                    spacing: dp(1)

                    Repeater {
                        model: 14

                        Rectangle {
                            width: col.cellSize * 1.5
                            height: col.cellSize * 1.5
                            color: "lightblue"
                            radius: dp(5)

                            Text {
                                text: letters[index]
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    onLettersGridClicked(index)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function adjustLayoutForOrientation() {
        if (width > height) {
            row.visible = true;
            col.visible = false;
        } else {
            col.visible = true;
            row.visible = false;
        }
    }

    function onFieldGridClicked(obj) {

        if(obj.params.length === 3)
            if(obj.currentQuestion === 1)
                obj.currentQuestion++;
            else
                obj.currentQuestion--;

        while(questions[cur] !== obj.params[obj.currentQuestion])
            if(cur < questions.length - 1)
                cur++
            else
                cur = 0

        updateColor(obj.params[obj.currentQuestion])
    }

    function onLeftButtonClicked() {

        if(finishedQuestions.length !== questions.length) {
            do {
                if(cur > 0)
                    cur--
                else
                    cur = questions.length - 1
            } while(finishedQuestions.includes(questions[cur]))

            updateColor(questions[cur])
        }
    }

    function onRightButtonClicked() {

        if(finishedQuestions.length !== questions.length) {
            do {
                if(cur < questions.length - 1)
                    cur++
                else
                    cur = 0
            } while(finishedQuestions.includes(questions[cur]))

            updateColor(questions[cur])
        }
    }

    function onEnterGridClicked(index) {

        if(curWord[index]) {

            for(var i = 0; i < 14; i++) {

                if(!letters[i]) {

                    if(curWordIndex === curAnswer.length)
                        for(var l = 0; l < curAnswer.length; l++) {
                            henterGr.children[l].color = "lightblue"
                            enterGr.children[l].color = "lightblue"
                        }

                    lettersGrid.children[i].color = "lightblue"
                    hlettersGrid.children[i].color = "lightblue"

                    letters[i] = curWord[index]
                    curWord[index] = ""
                    curWordIndex--

                    letters = letters.concat("")
                    letters.pop()
                    curWord = curWord.concat("")
                    curWord.pop()

                    break;
                }
            }
        }
    }

    function onLettersGridClicked(index) {

        if(letters[index]) {

            if(curWordIndex < curAnswer.length) {

                for(var i = 0; i < curAnswer.length; i++) {

                    if(!curWord[i]) {
                        hlettersGrid.children[index].color = "transparent"
                        lettersGrid.children[index].color = "transparent"

                        curWord.splice(i, 1)
                        curWord.splice(i, 0, letters[index])

                        curWord = curWord.concat("")
                        curWord.pop()
                        curWordIndex++
                        letters.splice(index, 1)
                        letters.splice(index, 0, "")

                        letters = letters.concat("")
                        letters.pop()

                        if(curWordIndex === curAnswer.length) {

                            var totalAns = ""

                            for(var j = 0; j < curAnswer.length; j++)
                                totalAns += curWord[j]

                            if(totalAns === curAnswer) {

                                var q = questions[cur]

                                var a,b
                                a = parseInt(q[1])
                                if(q[0] === "v") {

                                    b = parseInt(q[2] + q[3]);

                                    for(var l = 0; a < 8 && levelData[a][b]; a++, l++) {

                                        answers[a * 11 + b] = curAnswer[l]
                                    }

                                } else {

                                    b = parseInt(q[2]);

                                    for(var m = 0; b < 11 && levelData[a][b]; b++, m++) {

                                        answers[a * 11 + b] = curAnswer[m]
                                    }

                                }
                                answers = answers.concat("")
                                answers.pop()

                                finishedQuestions = finishedQuestions.concat(questions[cur])

                                if(finishedQuestions.length === questions.length) {
                                    timer.stop()

                                    salutImage.visible = true
                                    salutText.visible = true
                                    audio.play()
                                    salutTimer.start()

                                    endGame(timerLabel.text, hints)
                                }
                                else {

                                    do {
                                        if(cur < questions.length - 1)
                                            cur++
                                        else
                                            cur = 0
                                    } while(finishedQuestions.includes(questions[cur]))

                                    updateColor(questions[cur])
                                }
                            }
                            else {
                                fail.play()

                                for(var k = 0; k < curAnswer.length; k++) {
                                    enterGr.children[k].color = "red"
                                    henterGr.children[k].color = "red"
                                }
                            }

                        }
                        break
                    }
                }
            }
        }
    }

    function updateColor(q) {

        curWord = ["", "", "", "", "", "", ""]
        letters = ["", "", "", "", "", "", "", "", "", "", "", "", "", ""]
        curAnswer = ""
        curWordIndex = 0

        if(prevQuestion)
            colorQuestion(prevQuestion, "lightblue")
        colorQuestion(q, "blue")
        curText = levelData["?"][q]
        updateLetters(q)
        prevQuestion = q
        updateField(curAnswer.length)
    }

    function updateLetters(q) {

        var i, j, x;

        i = parseInt(q[1])
        if(q[0] === "v") {

            j = parseInt(q[2] + q[3]);

            for(x = 0; i < 8 && levelData[i][j]; i++, x++) {
                letters.splice(x, 1)
                letters.splice(x, 0, levelData[i][j].split(" ")[0])
                curAnswer += levelData[i][j].split(" ")[0]
                curWord.splice(x, 1)
                curWord.splice(x, 0, answers[i * 11 + j])

                if(curWord[x])
                    curWordIndex++
            }
        } else {

            j = parseInt(q[2]);

            for(x = 0; j < 11 && levelData[i][j]; j++, x++) {
                letters.splice(x, 1)
                letters.splice(x, 0, levelData[i][j].split(" ")[0])
                curAnswer += levelData[i][j].split(" ")[0]
                curWord.splice(x, 1)
                curWord.splice(x, 0, answers[i * 11 + j])

                if(curWord[x])
                    curWordIndex++
            }
        }

        curWord = curWord.concat("")
        curWord.pop()

        for(var b = 0; b < 14; b++) {
            lettersGrid.children[b].color = "lightblue"
            hlettersGrid.children[b].color = "lightblue"
        }

        let russianAlphabet = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ".split('');
        let availableLetters = russianAlphabet.filter(letter => !letters.includes(letter));
        let newLetters = [];

        var t = x
        while (t++ < 14) {
            let randomIndex = Math.floor(Math.random() * availableLetters.length);
            let letter = availableLetters[randomIndex];

            newLetters.push(letter);
            availableLetters.splice(randomIndex, 1);
        }

        for(var a = 0; a < newLetters.length; a++, x++) {
            letters.splice(x, 1)
            letters.splice(x, 0, newLetters[a])
        }

        letters.sort(() => Math.random() - 0.5);

        letters = letters.concat("")
        letters.pop()
    }

    function updateField(size) {

        repeater.model = size
        hrepeater.model = size

        for(var l = 0; l < size; l++) {
            enterGr.children[l].color = "lightblue"
            henterGr.children[l].color = "lightblue"
        }
    }

    function colorQuestion(q, c) {

        var i, j, temp;

        i = parseInt(q[1])
        if(q[0] === "v") {

            j = parseInt(q[2] + q[3]);

            for( ;i < 8 && levelData[i][j]; i++) {
                gr.children[i * 11 + j].color = c
                hgr.children[i * 11 + j].color = c
            }
        } else {

            j = parseInt(q[2]);

            for( ;j < 11 && levelData[i][j]; j++) {
                gr.children[i * 11 + j].color = c
                hgr.children[i * 11 + j].color = c
            }
        }
    }
}
