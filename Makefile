PLYMOUTH_DIR=/usr/share/plymouth/themes
THEME_INSTALL_DIR=${PLYMOUTH_DIR}/tux

build: dist/tux.script \
	dist/tux.plymouth \
	dist/img/tux.png \
	dist/img/spinner.png \
	dist/img/input.png \
	dist/img/background.png

dist/tux.script: $(wildcard src/*.script)
	@mkdir -pv dist
	@gcc -H -E -I src - <"src/tux.script" -o "$@"

dist/tux.plymouth: src/tux.plymouth
	@mkdir -pv dist
	@sed "s,\$${THEME_INSTALL_DIR},${THEME_INSTALL_DIR}," "$<" >"$@"

dist/img/tux.png: src/img/tux.svg
	@mkdir -pv dist/img
	inkscape $< -o "$@" -w 202

dist/img/spinner.png: src/img/spinner.svg
	@mkdir -pv dist/img
	inkscape $< -o "$@" -w 220

dist/img/input.png: src/img/input.svg
	@mkdir -pv dist/img
	inkscape $< -o "$@" -w 270

dist/img/background.png:
	@mkdir -pv dist/img
	convert -size 2560x1600 -define gradient:center=1536,960 radial-gradient:#333-#222 -spread 50 "$@"

clean:
	@rm -vr dist

install: dist
	@mkdir -pv "${THEME_INSTALL_DIR}"
	@cp -rv dist/* "${THEME_INSTALL_DIR}"

select:
	@update-alternatives --install ${PLYMOUTH_DIR}/default.plymouth default.plymouth ${THEME_INSTALL_DIR}/tux.plymouth 100
	@update-alternatives --config default.plymouth
	@update-initramfs -u

.PHONY: build clean select install
