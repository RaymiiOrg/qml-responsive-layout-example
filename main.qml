/* Author: Remy van Elst, https://raymii.org
 * License: GNU AGPLv3
 */

import QtQuick 2.15
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0

import org.raymii.RoadObjectType 1.0

ApplicationWindow {
    id: root
    width: 650
    height: 480
    visible: true
    title: qsTr("QML ScrollView example")

    onWidthChanged: { console.log("Window Width changed: " + width) }
    onHeightChanged: { console.log("Window Height changed: " + height)}

    QtObject{
        id: internals
        readonly property string helpText: "C++ Qt/Qml example by [raymii.org](https://raymii.org).
Scrollview with a GridLayout that dynamically resizes
when the window size changes. License: GNU AGPLv3"}

    Text {
        id: helpText
        width: 150
        height: 60
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 5
        anchors.leftMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignLeft
        textFormat: TextEdit.MarkdownText
        text: internals.helpText
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
    }

    Text {
        id: infoText
        width: 150
        height: 20
        anchors.top: helpText.bottom
        anchors.left: parent.left
        anchors.topMargin: 5
        anchors.leftMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignLeft
        textFormat: TextEdit.MarkdownText
        text: "Rows: " + rowLayout.rows + ", Columns: " + rowLayout.columns
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
    }

    ScrollView {
        id: scroller
        readonly property int trafficLightWidth: 150
        anchors.top: infoText.bottom
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.topMargin: 5
        width: parent.width
        height: parent.height * 0.8
        clip : true
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        GridLayout{
            columns: Math.max(Math.floor(scroller.width / scroller.trafficLightWidth), 1)
            rows: Math.max(Math.ceil(children.length / columns), 1)

            Component.onCompleted: {
                console.log("length:" + children.length)
                console.log("columns:" + columns)
                console.log("rows:" + rows)
            }

            id: rowLayout
            rowSpacing: 5
            columnSpacing: rowSpacing

            Repeater{
                id: model
                model: 160
                Rectangle {
                    id: typeInstance
                    width: scroller.trafficLightWidth
                    height: 250
                    border.color: "pink"
                    Layout.alignment : Qt.AlignLeft | Qt.AlignTop

                    TrafficLightType {
                        id: trafficLightTypeInstance
                    }

                    Text {
                        id: typeText
                        width: parent.width
                        height: 20
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.topMargin: 5
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "TrafficLight #" + (index+1)
                        fontSizeMode: Text.Fit
                        font.pointSize: 10
                        minimumPointSize: 6
                        wrapMode: Text.WordWrap
                    }

                    TrafficLightQml {
                        id: trltype
                        width: 50
                        height: 140
                        anchors.top: typeText.bottom
                        anchors.left: parent.left
                        anchors.topMargin: 5
                        anchors.leftMargin: 50
                        redActive: trafficLightTypeInstance.lamp === TrafficLightType.Red;
                        orangeActive: trafficLightTypeInstance.lamp === TrafficLightType.Orange;
                        greenActive: trafficLightTypeInstance.lamp === TrafficLightType.Green;
                    }

                    TrafficLightQmlControlButtons {
                        id: trltypeControls
                        anchors.top: trltype.bottom
                        anchors.left: parent.left
                        anchors.topMargin: 5
                        anchors.leftMargin: 5
                        width: parent.width - 10
                        height: 60

                        onPowerStateChanged: { trafficLightTypeInstance.setPowerState(!trafficLightTypeInstance.powerState); }
                        onNextLamp: { trafficLightTypeInstance.nextLamp(); }
                        Component.onCompleted: {
                            // for our example, turn on some lights
                            Math.random() < 0.5  ? powerState = true : powerState = false
                        }
                        Timer {
                            // random interval between 2 and 15 seconds
                            interval: Math.floor((Math.random() * (15 - 2 + 1) + 2) * 1000)
                            running: true;
                            repeat: true
                            onTriggered: trltypeControls.nextLamp()
                        }
                    }
                }
            }
        }
    }
}
