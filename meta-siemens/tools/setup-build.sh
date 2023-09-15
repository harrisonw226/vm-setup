
# Setup build configuration
cp ../sources/meta-rti/files/conf/bblayers.conf conf/bblayers.conf
cp ../sources/meta-rti/files/conf/local.conf conf/local.conf

# allow building of two u-boots - restore original
git -C ../sources/poky/meta/classes/ checkout -f uboot-config.bbclass

