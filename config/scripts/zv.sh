#!/usr/bin/env bash

INFO="\x1b[1;34m"
ERROR="\x1b[1;31m"
GRAY="\x1b[1;90m"
NC="\x1b[0m"

ZIG_DIR="$HOME/.zig"
ZIG_DOWNLOAD_URL=https://ziglang.org/download/

ZLS_REPO="https://github.com/zigtools/zls"

update_zls() {
	version="$1"

	if [[ "$version" == "" ]]; then
		error "Missing argument (version)"
		exit 1
	fi

	zls_dir="$ZIG_DIR/zls-$version"

	if [[ ! -d "$zls_dir" ]]; then
		mkdir -p "$zls_dir"
	fi

	if [[ ! -d "$zls_dir/.git" ]]; then 
		echo -e "${INFO}Clone branch '$version' '$ZLS_REPO' to '$zls_dir'${NC}"
		if ! git clone -b "$version" "$ZLS_REPO" "$zls_dir"; then
			exit 1
		fi
	else
		cd $zls_dir
		echo -e "${INFO}Pull changes from repo${NC}"
		if git pull | grep "Already up to date."; then 
			exit 0
		fi
	fi

	echo -e "${INFO}Build zls-$version${NC}"
	zig build -Doptimize=ReleaseSafe
}

error() {
	echo -e "${ERROR}error${GRAY}:${NC} $1"
}

case $1 in 
	l|ls|list)
		echo "Available versions:"
		for entry in "$ZIG_DIR"/*; do
			entry=${entry:${#ZIG_DIR}+1}
			if [[ "$entry" == "zig-"* ]]; then
				echo "${entry:4}"
			fi
		done
		;;
	zls|lsp)
		case $2 in
			l|ls|list)
				echo "Available zls versions:"
				for entry in "$ZIG_DIR"/*; do
					entry=${entry:${#ZIG_DIR}+1}
					if [[ "$entry" == "zls-"* ]]; then
						echo "${entry:4}"
					fi
				done
				;;
			u|use)
				target_version=$3
				if [[ "$target_version" != "" ]] && [[ -d "$ZIG_DIR/zls-$target_version" ]]; then
					echo "ln -sfn \"$ZIG_DIR/zls-$target_version\" \"$ZIG_DIR/zls\""
					ln -sfn "$ZIG_DIR/zls-$target_version" "$ZIG_DIR/zls"
					echo "now using: $target_version"
				else
					error "Could not find version: \"$target_version\""
				fi
				;;
			a|add)
				update_zls $3
				echo -e "Remember running '$0 zls use $3', to use the version"
				;;
			c|current)
				echo "$(readlink $ZIG_DIR/zls)"
				;;
			update|install)
				update_zls "master"
				;;
		esac
		;;
	d|download)
		if [[ "$OSTYPE" == "darwin"* ]]; then
			open $ZIG_DOWNLOAD_URL
		else
			xdg-open $ZIG_DOWNLOAD_URL
		fi
		;;
	a|add)
		new_zig=$2
		dst_version=$3

		if [[ "$dst_version" == "" ]]; then
			echo -e "Please specify a target version, e.g.:\nzv.sh add zig-0.16.0-dev.2821+3edaef9e0.tar.xz 0.16.0-dev"
			exit 1
		fi

		override=false

		if [[ -d "$ZIG_DIR/zig-$dst_version" ]]; then
			read -p "Zig version already exists, are you sure you want to continue? [y/N]: " wanttocontinue
			wanttocontinue=${wanttocontinue:-n}

			if [[ $wanttocontinue != "y" ]] && [[ $wanttocontinue != "Y" ]]; then
				exit 0
			fi
			override=true
		fi

		if [[ "$new_zig" == *".tar.xz" ]]; then
			if $override; then
				echo "rm -rf \"$ZIG_DIR/zig-$dst_version\""
				rm -rf "$ZIG_DIR/zig-$dst_version"
			fi

			if [[ "$new_zig" == "http"* ]]; then 
				mkdir -p /tmp/zv/
				echo "Downloading '$new_zig'"
				curl -s "$new_zig" -o "/tmp/zv/zig-$dst_version.tar.xz"
				new_zig="/tmp/zv/zig-$dst_version.tar.xz"
			else
				new_zig=$(readlink -f "$2")
				if [[ ! -f "$new_zig" ]]; then
					echo "Cannot find file '$new_zig'"
				fi
			fi

			echo "mkdir \"$ZIG_DIR/zig-$dst_version\""
			mkdir "$ZIG_DIR/zig-$dst_version"
			echo "tar xf \"$new_zig\" -C \"$ZIG_DIR/zig-$dst_version\" --strip-components=1"
			tar xf "$new_zig" -C "$ZIG_DIR/zig-$dst_version" --strip-components=1
			echo "IMPORTANT!"
			echo -e "\tto use the installed version run: $0 use $dst_version"
			
			if [[ "$OSTYPE" == "darwin"* ]]; then
				echo -e "\tSo you can run zig, without any issues:"
				echo -e "\txattr -dr com.apple.quarantine \"$ZIG_DIR/zig-$dst_version\""
				xattr -dr com.apple.quarantine "$ZIG_DIR/zig-$dst_version"
			fi
		else
			error "Please provide a .tar.xz file..."
		fi
		;;
	u|use)
		target_version=$2
		if [[ "$target_version" != "" ]] && [[ -d "$ZIG_DIR/zig-$target_version" ]]; then
			echo "ln -sfn \"$ZIG_DIR/zig-$target_version\" \"$ZIG_DIR/current\""
			ln -sfn "$ZIG_DIR/zig-$target_version" "$ZIG_DIR/current"
			echo "now using: $target_version"
		else
			error "Could not find version: \"$target_version\""
		fi
		;;
	c|current)
		zig_path=$(readlink $ZIG_DIR/current)
		zls_path=$(readlink $ZIG_DIR/zls)
		echo "zig: ${zig_path:${#ZIG_DIR}+5}"
		echo "zls: ${zls_path:${#ZIG_DIR}+5}"
		;;
	delete)
		version=$2
		target="$ZIG_DIR/zig-$version"

		if [[ ! -d "$target" ]]; then
			exit 0
		fi

		read -p "Are you sure you want to delete \"$target\"? [y/N]: " wanttocontinue
		wanttocontinue=${wanttocontinue:-n}

		if [[ "$wanttocontinue" != "y" ]] && [[ "$wanttocontinue" != "Y" ]]; then
			exit 0
		fi

		echo "rm -rf \"$target\""
		rm -rf "$target"
		;;
	h|help)
		echo -e "Zig Version Manager"
		echo -e ""
		echo -e "\tl|ls|list"
		echo -e ""
		echo -e "\t\tlist all awailable zig versions."
		echo -e ""
		echo -e "\td|download"
		echo -e ""
		echo -e "\t\ttries to open '$ZIG_DOWNLOAD_URL' in a browser."
		echo -e ""
		echo -e "\ta|add [zig.tar.xz] [as_version]"
		echo -e ""
		echo -e "\t\t[zig.tar.xz] - zig release (can be downloaded from: https://ziglang.org/download/, can be a url to a tar.xz zig build)"
		echo -e "\t\t[as_version] - a sting representing the version of the zig source code, e.g.: 0.16.0-dev"
		echo -e ""
		echo -e "\t\tExample:"
		echo -e "\t\tzv add https://ziglang.org/builds/zig-aarch64-macos-0.16.0-dev.3121+d34b868bc.tar.xz master"
		echo -e ""
		echo -e "\t\tWould download the tar.xz and install it to '$ZIG_DIR/zig-master'"
		echo -e ""
		echo -e "\tu|use [version]"
		echo -e ""
		echo -e "\t\t[version]    - the zig version you want to use, e.g.: master"
		echo -e ""
		echo -e "\tc|current"
		echo -e ""
		echo -e "\t\tprints the currently seclected zig version dir."
		echo -e ""
		echo -e "\tdelete [version]"
		echo -e ""
		echo -e "\t\t[version]    - deletes the specified zig version."
		echo -e ""
		echo -e "ZLS (LSP)"
		echo -e ""
		echo -e "\tzls|lsp update"
		echo -e ""
		echo -e "\t\tClones the '$ZLS_REPO' and builds it."
		echo -e ""
		echo -e "\tzls|lsp use <version>"
		echo -e ""
		echo -e "\t\tUse the specified zls version"
		echo -e ""
		echo -e "\tzls|lsp l|ls|list"
		echo -e ""
		echo -e "\t\tList all zls versions"
		echo -e ""
		echo -e "\tzls|lsp a|add <version>"
		echo -e ""
		echo -e "\t\tInstall the version."
		echo -e ""
		;;
	*)
		$0 h
		error "Unknown argument: '$1'"
		;;
esac

