PLYMOUTH_DIR=usr/share/plymouth/themes
THEME_INSTALL_DIR=${PLYMOUTH_DIR}/tux
NAME=plymouth-theme-tux
VERSION=0.0-5
PACKAGE=${NAME}_${VERSION}

${PACKAGE}.deb: ${PACKAGE}
	@dpkg-deb --verbose --build "${PACKAGE}"

${PACKAGE}: \
	${PACKAGE}/DEBIAN/control \
	${PACKAGE}/DEBIAN/postinst \
	${PACKAGE}/DEBIAN/prerm \
	${PACKAGE}/DEBIAN/postrm \
	${PACKAGE}/${THEME_INSTALL_DIR}/tux.script \
	${PACKAGE}/${THEME_INSTALL_DIR}/tux.plymouth \
	${PACKAGE}/${THEME_INSTALL_DIR}/img/tux.png \
	${PACKAGE}/${THEME_INSTALL_DIR}/img/spinner.png \
	${PACKAGE}/${THEME_INSTALL_DIR}/img/input.png \
	${PACKAGE}/${THEME_INSTALL_DIR}/img/background.png \
	${PACKAGE}/${THEME_INSTALL_DIR}/img/log_background.png \
	${PACKAGE}/${THEME_INSTALL_DIR}/img/lock.png

${PACKAGE}/${THEME_INSTALL_DIR}:
	@mkdir -pv "${PACKAGE}/${THEME_INSTALL_DIR}"

${PACKAGE}/${THEME_INSTALL_DIR}/tux.script: ${PACKAGE}/${THEME_INSTALL_DIR} $(wildcard src/*.script)
	@gcc -H -E -I src - <"src/tux.script" -o "$@"

${PACKAGE}/${THEME_INSTALL_DIR}/tux.plymouth: src/tux.plymouth ${PACKAGE}/${THEME_INSTALL_DIR}
	@sed "s,\$${THEME_INSTALL_DIR},${THEME_INSTALL_DIR}," "$<" >"$@"

${PACKAGE}/${THEME_INSTALL_DIR}/img:
	@mkdir -pv "${PACKAGE}/${THEME_INSTALL_DIR}/img"

${PACKAGE}/${THEME_INSTALL_DIR}/img/background.png: ${PACKAGE}/${THEME_INSTALL_DIR}/img
	convert -size 2560x1600 -define gradient:center=1536,960 radial-gradient:#333-#222 -spread 50 "$@"

${PACKAGE}/${THEME_INSTALL_DIR}/img/log_background.png: ${PACKAGE}/${THEME_INSTALL_DIR}/img
	convert -size 1x1 xc:black "$@"

${PACKAGE}/${THEME_INSTALL_DIR}/img/%.png: src/img/%.svg ${PACKAGE}/${THEME_INSTALL_DIR}/img
	inkscape "$<" -o "$@"

${PACKAGE}/DEBIAN/control: DEBIAN/control
	@mkdir -pv "${PACKAGE}/DEBIAN"
	@sed "s,\$${VERSION},${VERSION},;s,\$${NAME},${NAME}," "$<" >"$@"

${PACKAGE}/DEBIAN/%: DEBIAN/%
	@mkdir -pv "${PACKAGE}/DEBIAN"
	@cp -v "$<" "$@"

clean:
	@rm -vr "${PACKAGE}" "${PACKAGE}.deb"

deb-install: ${PACKAGE}.deb
	@sudo dpkg -i "${PACKAGE}.deb"

install: ${PACKAGE}
	@sudo cp -rv "${PACKAGE}/${THEME_INSTALL_DIR}" "/${PLYMOUTH_DIR}"

release: ${PACKAGE}.deb
	@cp -v ${PACKAGE}.deb docs/${PACKAGE}.deb
	@dpkg-sig -k FF2DF3F9B0212DA2EEE394ED457E05AA151BE0D8 --sign repo docs/${PACKAGE}.deb
	@cd docs && apt-ftparchive packages ${PACKAGE}.deb >Packages
	@gzip -c docs/Packages >docs/Packages.gz
	@apt-ftparchive release docs >docs/Release
	@gpg --default-key FF2DF3F9B0212DA2EEE394ED457E05AA151BE0D8 --clearsign -o docs/InRelease docs/Release

uninstall:
	@sudo apt -y remove "${NAME}"

.PHONY: build clean install uninstall
