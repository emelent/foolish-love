love_exe=/Applications/love.app/Contents/MacOS/love
build:
	zip -9 -r dist/game.love . -x "Makefile" "dist*" ".*" "serve.py"


build-web: build
	# pnpm dlx love.js -t "GameTitle" dist/game.love -x dist/web
	pnpm dlx love.js -t "GameTitle" dist/game.love dist/web

clean:
	rm -rf dist/*

run-dist:
	${love_exe} dist/game.love

run:
	${love_exe} .

serve:
	python3 serve.py
