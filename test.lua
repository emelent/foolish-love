local MAX_VERTICES = 100 -- Define this constant as needed

function pointInPolygon(p, vs, vc)
	local inside = false
	for i = 1, vc do
		local j = i == 1 and vc or i - 1
		local vi = vs[i]
		local vj = vs[j]
		local intersect = ((vi.y > p.y) ~= (vj.y > p.y)) and (p.x < (vj.x - vi.x) * (p.y - vi.y) / (vj.y - vi.y) + vi.x)
		if intersect then
			inside = not inside
		end
	end
	return inside
end

function getLeftMostVertex(vs, vc)
	local result = vs[1]
	for i = 2, vc do
		local v = vs[i]
		if v.x < result.x then
			result = v
		end
	end
	return result
end

function getRightMostVertex(vs, vc)
	local result = vs[1]
	for i = 2, vc do
		local v = vs[i]
		if v.x > result.x then
			result = v
		end
	end
	return result
end

function getTopMostVertex(vs, vc)
	local result = vs[1]
	for i = 2, vc do
		local v = vs[i]
		if v.y < result.y then
			result = v
		end
	end
	return result
end

function getBottomMostVertex(vs, vc)
	local result = vs[1]
	for i = 2, vc do
		local v = vs[i]
		if v.y > result.y then
			result = v
		end
	end
	return result
end

function getPosIndex(value, min_v, max_v)
	if value > max_v then
		return 1
	end

	if value < min_v then
		return -1
	end

	return 0
end

function len(p1, p2)
	local diff = { x = p2.x - p1.x, y = p2.y - p1.y }
	return math.sqrt(diff.x * diff.x + diff.y * diff.y)
end

function getAngleBetween(p1, p2)
	local hyp = len(p1, p2)
	local adj = len(p1, { x = p2.x, y = p1.y })
	local n = adj / hyp
	-- Clamp n to [-1, 1] to avoid domain errors
	n = math.max(-1, math.min(1, n))
	return math.acos(n)
end

function isPointWithinShadow(l, p, vs, vc)
	local leftMostV = getLeftMostVertex(vs, vc)
	local rightMostV = getRightMostVertex(vs, vc)
	local topMostV = getTopMostVertex(vs, vc)
	local bottomMostV = getBottomMostVertex(vs, vc)
	local posIndex = {
		x = getPosIndex(l.x, leftMostV.x, rightMostV.x),
		y = getPosIndex(l.y, topMostV.y, bottomMostV.y),
	}
	-- light is in top center above object
	if posIndex.x == 0 and posIndex.y == -1 then
		local v = rightMostV
		-- p is on the left side of light
		if p.x < l.x then
			v = leftMostV
		end
		local min_theta = getAngleBetween(l, v)
		-- calculate angle between l and p
		local theta = getAngleBetween(l, p)
		return theta > min_theta
	end
	return false
end
function printV(v)
	print(string.format("{x=%f, y=%f}", v.x, v.y))
end

local verts = { { x = 0, y = 0 }, { x = 0, y = 8 }, { x = 8, y = 8 }, { x = 8, y = 0 } }
local l = { x = 4, y = -2 }
local p1 = { x = 3, y = 3 }
local p2 = { x = -0.5, y = 7 }
local p3 = { x = -18.5, y = 7 }
local p4 = { x = 12.5, y = 2 }
local pBot = { x = 2, y = 10 }

print("pBot", isPointWithinShadow(l, pBot, verts, #verts))
print("p1", isPointWithinShadow(l, p1, verts, #verts))
print("p2", isPointWithinShadow(l, p2, verts, #verts))
print("p3", isPointWithinShadow(l, p3, verts, #verts))
print("p4", isPointWithinShadow(l, p4, verts, #verts))
