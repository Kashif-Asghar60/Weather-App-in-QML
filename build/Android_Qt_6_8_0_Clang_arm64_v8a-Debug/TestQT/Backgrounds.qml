// Backgrounds.qml
import QtQuick 2.15

Item {
    id: backgrounds
    anchors.fill: parent

    // Night background
    Rectangle {
        id: nightBg
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#0F2129" }
            GradientStop { position: 1; color: "#47334A" }
        }
        opacity: 0
    }

    // Frosty background
    Rectangle {
        id: frostyBg
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#29386f" }
            GradientStop { position: 1; color: "#b8f5ff" }
        }
        opacity: 0
    }

    // Sunny background
    Rectangle {
        id: sunnyBg
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#ffbd3f" }
            GradientStop { position: 1; color: "#fff097" }
        }
        opacity: 1
    }

    function updateBackground(state) {
        nightBg.opacity = state === 2 ? 1 : 0
        frostyBg.opacity = state === 1 ? 1 : 0
        sunnyBg.opacity = state === 0 ? 1 : 0
    }
}
