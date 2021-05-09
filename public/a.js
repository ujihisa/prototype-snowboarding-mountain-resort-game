if (false) {
  window.addEventListener('load', (event) => {
    const map = L.map('mapid', {
      crs: L.CRS.Simple,
      minZoom: 0
    })
    const image =
      L.imageOverlay(
        'mountain.png',
        [[0, 0], [540, 960]]
      ).
      addTo(map)

    map.setView([540/2, 960/2], 0)

    const markers = []

    let polygon = null
    const updatePolygon = () => {
      if (polygon) {
        polygon.remove()
      }

      polygon = L.polygon(markers.map((m) => m.getLatLng())).addTo(map);
    }

    const icon = L.icon({
      iconUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Location_dot_black.svg/1024px-Location_dot_black.svg.png",
      iconSize: [15, 15]
    })

    map.on('click', (e) => {
      marker = L.marker(e.latlng, {draggable: true, icon: icon}).addTo(map)

      marker.on('move', (e) =>
        updatePolygon()
      )
      marker.on('contextmenu', (e) => {
        const removeMarker = markers.splice(markers.findIndex((m) => m == e.target), 1)[0]
        removeMarker.remove()
        updatePolygon()
      })

      markers.push(marker)

      updatePolygon()
    })
  })

} else {

  window.addEventListener('load', (event) => {
    const map = L.map('mapid', {
      crs: L.CRS.Simple,
      minZoom: 0
    })
    const image =
      L.imageOverlay(
        'mountain.png',
        [[0, 0], [540, 960]]
      ).
      addTo(map)

    map.setView([540/2, 960/2], 0)

    const markers = []

    let polyline = null
    let snowboarders = []

    const updatePolyline = () => {
      if (polyline) {
        polyline.remove()
      }

      polyline = L.polyline(markers.map((m) => m.getLatLng()), {weight: 1}).addTo(map);

      snowboarders.map((s) => s.remove())
      if (2 <= markers.length) {
        snowboarders = markers.slice(1).map((m, i) => {
          const snowborderIcon = L.icon({
            iconUrl: i % 2 == 0 ? "./snowboarder-healside.png" : "./snowboarder-toeside.png",
            iconSize: [30, 30]
          })
          const latlng = L.latLng(
            (m.getLatLng().lat + markers[i].getLatLng().lat) / 2,
            (m.getLatLng().lng + markers[i].getLatLng().lng) / 2)

          return L.marker(latlng, {icon: snowborderIcon}).addTo(map)
        })
      }
    }

    map.on('click', (e) => {
      const markerIcon = L.icon({
        iconUrl: (markers.length % 2 == 0) ?
          "https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/240/apple/279/down-left-arrow_2199-fe0f.png" :
          "https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/240/apple/279/down-right-arrow_2198-fe0f.png",
        iconSize: [15, 15]
      })

      marker = L.marker(e.latlng, {draggable: true, icon: markerIcon}).addTo(map)

      marker.on('move', (e) =>
        updatePolyline()
      )
      marker.on('contextmenu', (e) => {
        const removeMarker = markers.splice(markers.findIndex((m) => m == e.target), 1)[0]
        removeMarker.remove()
        updatePolyline()
      })

      markers.push(marker)

      updatePolyline()
    })

    document.getElementById('run').addEventListener('click', (e) => {
      if (snowboarders.length == 0) {
        alert("Make paths on the mountain first")
        return false
      }
      if (polyline) {
        polyline.remove()
      }
      markers.forEach((m) => m.remove())
      snowboarders.forEach((s) => s.remove())

      let i = 0
      let j = 0
      let snowboarder = null
      const timer = setInterval(() => {
        if (i + 1 < markers.length) {
          if (snowboarder)
            snowboarder.remove()

          const snowborderIcon = L.icon({
            iconUrl: i % 2 == 0 ? "./snowboarder-healside.png" : "./snowboarder-toeside.png",
            iconSize: [50, 50]
          })
          const latlng = L.latLng(
            (markers[i + 1].getLatLng().lat * j + markers[i].getLatLng().lat * (100 - j)) / 100,
            (markers[i + 1].getLatLng().lng * j + markers[i].getLatLng().lng * (100 - j)) / 100)

          snowboarder = L.marker(latlng, {icon: snowborderIcon}).addTo(map)
          if (j < 100) {
            ++j
          } else {
            j = 0
            ++i
          }
        } else {
          if (markers.length - 1 < i + 1) {
            console.log('done')
            clearInterval(timer)

            snowboarder.remove()
            markers.forEach((m) => m.addTo(map))
            updatePolyline()
            return
          }
        }
      }, 10)
    })
  })
}
