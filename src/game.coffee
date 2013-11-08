# create the canvas
canvas = document.createElement("canvas")
ctx = canvas.getContext("2d")
canvas.width = 512
canvas.height = 480
document.body.appendChild(canvas)

# background image
bgReady = false
bgImage = new Image()
bgImage.onload = ->
  bgReady = true

bgImage.src = "images/background.png"

# hero image
heroReady = false
heroImage = new Image()
heroImage.onload = ->
  heroReady = true

heroImage.src = "images/hero.png"

# monster image
monsterReady = false
monsterImage = new Image()
monsterImage.onload = ->
  monsterReady = true

monsterImage.src = "images/monster.png"

# game objects
hero =
  speed: 256

monster =
  {}

monstersCaught = 0

keysDown =
  {}

# handle keyboard controls
addEventListener("keydown", (e) ->
  keysDown[e.keyCode] = true
,false)

addEventListener("keyup", (e) ->
  delete keysDown[e.keyCode]
,false)

# reset the game when the player catches a monster
reset = ->
  hero.x = canvas.width / 2
  hero.y = canvas.height / 2
  # throw the monster somewhere on the screen randomly
  monster.x = 32 + (Math.random() * (canvas.width - 64))
  monster.y = 32 + (Math.random() * (canvas.height - 64))

# update game objects
update = (modifier) ->
  if 38 of keysDown  # player holding up
    hero.y -= hero.speed * modifier
  if 40 of keysDown  # player holding down
    hero.y += hero.speed * modifier
  if 37 of keysDown  # player holding left
    hero.x -= hero.speed * modifier
  if 39 of keysDown  # player holding right
    hero.x += hero.speed * modifier

  # are they touching?
  if hero.x <= (monster.x + 32) and monster.x <= (hero.x + 32) and hero.y <= (monster.y + 32) and monster.y <= (hero.y + 32)
    ++monstersCaught
    reset()

# draw everything
render = ->
  if bgReady
    ctx.drawImage(bgImage, 0, 0)
  if heroReady
    ctx.drawImage(heroImage, hero.x, hero.y)
  if monsterReady
    ctx.drawImage(monsterImage, monster.x, monster.y)
  #score
  ctx.fillStyle = "rgb(250, 250, 250)"
  ctx.font = "24px Helvetica"
  ctx.textAlign = "left"
  ctx.textBaseline = "top"
  ctx.fillText("Goblins caught: " + monstersCaught, 32, 32)

# the main game loop
main = ->
  now = Date.now()
  delta = now - window.before
  update(delta / 1000)
  render()
  window.before = now


# let's play this game!
reset()
window.before = Date.now()
setInterval(main, 1) # execute as fast as possible

