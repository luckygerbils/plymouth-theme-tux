PLYMOUTH_DIR=/usr/share/plymouth/themes
THEME_INSTALL_DIR=${PLYMOUTH_DIR}/tux

build: $(patsubst %,dist/%.png, $(shell find src -type f -name '*.png' -exec basename '{}' .png ';')) dist/tux.script dist/tux.plymouth dist/tux.png dist/wallpaper.png

dist/tux.script: src/tux.script
	@mkdir -pv dist
	@cp -v -u src/tux.script dist/

dist/tux.plymouth: src/tux.plymouth
	@mkdir -pv dist
	@cp -v -u src/tux.plymouth dist/

dist/tux.png: src/tux.svg
	@mkdir -pv dist
	inkscape src/tux.svg -o dist/tux.png -w 202

dist/wallpaper.png:
	@mkdir -pv dist
	convert -size 2560x1600 -define gradient:center=1536,960 radial-gradient:#333-#222 -spread 50 dist/wallpaper.png

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
