// WeatherText.qml
import QtQuick 2.15

Column {
    id: weatherText
    spacing: 10

    Text {
        id: degrees
        text: "+24°"
        font.pixelSize: 100
        font.bold: true
        color: "#4F787D"
    }

    Text {
        id: place
        text: "Madrid"
        font.pixelSize: 24
        color: "#694c6d"
    }

    Text {
        id: weather
        text: "Clear"
        font.pixelSize: 24
        color: "white"
    }

    function update(state) {
        degrees.text = state === 0 ? "+32°" : state === 1 ? "-13°" : "+24°"
        weather.text = state === 0 ? "Hot" : state === 1 ? "Frosty" : "Clear"
        place.text = state === 0 ? "Ankara" : state === 1 ? "Moscow" : "Madrid"
        place.color = state === 0 ? "#f7a526" : state === 1 ? "#6a4c6d" : "#4d7ea7"
    }
}
