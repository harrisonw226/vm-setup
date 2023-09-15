SUMMARY = "adds script to update rootfs and kernel"
LICENSE = "CLOSED"

SRC_URI = "\
            file://rti-updater.sh \
            "

RDEPENDS:${PN}  = "bash"

BOARDPATH = "/usr/sbin"

VERSION = "0.0.1"

TYPE = "dev"

do_install() {

	install -d ${D}${BOARDPATH}
	install -m 0755 ${WORKDIR}/rti-updater.sh  ${D}${BOARDPATH}/


	install -d ${D}/var/rti

	echo ${VERSION} > ${D}/var/rti/verison
	echo ${TYPE} > ${D}/var/rti/type
        echo "Built on $(date +%Y_%m_%d__%H_%M_%S)" > ${D}/var/rti/build
}

FILES:${PN} += "/var/rti"


