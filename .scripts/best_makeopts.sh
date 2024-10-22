#!/bin/bash

cpufreq-set -g performance -r

PACKAGE="ranger"

DISTDIR="/tmp/" emerge -f ${PACKAGE}

for i in {1..10}
do
	echo jobs: ${i}
	echo 1 > /proc/sys/vm/drop_caches
	time DISTDIR="/tmp" EMERGE_DEFAULT_OPTS="" MAKEOPTS="-j${i}" emerge -q1OB ${PACKAGE}
	echo -ne "\n\n\n"
done

