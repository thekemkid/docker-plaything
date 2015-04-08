FROM ubuntu

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y git curl git-core wget build-essential gcc \
 	python3-dev uuid-dev libc6-dev libglib2.0-dev bison Flex \
 	libtool autoconf libxml2-dev libpopt-dev python3-sphinx swig && \
 	export PYTHON="python3" && \
	export PYTHON_CONFIG="/usr/bin/python3-config" && \
RUN	git clone git://git.urcu.so/userspace-rcu.git /home/urcu && \
	cd /home/urcu && \
	git checkout stable-0.8 &&\
	./bootstrap && \
	./configure && \
	make && \
	make install && \
	ldconfig
	
RUN	git clone git://git.efficios.com/babeltrace.git /home/babeltrace && \
	cd /home/babeltrace && \
	git checkout stable-1.2 && \
	./bootstrap && \
	./configure --enable-python-bindings && \
	make && \
	make install && \
	ldconfig
	
RUN	git clone git://git.lttng.org/lttng-ust.git /home/lttng-ust && \
	cd /home/lttng-ust && \
	git checkout stable-2.6 && \
	./bootstrap && \
	./configure && \
	make && \
	make install && \
	ldconfig
	
RUN	git clone git://git.lttng.org/lttng-tools.git /home/lttng-tools && \
	cd /home/lttng-tools && \
	git checkout stable-2.6 && \
	./bootstrap && \
	./configure && \
	make && \
	make install && \
	ldconfig

RUN	git clone git://git.lttng.org/lttng-modules.git lttng-modules && \
	cd /home/lttng-modules && \
	git checkout stable-2.6 && \
	make && \
	make modules_install && \
	depmod -a
	
RUN	git clone https://github.com/iojs/io.js.git /home/io.js && \
	cd /home/io.js && \
	git checkout v1.x && \
	./configure --with-lttng && \
	make && \
	make install
	
RUN 	groupadd -r tracing
RUN	usermod -aG tracing vagrant; lttng-sessiond -b
