extends Node2D

onready var SpawnPoint = $SpawnPoint

var currentWave:int = 0
var currentFormation:int = 0
var formation = [ [2, 1], [2, 2], [3, 1], [5, 1] ]

var maxSpawnOffset:float = 50

var tscnEnemySpawnParticle = preload("res://nodes/vfx/particles/EnemySpawn.tscn")
var tscnRamEnemy = preload("res://nodes/enemy/RamEnemy.tscn")
var tscnCannonEnemy = preload("res://nodes/enemy/CannonEnemy.tscn")

export var spawnableEnemies = []

var bCanSpawnEnemy:bool = true
var spawnDelay:float = 1.0
var spawnOffset:float = 0.5
var spawnTimer:float = 0

func _ready():
	pass

func _physics_process(delta):
	if (Global.Main.gameStarted):
		process_spawn(delta)

func process_spawn(delta):
	# spawn the next formation if it can
	if (bCanSpawnEnemy):
		spawn_formation(currentFormation)
		currentFormation += 1
		bCanSpawnEnemy = false
		spawnTimer = spawnDelay + (rand_range(-spawnOffset, spawnOffset))
		return
	# reduce timer if it cannot
	if (!bCanSpawnEnemy):
		spawnTimer -= delta
		if (spawnTimer <= 0):
			bCanSpawnEnemy = true

func spawn_formation(index):
	if (index < formation.size()):
		# get the structure of the formation
		var formStructure = formation[index]
		# get the position where the first enemy should be spawned at
		var firstSpawn = Vector2(SpawnPoint.global_position.x - (32 * formStructure[0]/2), SpawnPoint.global_position.y)
		# randomly offset the spawn position
		var randomVector = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * rand_range(0, maxSpawnOffset)
		firstSpawn += randomVector
		# iterate through the structure to spawn the enemy
		for y in formStructure[1]:
			for x in formStructure[0]:
				# change this bit so that it spawns the particle instead
				# the particle will call back on this node to spawn the enemy at the appropriate location
				var spawnPosition = Vector2(firstSpawn.x + (32 * x), firstSpawn.y + (32 * y))
				var spawnParticleI = tscnEnemySpawnParticle.instance()
				get_tree().get_current_scene().add_child(spawnParticleI)
				var enemyToSpawn = spawnableEnemies[rand_range(0, spawnableEnemies.size())]
				spawnParticleI.set_new(spawnPosition, [self, enemyToSpawn])
	if (index >= formation.size()):
		currentWave = 0
		currentFormation = 0

func particle_spawn_enemy(newtscnEnemy, newSpawnPosition:Vector2):
	var enemyI = newtscnEnemy.instance()
	get_tree().get_current_scene().add_child(enemyI)
	enemyI.set_new(newSpawnPosition)
