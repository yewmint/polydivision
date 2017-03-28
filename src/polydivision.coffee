{ Point, Vertex, Polygon, Vector, Segment, crossProduct, vecFromSeg } = require("./geometry.coffee")
getVec = require("./geometry.coffee").createVectorFrom2Points

Painter = require("./painter.coffee")
painter = new Painter("wrapper", 640, 480)

outbox = new Polygon([
  new Point(0, 0)
  new Point(640, 0)
  new Point(640, 480)
  new Point(0, 480)
])

polygon = new Polygon([
  new Point(253, 358)
  new Point(27, 191)
  new Point(87, 33)
  new Point(260, 121)
  new Point(460, 95)
  new Point(427, 121)
  new Point(548, 197)
])

slicePolyA = (poly)->
  stack = []
  for vtx in poly.vertexes
    s0 = vtx.segOut
    s1 = s0.vertexB.segOut
    sxExcept = []
    for sx in stack
      vx = vecFromSeg(sx)
      tvec = getVec(sx.vertexB.point, s1.vertexB.point)
      if crossProduct(vx, tvec).z > 0
        sxExcept.push sx
        newSeg = new Segment(sx.vertexB, s1.vertexB)
        painter.paintSeg(newSeg)
    for sx in sxExcept
      stack.forEach (e, idx, arr)->
        if sx is e
          arr.splice(idx, 1)
    v0 = vecFromSeg(s0)
    v1 = vecFromSeg(s1)
    if crossProduct(v0, v1).z < 0
      stack.push s0

slicePolyB = (poly)->
  stack = []
  for vtx in poly.vertexes
    s0 = vtx.segOut
    s1 = s0.vertexB.segOut
    sxExcept = []
    while stack.length > 0
      sx = stack.pop()
      vx = vecFromSeg(sx)
      tvec = getVec(sx.vertexB.point, s1.vertexB.point)
      if crossProduct(vx, tvec).z > 0
        newSeg = new Segment(sx.vertexB, s1.vertexB)
        painter.paintSeg(newSeg)
      else
        stack.push sx
        break
    v0 = vecFromSeg(s0)
    v1 = vecFromSeg(s1)
    if crossProduct(v0, v1).z < 0
      stack.push s0

window.repaint = ()->
  painter.clear()
  painter.paintPolygon(outbox)
  painter.paintPolygon(polygon)

window.sliceA = ()->
  slicePolyA(polygon)

window.sliceB = ()->
  slicePolyB(polygon)

window.repaint()
