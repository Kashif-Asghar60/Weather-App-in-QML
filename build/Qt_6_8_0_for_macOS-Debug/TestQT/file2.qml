

import QtQuick 2.15

Window {
    width: 400
    height: 600
    visible: true

    property int weatherState: 0 // 0: Clear, 1: Frosty, 2: Hot
    property bool isWeatherCycling: false // Control cycling state

    function startWeatherCycle() {
        isWeatherCycling = true;
        updateWeather();
    }

    function updateWeather() {
        if (isWeatherCycling) {
            weatherState = (weatherState + 1) % 3;

            degrees.text = weatherState === 0 ? "+32°" : weatherState === 1 ? "-13°" : "+24°";
            weather.text = weatherState === 0 ? "Hot" : weatherState === 1 ? "Frosty" : "Clear";
            place.text = weatherState === 0 ? "Ankara" : weatherState === 1 ? "Moscow" : "Madrid";
            place.color = weatherState === 0 ? "#f7a526" : weatherState === 1 ? "#4497bf" : "#6a4c6d";

            // Update icon animations
            sunGroup.state = weatherState === 0 ? "active" : "inactive";
            frostyGroup.state = weatherState === 1 ? "active" : "inactive";
            moonGroup.state = weatherState === 2 ? "active" : "inactive";
        }
    }

    // Fullscreen MouseArea
    MouseArea {
        id: fullScreenArea
        anchors.fill: parent
        onClicked: startWeatherCycle()
    }

    // Backgrounds
    Rectangle {
        id: nightBg
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#0F2129" }
            GradientStop { position: 1; color: "#47334A" }
        }
        opacity: weatherState === 2 ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 500 } }
    }

    Rectangle {
        id: frostyBg
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#29386f" }
            GradientStop { position: 1; color: "#b8f5ff" }
        }
        opacity: weatherState === 1 ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 500 } }
    }

    Rectangle {
        id: sunnyBg
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#ffbd3f" }
            GradientStop { position: 1; color: "#fff097" }
        }
        opacity: weatherState === 0 ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 500 } }
    }

    // Text container
    Column {
        id: textContainer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 50
        spacing: 2

        Text {
            id: degrees
            text: "+32°"
            font.pixelSize: 130
            font.bold: true
            font.family: "Arial, Helvetica, sans-serif"
            color: "#4F787D"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: place
            text: "Ankara"
            font.pixelSize: 24
            color: "#f7a526"
            font.family: "Arial, Helvetica, sans-serif"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: weather
            text: "Hot"
            font.pixelSize: 24
            color: "white"
            font.family: "Arial, Helvetica, sans-serif"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Sun group
    Item {
        id: sunGroup
        opacity: 1
        states: [
            State {
                name: "active"
                PropertyChanges { target: sunIcon; scale: 1.2; rotation: 0; opacity: 1 }
            },
            State {
                name: "inactive"
                PropertyChanges { target: sunIcon; scale: 0.8; rotation: 360; opacity: 0 }
            }
        ]
        transitions: Transition {
            NumberAnimation { properties: "scale, opacity, rotation"; duration: 500 }
        }
        anchors.top: textContainer.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 150
        anchors.topMargin: 10

        Rectangle {
            id: sunIcon
            width: 75; height: 75; radius: 40
            color: "#ffdb50"
            opacity: 0.8
        }
    }

    // Frosty group
    Item {
        id: frostyGroup
        opacity: 1
        states: [
            State {
                name: "active"
                PropertyChanges { target: frostyIcon; scale: 1.2; rotation: 0; opacity: 1 }
            },
            State {
                name: "inactive"
                PropertyChanges { target: frostyIcon; scale: 0.8; rotation: -360; opacity: 0 }
            }
        ]
        transitions: Transition {
            NumberAnimation { properties: "scale, opacity, rotation"; duration: 500 }
        }
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 150
        anchors.bottomMargin: 300

        Rectangle {
            id: frostyIcon
            width: 75; height: 75; radius: 40
            color: "#feffdf"
            opacity: 0.8
        }
    }

    // Moon group
    Item {
        id: moonGroup
        opacity: 1
        states: [
            State {
                name: "active"
                PropertyChanges { target: moonIcon; scale: 1.2; rotation: 0; opacity: 1 }
            },
            State {
                name: "inactive"
                PropertyChanges { target: moonIcon; scale: 0.8; rotation: 360; opacity: 0 }
            }
        ]
        transitions: Transition {
            NumberAnimation { properties: "scale, opacity, rotation"; duration: 500 }
        }
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 90
        anchors.bottomMargin: 300

        Rectangle {
            id: moonIcon
            width: 70; height: 70; radius: 35
            color: "#BCAE76"
            opacity: 0.8
        }
    }

    // Timer to handle the cycling of weather states
    Timer {
        interval: 3000
        running: isWeatherCycling
        repeat: true
        onTriggered: updateWeather()
    }

    // DateTime display
    Text {
        id: dateTimeDisplay
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        font.pixelSize: 14
        color: "white"
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                var date = new Date();
                dateTimeDisplay.text = date.toLocaleTimeString() + " | " + date.toLocaleDateString()
            }
        }
    }
}
