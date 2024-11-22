
import QtQuick 2.15
import QtQuick.Controls 2.15

Window {
    width: 400
    height: 600
    visible: true

    property int weatherState: 0 // 0: Clear, 1: Frosty, 2: Hot
        property bool isWeatherCycling: false // Control cycling state

        // Array to store weather-related data
    property var weatherData: [
           { degrees: "+32°", degreeColor: "#fff5b8", text: "Hot", place: "Ankara", color: "#f7a526", bgGradient: ["#ffbd3f", "#fff097"], groundColors: [["#f8eaae", "#e6c47b"], ["#f8eaae", "#e6c47b"]], timeColor: "#f7a526" },
           { degrees: "+24°", degreeColor: "#4f787d", text: "Clear", place: "Madrid", color: "#6a4c6d", bgGradient: ["#0F2129", "#47334A"], groundColors: [["#2f2b3c", "#091B21"], ["#2f2b3c", "#091B21"]], timeColor: "white" },
           { degrees: "-13°", degreeColor: "#a8ddff", text: "Frosty", place: "Moscow", color: "#4497bf", bgGradient: ["#29386f", "#b8f5ff"], groundColors: [["#f3ffff", "#9af2ff"], ["#f3ffff", "#9af2ff"]], timeColor: "black" }
       ]


    function resetMoonState() {
        moonCanvas1.visible = false;
        repeaterContainer.visible = false;
        repeaterVisible = false;
        moonCanvas1.x = initialX;
        moonCanvas1.y = initialY;
    }



        function startWeatherCycle() {
            isWeatherCycling = true;

            resetMoonState();

            sun.state = "toMoon";
               startAnimation.running = true;
               startAnimation.start();

               startAnimation.onStopped.connect(function() {
                   sun.state = "toFrostySun";
                   repeaterContainer.visible = false;
               });

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
                degrees.color=currentWeather.degreeColor;
                dateTimeDisplay.color=currentWeather.timeColor;

                // Update  gradient
                         backgroundGradient.stops[0].color = currentWeather.bgGradient[0];
                         backgroundGradient.stops[1].color = currentWeather.bgGradient[1];
                          ground1.color1 = currentWeather.groundColors[0][0];
                          ground1.color2 = currentWeather.groundColors[0][1];
                          ground2.color1 = currentWeather.groundColors[1][0];
                          ground2.color2 = currentWeather.groundColors[1][1];


                // Update Sun State Animation based on weatherState
                       if (weatherState === 0 && sun.state !== "default") {
                           sun.state = "default";
                       } else if (weatherState === 1 && sun.state !== "toMoon") {
                           sun.state = "toMoon";
                       } else if (weatherState === 2 && sun.state !== "toFrostySun") {
                           sun.state = "toFrostySun";
                       }

                       console.log("Weather updated to state:", weatherState, "Sun state:", sun.state);
                     }}
    // Backgrounds
        // Dynamic background gradient
         Rectangle {
             id: background
             anchors.fill: parent
             gradient: Gradient {
                 id: backgroundGradient
                 GradientStop { position: 0; color: weatherData[weatherState].bgGradient[0] }
                 GradientStop { position: 1; color: weatherData[weatherState].bgGradient[1] }
             }
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
            color: "#fff5b8"
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

    Rectangle {
        id: sun
        x: 290
        y: 210
        width: 75
        height: 75
        radius: 40
        color: "#ffdb50"
        opacity: 0.8

        MouseArea {
            id: clickArea
            anchors.fill: parent
            property bool clicked: false // Flag to track if it has been clicked

            onClicked: {
                if (!clicked) {
                    console.log("MouseArea clicked");
                    clicked = true; // Prevent further clicks
                    startWeatherCycle();
                } else {
                    console.log("MouseArea already clicked. Ignoring...");
                }
            }
            hoverEnabled: true
        }

        states: [
            State {
                name: "default"
            },
            State {
                name: "toFrostySun"
                PropertyChanges {
                    target: sun
                    x: 250
                    y: 650
                    width: 75
                    height: 75
                    radius: 40
                    color: "#feffdf"
                    opacity: 0.9
                }
            },
            State {
                name: "toMoon"
                PropertyChanges {
                    target: sun
                    x: 100
                    y: 400
                    width: 1
                    height: 1
                    radius: 40
                    color: "#594e4b"
                    opacity: 0.1
                }
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "toMoon"
                NumberAnimation { properties: "x,y"; duration: 1000; easing.type: Easing.OutExpo }
                ColorAnimation { properties: "color"; duration: 1000; easing.type: Easing.OutExpo }
            },
            Transition {
                from: "toMoon"
                to: "toFrostySun"
                NumberAnimation { properties: "x,y"; duration: 800; easing.type: Easing.OutExpo }
                ColorAnimation { properties: "color"; duration:800; easing.type: Easing.OutExpo }
                ScriptAction {
                    script: {
                        repeaterContainer.visible = false;
                    }
                }
            },
            Transition {
                from: "toFrostySun"
                to: "default"
                NumberAnimation { properties: "x,y"; duration: 1000; easing.type: Easing.OutExpo }
                ColorAnimation { properties: "color"; duration: 1000; easing.type: Easing.OutExpo }
            }
        ]
    }

    Rectangle {
        id: frostyIcon
        x: 250
        y: 650
        width: 75
        height: 75
        radius: 40
        color: "#feffdf"
        opacity: 0.8
        visible: false

        // Timer to control appearance delay for smoother transition
        Timer {
            id: frostyTimer
            interval: 600
            repeat: false
            onTriggered: {
                if (sun.state === "toFrostySun") {
                    frostyIcon.visible = true;
                    console.log("Frosty icon set visible.");
                }
            }
        }

        Connections {
            target: sun
            onStateChanged: {
                console.log("Sun state changed to:", sun.state);

                if (sun.state === "toFrostySun") {
                    frostyTimer.start(); // Start the timer for delayed visibility
                } else {
                    frostyIcon.visible = false;
                    frostyTimer.stop();
                    console.log("Frosty icon hidden.");
                }
            }
        }

        // Frosty repeater
        Repeater {
            id: frostyRepeater
            model: 3
            Rectangle {
                width: 95 + index * 20
                height: 95 + index * 20
                anchors.centerIn: parent
                radius: width / 2
                color: "#feffdf"
                opacity: 0.2 - index * 0.05
            }
            onItemAdded: console.log("Frosty repeater item added:", index);
            onItemRemoved: console.log("Frosty repeater item removed:", index);
        }
    }

    // Integrated moon animation
    Canvas {
        id: moonCanvas1
        width: 70
        height: 70
        x: initialX
        y: initialY
        visible: false

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

    Item {
        id: repeaterContainer
        width: 400
        height: 800
        visible: false

        Timer {
            id: moonTimer
            interval: 440
            repeat: false
            onTriggered: repeaterContainer.visible = (sun.state === "toMoon")
        }

        Connections {
            target: sun
            onStateChanged: {
                console.log("Sun state changed to:", sun.state);

                if (sun.state === "toMoon") {
                    moonCanvas1.visible = true;
                    repeaterContainer.visible = true;
                    if (!startAnimation.running) {
                        startAnimation.start(); // Ensure animation restarts
                    }
                } else if (sun.state === "toFrostySun" || sun.state === "default") {
                    resetMoonState();
                }
            }
        }



        Repeater {
            id: repeater
            model: 3
            Rectangle {
                width: 85 + index * 20
                height: 85 + index * 20
                x: moonCanvas1.x - (width / 2) + 35
                y: moonCanvas1.y - (height / 2) + 35
                radius: width / 2
                color: "#594e4b"
                opacity: 0.4 - index * 0.05
            }
        }
    }

    property real initialX: 290
    property real initialY: 210
    property real destinationX: 100
    property real destinationY: 400
    property real finalX: 250
    property real finalY: 650
    property bool repeaterVisible: false

    SequentialAnimation {
        id: startAnimation
        running: false
        loops: 1
        onRunningChanged: {
            if (startAnimation.running) {
                console.log("Moon animation starting");
            }
        }

        ParallelAnimation {
            PropertyAnimation {
                target: moonCanvas1
                property: "x"
                from: initialX
                to: destinationX
                duration: 1000
                easing.type: Easing.InOutQuad
            }
            PropertyAnimation {
                target: moonCanvas1
                property: "y"
                from: initialY
                to: destinationY
                duration: 1000
                easing.type: Easing.InOutQuad
            }
        }

        PauseAnimation { duration: 2000 } // Optional pause for effect

        onStopped: {
            console.log("Moon animation completed");
            // Reset moon for the next cycle
            moonCanvas1.x = initialX;
            moonCanvas1.y = initialY;
            moonCanvas1.visible = false;

            // Advance the cycle
            sun.state = weatherState === 1 ? "toFrostySun" : "default"; // Prepare the next state
        }
    }



/*
  Rectangle {
        id: sun
        x: 290
        y: 210
        width: 75; height: 75; radius: 40
        color: "#ffdb50"
        opacity: 0.8



        MouseArea {
                id: clickArea
                anchors.fill: parent
                property bool clicked: false // Flag to track if it has been clicked

                  onClicked: {
                      if (!clicked) {
                          console.log("MouseArea clicked");
                          clicked = true; // Prevent further clicks
                          startWeatherCycle();
                      } else {
                          console.log("MouseArea already clicked. Ignoring...");
                      }
                  }
                hoverEnabled: true
            }

        states: [
            State {
                name: "default"
            },

            State {
                name: "toFrostySun"
                PropertyChanges {
                    target: sun
                    x: 250
                    y: 650
                    width: 75; height: 75; radius: 40
                    color: "#feffdf"
                    opacity: 0.6
                }
            },
            State {
                name: "toMoon"
                PropertyChanges {
                    target: sun
                    x: 70
                    y: 400
                    width: 75; height: 75; radius: 40
                    color: "#594e4b"
                    opacity: 0.2
                }
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "toMoon"
                NumberAnimation { properties: "x,y"; duration: 1000; easing.type: Easing.OutExpo }
                ColorAnimation { properties: "color"; duration: 1000; easing.type: Easing.OutExpo }
            },
            Transition {
                from: "toMoon"
                to: "toFrostySun"
                NumberAnimation { properties: "x,y"; duration: 1000; easing.type: Easing.OutExpo }
                ColorAnimation { properties: "color"; duration: 1000; easing.type: Easing.OutExpo }
            },
            Transition {
                from: "toFrostySun"
                to: "default"
                NumberAnimation { properties: "x,y"; duration: 1000; easing.type: Easing.OutExpo }
                ColorAnimation { properties: "color"; duration: 1000; easing.type: Easing.OutExpo }
            }
        ]
    }


      Rectangle {
        id: frostyIcon
        x: 250
        y: 650
        width: 75; height: 75; radius: 40
        color: "#feffdf"
        opacity: 0.8
        visible: false


        Timer {
            id: frostyTimer
            interval: 570
            repeat: false
            onTriggered: frostyIcon.visible = (sun.state === "toFrostySun")
        }

        Connections {
            target: sun
            onStateChanged: {
                if (sun.state !== "toFrostySun") {
                    frostyIcon.visible = false;
                    frostyTimer.stop();
                } else {
                    frostyTimer.start();
                }
            }
        }

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

 Rectangle {
        id: moonIcon
        x: 100
        y: 400
        height: 75
        visible: false

        Timer {
            id: moonTimer
            interval: 440
            repeat: false
            onTriggered: moonIcon.visible = (sun.state === "toMoon")
        }

        Connections {
            target: sun
            onStateChanged: {

                if (sun.state !== "toMoon") {
                    moonIcon.visible = false;
                    moonTimer.stop();
                } else {
                    moonTimer.start();
                }
            }
        }

        // Moon Canvas
        Canvas {
            id: moonCanvas1
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

*/

 // Ground 1
    Rectangle {
        id: ground1
        width: 600
        height: 400
        radius: 100
        x: -50
        y: parent.height - 100
        z: 2
        rotation: 15

        property color color1: "#f8eaae"
        property color color2: "#e6c47b"

        gradient: Gradient {
            GradientStop { position: 0; color: ground1.color1 }
            GradientStop { position: 1; color: ground1.color2 }
        }
    }

    // Ground 2
    Rectangle {
        id: ground2
        width: 600
        height: 400
        radius: 70
        x: parent.width - width + 60
        y: parent.height - 100
        z: 2
        rotation: -8

        property color color1: "#f8eaae"
        property color color2: "#e6c47b"

        gradient: Gradient {
            GradientStop { position: 0; color: ground2.color1 }
            GradientStop { position: 1; color: ground2.color2 }
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
             color: "#f7a526"
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





