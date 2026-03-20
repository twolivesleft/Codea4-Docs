-- 3D Sphere with directional light

function setup()
    viewer.mode = FULLSCREEN
    sphereMesh = mesh.sphere(1)
    sphereMesh.material = material.lit()
    sphereMesh.material.color = color(100, 180, 255)

    dirLight = light.directional(vec3(1, -1, 1))
    dirLight.intensity = 2

    angle = 0
end

function draw()
    background(20, 20, 30)
    angle = angle + 0.5

    matrix.push()
        matrix.perspective(60)
        light.push(dirLight)
        matrix.translate(0, 0, 4)
        matrix.rotate(angle, 0, 1, 0)
        sphereMesh:draw()
        light.pop()
    matrix.pop()
end
