PLYMOUTH_DIR=/usr/share/plymouth/themes
THEME_INSTALL_DIR=${PLYMOUTH_DIR}/tux

build: $(patsubst %,dist/%.png, $(shell find src -type f -name '*.png' -exec basename '{}' .png ';')) \
	dist/tux.script \
	dist/tux.plymouth \
	dist/tux.png \
	dist/passw-dialog.png \
	dist/background.png \
	dist/bullet.png \
	dist/spinner.png

dist/tux.script: src/tux.script
	@mkdir -pv dist
	@cp -v -u src/tux.script dist/

dist/tux.plymouth: src/tux.plymouth
	@mkdir -pv dist
	@sed "s,\$${THEME_INSTALL_DIR},${THEME_INSTALL_DIR}," "$<" >"$@"

dist/tux.png: src/tux.svg
	@mkdir -pv dist
	inkscape $< -o "$@" -w 202
	
dist/passw-dialog.png: src/passw-dialog.svg
	@mkdir -pv dist
	inkscape $< -o "$@" -w 270

dist/bullet.png: src/bullet.svg
	@mkdir -pv dist
	inkscape $< -o "$@" -w 10

dist/spinner.png: src/spinner.svg
	@mkdir -pv dist
	inkscape $< -o "$@" -w 220

dist/background.png:
	@mkdir -pv dist
	convert -size 2560x1600 -define gradient:center=1536,960 radial-gradient:#333-#222 -spread 50 "$@"

dist/%.png: src/%.png
	@mkdir -pv dist
	@cp -v -u $< $@

clean:
	@rm -vr dist

install: dist
	@install -v -t "${THEME_INSTALL_DIR}" -D dist/*

select:
	@update-alternatives --install ${PLYMOUTH_DIR}/default.plymouth default.plymouth ${THEME_INSTALL_DIR}/tux.plymouth 100
	@update-alternatives --config default.plymouth
	@update-initramfs -u

.PHONY: build clean select install
