#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Installing drawintToText..."

install_drawingtotext()
{
	libredwg_clone_dir="/tmp/libredwg"
	drawingtotext_clone_dir="/tmp/drawingtotext"

	#install LibreDWG
	rm -rf $libredwg_clone_dir &&
	git clone git://git.sv.gnu.org/libredwg.git $libredwg_clone_dir &&
	sudo apt-get -y -f -qq install build-essential &&
	sudo apt-get -y -f -qq install autoconf &&
	sudo apt-get -y -f -qq install libtool &&
	sudo apt-get -y -f -qq install python-dev &&
	sudo apt-get -y -f -qq install swig &&
	sudo apt-get -y -f -qq install texinfo &&
	sudo apt-get -y -f -qq install pkg-config &&
	sudo apt-get -y -f -qq install libxml2-dev &&
	sudo apt-get -y -f -qq install dejagnu &&
	cd $libredwg_clone_dir || die "Unable to cd to DXF extractor directory"  &&
	sh autogen.sh  &&
	./configure --enable-trace LIBXML_CFLAGS=-I/usr/local/opt/libxml2/include LIBXML_LIBS=-L/usr/local/opt/libxml2/lib  &&
	make  &&
	sudo make install  &&

	#build drawingtotext
	git clone https://github.com/davidworkman9/drawingtotext.git $drawingtotext_clone_dir

	#build dxflib
	cd $drawingtotext_clone_dir/dxflib || die "Unable to cd to DXF extractor dxflib directory"  &&
	./configure &&
	make -D_GLIBCXX_USE_CXX11_ABI=0 &&
	sudo make install &&

	cd $drawingtotext_clone_dir || die "unable to cd to drawingtotext git clone folder" &&
	sudo ldconfig &&
	make &&
	sudo mv drawingtotext /usr/local/bin &&

	cd $setup_dir || die "unable to return to start dir after installing drawingtotext"
}

drawingtotext -v foo >/dev/null 2>&1 || install_drawingtotext || die "Unable to install drawingtotext" && info "Installed text extraction tools..."
