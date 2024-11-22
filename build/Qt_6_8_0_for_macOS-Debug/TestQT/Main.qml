
import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    width: 400
    height: 600
    visible: true

    property int weatherState: 0 // 0: Clear, 1: Frosty, 2: Hot
        property bool isWeatherCycling: false // Control cycling state

        // Array to store weather-related data
        property var weatherData: [
            { degrees: "+32°", text: "Hot", place: "Ankara", color: "#f7a526", bgId: sunnyBg, groups: [sunGroup], ground: [ground1Sunny, ground2SunnyRight] },
            { degrees: "-13°", text: "Frosty", place: "Moscow", color: "#4497bf", bgId: frostyBg, groups: [frostyGroup], ground: [ground1Frosty, ground2FrostyRight] },
            { degrees: "+24°", text: "Clear", place: "Madrid", color: "#6a4c6d", bgId: nightBg, groups: [moonGroup], ground: [ground1Night, ground2NightRight] }
        ]

        function startWeatherCycle() {
            isWeatherCycling = true;
            updateWeather();
        }

        function updateWeather() {
            if (isWeatherCycling) {
                weatherState = (weatherState + 1) % weatherData.length;
                let currentWeather = weatherData[weatherState];

                // Update texts and colors
                degrees.text = currentWeather.degrees;
                weather.text = currentWeather.text;
                place.text = currentWeather.place;
                place.color = currentWeather.color;

                // Update backgrounds and opacity
                for (let i = 0; i < weatherData.length; i++) {
                    weatherData[i].bgId.opacity = (i === weatherState ? 1 : 0);
                    weatherData[i].ground.forEach(ground => ground.opacity = (i === weatherState ? 1 : 0));
                    weatherData[i].groups.forEach(group => {
                        group.opacity = (i === weatherState ? 1 : 0);
                        group.state = (i === weatherState ? "active" : "inactive");
                    });
                }
            }
        }
    // Backgrounds
    Rectangle {
        id: nightBg
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#0F2129" }
            GradientStop { position: 1; color: "#47334A" }
        }
        opacity: 0
    }

    Rectangle {
        id: frostyBg
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#29386f" }
            GradientStop { position: 1; color: "#b8f5ff" }
        }
        opacity: 0
    }

    Rectangle {
        id: sunnyBg
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#ffbd3f" }
            GradientStop { position: 1; color: "#fff097" }
        }
        opacity: 1
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

    // Sun group positioned on the right side of the screen
    Item {
        id: sunGroup
        opacity: 1
        anchors.top: textContainer.verticalCenter;
        anchors.right: parent.right;
        anchors.rightMargin: 70;
        anchors.topMargin: 10
        width: 100
        height: 100
        states: [
            State {
                name: "active"
                PropertyChanges { target: sunIcon; scale: 1.2; rotation: 0; opacity: 1 }
            },
            State {
                name: "inactive"
                PropertyChanges { target: sunIcon; scale: 0.7; rotation: 360; opacity: 0 }
            }
        ]
        transitions: Transition {
            NumberAnimation { properties: "scale, opacity, rotation"; duration: 500 }
        }

        Rectangle {
                   id: sunIcon
            width: 75; height: 75; radius: 40
            color: "#ffdb50"
            opacity: 0.8
            anchors.centerIn: parent


        }
        MouseArea {
                id: clickArea
                anchors.fill: parent
                onClicked: {
                    console.log("MouseArea clicked");
                    startWeatherCycle();
                }
                hoverEnabled: true
            }

    }

    Item {
        id: frostyGroup
        opacity: 0
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 150
        anchors.bottomMargin: 300

        states: [
            State {
                name: "active"
                PropertyChanges { target: frostyIcon; scale: 1.2; rotation: 0; opacity: 1 }
            },
            State {
                name: "inactive"
                PropertyChanges { target: frostyIcon; scale: 0.5; rotation: -360; opacity: 0 }
            }
        ]
        transitions: Transition {
            NumberAnimation { properties: "scale, opacity, rotation"; duration: 500 }
        }
        Rectangle {
            id: frostyIcon
            width: 75; height: 75; radius: 40
            color: "#feffdf"
            opacity: 0.8

            Repeater {
                model: 3
                Rectangle {
                    width: 95 + index * 20
                    height: 95 + index * 20
                    anchors.centerIn: parent
                    radius: width / 2
                    color: "#feffdf"
                    opacity: 0.2 - index * 0.05
                }
            }
        }
    }

    Item {
        id: moonGroup
        opacity: 0
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 90
        anchors.bottomMargin: 300


        Canvas {
            id: moonCanvas
            width: 70
            height: 70
            anchors.centerIn: parent

            onPaint: {
                var ctx = getContext("2d");

                ctx.clearRect(0, 0, width, height);

                ctx.fillStyle = "#BCAE76";
                ctx.beginPath();
                ctx.arc(35, 35, 35, 0, Math.PI * 2);
                ctx.fill();

                ctx.fillStyle = "#BCAE76";
                ctx.beginPath();
                ctx.arc(52, 30, 35, 0, Math.PI * 2);
                ctx.fill();

                ctx.globalCompositeOperation = "destination-out";
                ctx.beginPath();
                ctx.arc(52, 30, 35, 0, Math.PI * 2);
                ctx.fill();
            }

            Component.onCompleted: requestPaint();
        }

        states: [
            State {
                name: "active"
                PropertyChanges { target: moonCanvas; scale: 1.2; opacity: 1 }
            },
            State {
                name: "inactive"
                PropertyChanges { target: moonCanvas; scale: 0.9; opacity: 0 }
            }
        ]
        transitions: Transition {
            NumberAnimation { properties: "scale, opacity"; duration: 500 }
        }

        Repeater {
            model: 3
            Rectangle {

                width: 85 + index * 20
                height: 85 + index * 20
                anchors.centerIn: parent
                radius: width / 2
                color: "#594e4b"
                opacity: 0.4 - index * 0.05
            }
        }
    }

    Rectangle {
        id: ground1
        width: 500
        height: 150
        radius: 100
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        z: 2
        rotation: 10

        Rectangle {
            id: ground1Night
            anchors.fill: parent
            radius: 100

            gradient: Gradient {
                GradientStop { position: 0; color: "#091B21" }
                GradientStop { position: 1; color: "#2f2b3c" }
            }
            opacity: 0
        }

        Rectangle {
            id: ground1Frosty
            anchors.fill: parent
            radius: 100

            gradient: Gradient {
                GradientStop { position: 0; color: "#f3ffff" }
                GradientStop { position: 1; color: "#9af2ff" }
            }
            opacity: 0
        }

        Rectangle {
            id: ground1Sunny
            anchors.fill: parent
            radius: 70

            gradient: Gradient {
                GradientStop { position: 0; color: "#e0d7a4" }
                GradientStop { position: 1; color: "#e7c77a" }
            }
            opacity: 1
        }
    }

    Rectangle {
        id: ground2
        width: 500
        height: 150
        radius: 100
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        z: 2
        rotation: -10

        Rectangle {
            id: ground2NightRight
            anchors.fill: parent
            radius: 100

            gradient: Gradient {
                GradientStop { position: 0; color: "#091B21" }
                GradientStop { position: 1; color: "#2f2b3c" }
            }
            opacity: 0
        }

        Rectangle {
            id: ground2FrostyRight
            anchors.fill: parent
            radius: 100

            gradient: Gradient {
                GradientStop { position: 0; color: "#f3ffff" }
                GradientStop { position: 1; color: "#9af2ff" }
            }
            opacity: 0
        }

        Rectangle {
            id: ground2SunnyRight
            anchors.fill: parent
            radius: 70

            gradient: Gradient {
                GradientStop { position: 0; color: "#e0d7a4" }
                GradientStop { position: 1; color: "#e7c77a" }
            }
            opacity: 1
        }
    }

    // Timer to handle the cycling of weather states
    Timer {
        interval: 3000
        running: isWeatherCycling
        repeat: true
        onTriggered: updateWeather()
    }
    Text {
             id: dateTimeDisplay
             anchors.right: parent.right
             anchors.bottom: parent.bottom
             anchors.rightMargin: 10
             anchors.bottomMargin: 10
             font.pixelSize: 14
             color: "white"
             z:3
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


