window.addEventListener('load', (event) => {
  const map = L.map('mapid', {
    crs: L.CRS.Simple
  })
  const bounds = [[0,0], [1000,1000]]
  const image = L.imageOverlay('uqm_map_full.png', bounds).addTo(map)

  const sol = L.latLng([ 145, 175.2 ])
  L.marker(sol).addTo(map)
  map.setView([70, 120], 1)
})
