class_name Sun
extends RefCounted
## Where the sun is, as seen from Melaka (about 2 degrees north, so the sun passes almost
## straight overhead). Gives the ground shadow of a vertical object as a screen vector per pixel
## of height: x = east (right), y = south (down). Pure maths, no nodes.
##
## Solar noon is 12:30, matching the sun on the HUD clock: sunrise about 6:30, sunset about
## 18:30, Asar about 15:30-16:00 depending on the season.

const SOLAR_NOON := 12.5          ## hours
## Sun declination per season (Kemarau, Musim Buah, Tengkujuh), degrees. Positive = sun north
## of overhead, so shadows fall south (down the screen); negative = shadows fall north (up).
const DECLINATION := [18.0, 6.0, -18.0]
## The ground is drawn foreshortened in the low top-down view, so north/south lengths shrink.
const GROUND_Y := 0.6
## A shadow straight east or west would be a flat line in this view; keep a little depth.
const MIN_Y := 0.12
## Longest shadow, in object heights (the low morning and evening sun).
const MAX_LENGTH := 2.6
## Sun altitude (degrees) where shadows reach full strength, at both ends of the day.
const FULL_STRENGTH_ALTITUDE := 12.0


static func hour_angle(hours: float) -> float:
	return deg_to_rad((hours - SOLAR_NOON) * 15.0)


static func declination(season: int) -> float:
	return deg_to_rad(DECLINATION[clampi(season, 0, DECLINATION.size() - 1)])


## Sun height above the horizon, in degrees (negative = below it).
static func altitude(hours: float, season: int) -> float:
	return rad_to_deg(asin(cos(declination(season)) * cos(hour_angle(hours))))


## The true shadow length on flat ground, in object heights (INF when the sun is down).
static func length_ratio(hours: float, season: int) -> float:
	var alt := deg_to_rad(altitude(hours, season))
	if alt <= 0.0:
		return INF
	return cos(alt) / sin(alt)


## Screen-space shadow offset per pixel of height, before the length cap and depth rule.
static func raw_vector(hours: float, season: int) -> Vector2:
	var h := hour_angle(hours)
	var d := declination(season)
	var up := cos(d) * cos(h)
	if up <= 0.0:
		return Vector2.ZERO
	# Sun direction: east = -sin(h)cos(d), north = sin(d), up. The shadow goes the other way.
	return Vector2(sin(h) * cos(d), sin(d)) / up


## The shadow to draw: screen offset per pixel of height (capped and kept readable).
static func shadow_vector(hours: float, season: int) -> Vector2:
	var v := raw_vector(hours, season)
	if v == Vector2.ZERO:
		return Vector2(0, MIN_Y)
	v.y *= GROUND_Y
	if v.length() > MAX_LENGTH:
		v = v.normalized() * MAX_LENGTH
	if absf(v.y) < MIN_Y:
		v.y = MIN_Y if v.y >= 0.0 else -MIN_Y
	return v


## 0 at night, fading in after sunrise and out before sunset, 1 in full sun.
static func strength(hours: float, season: int) -> float:
	return clampf(altitude(hours, season) / FULL_STRENGTH_ALTITUDE, 0.0, 1.0)


## Asar (Shafi'i): when a shadow is as long as the object plus its noon shadow.
## Returns the game minute of the day it starts, found by stepping through the afternoon.
static func asar_minutes(season: int) -> int:
	if _asar_cache.has(season):
		return _asar_cache[season]
	var noon_len := length_ratio(SOLAR_NOON, season)
	var m := int(SOLAR_NOON * 60.0)
	while m < 19 * 60 and length_ratio(m / 60.0, season) < noon_len + 1.0:
		m += 1
	_asar_cache[season] = m
	return m


static var _asar_cache := {}
