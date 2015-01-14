window.canvasContext = null
canvas = null

window.makeCanvas = () ->
	$('BODY').append $("<canvas id='canvas'></canvas>")
	canvas = document.getElementById 'canvas'
	window.canvasContext = canvas.getContext '2d'
	height = canvas.height = 500 #document.body.offsetHeight
	width = canvas.width = document.body.offsetWidth
	
window.blankCanvas = () ->
	# From http://stackoverflow.com/a/6722031

	# Store the current transformation matrix
	window.canvasContext.save()

	# Use the identity matrix while clearing the canvas
	window.canvasContext.setTransform(1, 0, 0, 1, 0, 0)
	window.canvasContext.clearRect(0, 0, 1000, 1000)

	# Restore the transform
	window.canvasContext.restore()
