#! /bin/bash
set -e


mainFunction () {
	enterArchupdateBuildDir
	downloadArchupdatePackageComponents
	makePackage
	updatePackagesHere
	removeCurrentDir
}


downloadArchupdatePackageComponents () {
	local url="https://raw.githubusercontent.com/Imdabossou/ArchUpdate/main/package"

	curl --silent "${url}/PKGBUILD" > PKGBUILD
	curl --silent "${url}/recipes.sh" > recipes.sh
}


enterArchupdateBuildDir () {
	local dir="/tmp/archupdate"

	so sudo rm --recursive --force "${dir}"
	so mkdir --parents "${dir}"
	cd "${dir}"
	trap 'removeCurrentDir' INT TERM QUIT ERR
}


makePackage () {
	export PACKAGER="${USER} <@${HOSTNAME}>"
	so makepkg --syncdeps --needed --rmdeps --force --noconfirm
}


refreshDatabases () {
	so sudo pacman --sync --refresh
	so sudo pacman --files --refresh
}


removeCurrentDir () {
	local dir="${PWD}"
	cd ".."
	so sudo rm --recursive --force "${dir}"
}


so () {
	local commands="${*}"

	if [[ "${verbose}" -eq 1 ]]; then
		if ! ${commands}; then
			exit "${?}"
		fi
	elif ! error="$(eval "${commands}" 2>&1 >"/dev/null")" ; then
		if [ "${error}" == "" ] ; then
			error="Command failed: ${commands}"
		fi

		echo "${FUNCNAME[1]}: ${error}" >&2
		exit 1
	fi
}


updatePackagesHere () {
	so sudo pacman --upgrade --noconfirm ./*.pkg.*
	refreshDatabases
}


sudo -v
mainFunction
