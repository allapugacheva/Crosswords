import QtQuick
import Felgo
import "../model"

AppPage {

    title: qsTr("Кроссворды")

    property var dm
    property int topIndex: -1

    rightBarItem: NavigationBarRow {

        IconButtonBarItem {
            iconType: IconType.user
            title: qsTr("Account statistics")
            onClicked: function() {

                stack.push(statisticsPage, {userData: dm.dataList})
            }
        }
    }

    Grid {
        anchors.fill: parent
        rowSpacing: dp(5)
        anchors.margins: dp(5)

        rows: Math.ceil(Object.keys(dm.levelsList).length / 4)
        columns: 4
        spacing: dp(5)

        Repeater {
            id: rep
            model: Object.keys(dm.levelsList).length

            Rectangle {
                width: dp((parent.width - dp(15)) / dp(4))
                height: dp(50)
                color: "lightblue"
                radius: dp(20)

                Text {
                    id: itemText
                    text: Object.keys(dm.levelsList)[index]
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {

                        stack.push(levelPage,{ levelData: dm.levelsList[Object.keys(dm.levelsList)[index]] })
                    }
                }
            }
        }
    }

    Component {
        id: levelPage

        LevelPage {

            onEndGame: function(time, hints) {

                if(parseInt(time) < parseInt(dm.dataList[0]))
                    dm.dataList[0] = time
                if(parseInt(time) > parseInt(dm.dataList[1]))
                    dm.dataList[1] = time
                dm.dataList[2] = (dm.dataList[2] * dm.dataList[4] + time) / (dm.dataList[4] + 1)
                dm.dataList[3] = dm.dataList[3] + hints
                dm.dataList[4] = dm.dataList[4] + 1
                dm.updateUser()
                //stack.pop()
            }
        }
    }

    Component {
        id: statisticsPage

        StatisticsPage {

        }
    }
}
