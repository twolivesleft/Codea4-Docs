## Classes
### assets

#### Static Methods
decode()

__index()

__newindex()

__call()

encode()

#### Methods
__tostring()

__index()

__newindex()

__concat()

__gc()

__len()

#### Properties

### camera

#### Static Methods
orbit()

__index()

__newindex()

__call()

ortho()

#### Methods
__tostring()

__index()

__newindex()

worldToScreen()

__gc()

screenToWorld()

apply()

#### Properties

### color

#### Static Methods
__index()

__newindex()

__call()

#### Methods
mix()

__tostring()

__index()

__newindex()

unpack()

__gc()

#### Properties

### curve

#### Static Methods
__index()

__newindex()

__call()

#### Methods
__tostring()

__index()

__newindex()

evaluate()

__gc()

#### Properties

### entity

#### Static Methods
__index()

__newindex()

#### Methods
get()

__tostring()

findChild()

__gc()

__newindex()

transformDirection()

childAt()

tween()

inverseTransformDirection()

__eq()

inverseTransformPoint()

destroy()

remove()

__index()

has()

add()

transformPoint()

#### Properties

### gamepad

#### Static Methods
connected()

disconnected()

__index()

__newindex()

#### Methods
__tostring()

__index()

__newindex()

__eq()

__gc()

#### Properties

### gesture

#### Static Methods
__index()

__newindex()

#### Methods
__newindex()

__gc()

__index()

#### Properties

### gradient

#### Static Methods
__index()

__newindex()

__call()

#### Methods
__tostring()

__index()

__newindex()

evaluate()

__gc()

#### Properties

### image

#### Static Methods
dfg()

read()

save()

__newindex()

__call()

volume()

__index()

backbuffer()

cube()

#### Methods
__tostring()

__tojson()

__index()

__newindex()

__gc()

generateIrradiance()

#### Properties

### keyPress

#### Static Methods
__index()

__newindex()

#### Methods
__newindex()

__gc()

__index()

#### Properties

### light

#### Static Methods
pop()

push()

directional()

__index()

__newindex()

environment()

clear()

#### Methods
__newindex()

__gc()

__index()

#### Properties

### mat2

#### Static Methods
__index()

__newindex()

__call()

#### Methods
__tostring()

__eq()

__add()

__sub()

__index()

__newindex()

inverse()

__unm()

__mul()

__gc()

#### Properties

### mat3

#### Static Methods
__index()

__newindex()

__call()

#### Methods
__tostring()

__eq()

__add()

__sub()

__index()

__newindex()

inverse()

__unm()

__mul()

__gc()

#### Properties

### mat4

#### Static Methods
transform()

__index()

__newindex()

__call()

decompose()

#### Methods
__tostring()

__eq()

__add()

__sub()

__index()

__newindex()

inverse()

__unm()

__mul()

__gc()

#### Properties

### material

#### Static Methods
unlit()

save()

read()

__index()

__newindex()

__call()

lit()

#### Methods
__tostring()

__tojson()

__index()

__newindex()

setOption()

properties()

__gc()

#### Properties

### mesh

#### Static Methods
roundedBox()

sphere()

box()

__newindex()

__call()

icoSphere()

torus()

disk()

cylinder()

torusKnot()

__index()

read()

plane()

teapot()

cone()

#### Methods
position()

color()

__gc()

drawIndirect()

__newindex()

resizeVertices()

draw()

addRect()

__tostring()

__tojson()

calculateTangents()

resizeIndicies()

index()

uv()

normal()

__index()

addElement()

calculateBounds()

#### Properties

### particles

#### Static Methods
__index()

__newindex()

__call()

#### Methods
__tostring()

emit()

__index()

__newindex()

draw()

update()

__gc()

#### Properties

### quat

#### Static Methods
angleAxis()

lookRotation()

fromToRotation()

__index()

__newindex()

__call()

eulerAngles()

#### Methods
angles()

__tostring()

normalize()

__gc()

__unm()

__newindex()

length2()

length()

conjugate()

slerp()

__index()

normalized()

__mul()

__eq()

#### Properties

### Runtime

#### Static Methods
__index()

__newindex()

#### Methods
__newindex()

__gc()

__index()

#### Properties

### scalar

#### Static Methods
__index()

__newindex()

__call()

#### Methods
__tostring()

__index()

__newindex()

__unm()

__gc()

#### Properties

### scene

#### Static Methods
default3d()

save()

default2d()

__index()

__newindex()

__call()

read()

#### Methods
tween()

__tostring()

draw()

__index()

__newindex()

entity()

update()

entities()

__gc()

#### Properties

### shader

#### Static Methods
__index()

__newindex()

__call()

compute()

#### Methods
properties()

__tostring()

workgroupSize()

dispatchIndirect()

setBuffer()

__index()

__newindex()

dispatch()

setOption()

setImage()

__gc()

#### Properties

### shaderState

#### Static Methods
__index()

__newindex()

#### Methods
__index()

__newindex()

setOption()

__gc()

#### Properties

### touch

#### Static Methods
__index()

__newindex()

#### Methods
__newindex()

__gc()

__index()

#### Properties

### vec2

#### Static Methods
__index()

__newindex()

__call()

#### Methods
length2()

__tostring()

distance2()

__gc()

normalized()

__newindex()

__eq()

distance()

__mul()

__sub()

perp()

__add()

__unm()

__div()

lerp()

normalize()

length()

reflect()

__index()

unpack()

dot()

#### Properties

### vec3

#### Static Methods
__index()

__newindex()

__call()

#### Methods
length2()

__tostring()

distance2()

__gc()

__tojson()

normalized()

__newindex()

__eq()

cross()

__mul()

__sub()

__add()

__unm()

distance()

__div()

lerp()

length()

reflect()

__index()

normalize()

unpack()

dot()

#### Properties

### vec4

#### Static Methods
__index()

__newindex()

__call()

#### Methods
length2()

__tostring()

distance2()

__gc()

normalized()

__newindex()

__eq()

distance()

__mul()

__sub()

__add()

__unm()

__div()

lerp()

length()

reflect()

__index()

normalize()

unpack()

dot()

#### Properties

### virtualGamepad

#### Static Methods
__index()

__newindex()

#### Methods
__index()

__newindex()

__gc()

#### Properties

    
## Global Functions
apiExplorer()
apiTree()
arc()
assert()
background()
bezier()
collectgarbage()
containsKey()
context()
dofile()
draw()
dump()
dumpItem()
ellipse()
error()
getmetatable()
gui()
ipairs()
is()
line()
load()
loadfile()
next()
pairs()
pcall()
print()
rawequal()
rawget()
rawlen()
rawset()
rect()
require()
roundRect()
select()
setmetatable()
setup()
shape()
tonumber()
tostring()
touched()
type()
warning()
xpcall()
    
## Constants
ADDITIVE: 2.000000
BACKGROUND: 0.000000
BASELINE: 64.000000
BEGAN: 0.000000
BEVEL: 4.000000
BOTTOM: 32.000000
CANCELLED: 3.000000
CENTER: 2.000000
COLOR_MASK_ALPHA: 8.000000
COLOR_MASK_BLUE: 4.000000
COLOR_MASK_GREEN: 2.000000
COLOR_MASK_NONE: 0.000000
COLOR_MASK_RED: 1.000000
COLOR_MASK_RGB: 7.000000
COLOR_MASK_RGBA: 15.000000
CORNER: 0.000000
CORNERS: 1.000000
CULL_FACE_BACK: 68719476736.000000
CULL_FACE_FRONT: 137438953472.000000
CULL_FACE_NONE: 0.000000
DeltaTime: 0.008975
DEPTH_FUNC_EQUAL: 48.000000
DEPTH_FUNC_GREATER: 80.000000
DEPTH_FUNC_GREATER_EQUAL: 64.000000
DEPTH_FUNC_LESS: 16.000000
DEPTH_FUNC_LESS_EQUAL: 32.000000
DEPTH_FUNC_NEVER: 112.000000
DEPTH_FUNC_NOT_EQUAL: 96.000000
DISABLED: 8.000000
DST_ALPHA: 28672.000000
DST_COLOR: 40960.000000
ElapsedTime: 5.739785
ENDED: 2.000000
HEIGHT: 834.000000
LEFT: 1.000000
LIGHTEN: 4.000000
LINEAR_BURN: 7.000000
MIDDLE: 16.000000
MITER: 3.000000
MOVING: 1.000000
MULTIPLY: 3.000000
NORMAL: 0.000000
ONE: 8192.000000
ONE_MINUS_DST_ALPHA: 32768.000000
ONE_MINUS_SRC_ALPHA: 24576.000000
ONE_MINUS_SRC_COLOR: 16384.000000
OPAQUE: 1.000000
OVERLAY: 3.000000
PREMULTIPLIED: 1.000000
PROJECT: 2.000000
RADIUS: 3.000000
RIGHT: 4.000000
ROUND: 0.000000
SCREEN: 6.000000
SQUARE: 1.000000
SRC_ALPHA: 20480.000000
SRC_ALPHA_SATURATE: 45056.000000
SRC_COLOR: 12288.000000
TOP: 8.000000
TRANSPARENT: 2.000000
WIDTH: 1194.000000
ZERO: 4096.000000
