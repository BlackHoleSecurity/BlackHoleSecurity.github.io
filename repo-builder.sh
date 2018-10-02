#!/data/data/com.termux/files/usr/bin/bash
##
##  APT repository builder
##
##  Packages for repository should be built with command:
##    fakeroot dpkg-deb --uniform-compression -z9 -Zxz -b {package dir} {package}.deb
##  or this script will show error on generating Packages/Packages.xz file
##
##  Original Script : https://github.com/xeffyr/termux-x-repository/blob/master/repo-builder.sh
## 



ARCHITECTURES="all aarch64 arm i686 x86_64"
## iARCHITECTURES="all"
CODENAME="termux"
SUITE="${CODENAME}"
#COMPONENTS="x-gui x-gui-experimental
COMPONENTS="blackholesecurity"
#DESCRIPTION="A repository of X/GUI packages for Termux"
DESCRIPTION="Unofficiall termux repository"
#GPG_KEY="32545795"
GPG_KEY="amsitlab@blackholesecurity"

SCRIPT_PATH=$(realpath "${0}")
REPO_PATH=$(dirname "${SCRIPT_PATH}")
RELEASE_PATH="${REPO_PATH}/dists/${CODENAME}/Release"
INRELEASE_PATH="${REPO_PATH}/dists/${CODENAME}/InRelease"

if ! rm -f "${RELEASE_PATH}" "${INRELEASE_PATH}"; then
    echo "[!] Cannot remove 'Release'."
    exit 1
fi

cat <<- EOF > "${RELEASE_PATH}"
Codename: ${CODENAME}
Version: 1
Architectures: ${ARCHITECTURES}
Description: ${DESCRIPTION}
Suite: ${SUITE}
Date: $(env TZ=UTC LANG=C date -Ru)
SHA256:
EOF

for repo_component in ${COMPONENTS}; do
    for arch in ${ARCHITECTURES}; do
        PACKAGE_DIR_PATH="${REPO_PATH}/dists/${CODENAME}/${repo_component}/binary-${arch}"

        if ! mkdir -p "${PACKAGE_DIR_PATH}" > /dev/null; then
            echo "[!] Cannot create path '${PACKAGE_DIR_PATH}'."
            exit 1
        fi

        (
            export PKG_COUNT=0
            cd "${PACKAGE_DIR_PATH}" && {
                if ! rm -f "Packages" "Packages.xz" "Packages.gz" > /dev/null 2>&1; then
                    echo "[!] Failed to remove file 'Packages'."
                    exit 1
                fi

                if [ -z "$(find . -type f -iname \*.deb)" ]; then
                    echo -n "[!] ${repo_component}/${arch}: no packages"
                else
                    for package in $(find . -type f -iname \*.deb | sort); do
                        PKG_COUNT=$((PKG_COUNT + 1))
                        echo -ne "\033[2K\r[*] ${repo_component}/${arch}: adding '$(echo ${package} | cut -d/ -f2)'"
                        ar -p "${package}" control.tar.xz | tar --to-stdout -xJf - ./control >> Packages
                        FILENAME="${PACKAGE_DIR_PATH//"${REPO_PATH}/"}/${package//"./"}"
                        SIZE=$(wc -c "${package}" | awk '{ print $1 }')
                        SHA256=$(sha256sum "${package}" | awk '{ print $1 }')
                        echo "Filename: ${FILENAME}" >> Packages
                        echo "Size: ${SIZE}" >> Packages
                        echo "SHA256: ${SHA256}" >> Packages
                        unset FILENAME
                        unset SIZE
                        unset SHA256
                        echo >> Packages
                    done

                    if ! xz -9e -k Packages > /dev/null 2>&1; then
                        echo -ne "\033[2K\r[!] Failed to compress file 'Packages'."
                        exit 1
                    fi

                    echo " `sha256sum "Packages" | awk '{ print $1 }'` `wc -c "Packages" | awk '{ print $1 }'` ${PACKAGE_DIR_PATH//"${REPO_PATH}/dists/${CODENAME}/"}/Packages" >> "${RELEASE_PATH}"
                    echo " `sha256sum "Packages.xz" | awk '{ print $1 }'` `wc -c "Packages.xz" | awk '{ print $1 }'` ${PACKAGE_DIR_PATH//"${REPO_PATH}/dists/${CODENAME}/"}/Packages.xz" >> "${RELEASE_PATH}"
                fi
            } || {
                echo "[!] Cannot cd to '${PACKAGE_DIR_PATH}'."
                exit 1
            }

            if [ "${PKG_COUNT}" != "0" ]; then
                echo -ne "\033[2K\r[*] ${repo_component}/${arch}: ${PKG_COUNT} packages"
            fi

            echo
        ) || exit 1
    done
done

cat "${RELEASE_PATH}" | gpg --clearsign --default-key "${GPG_KEY}" --digest-algo SHA512 -o "${INRELEASE_PATH}"
