#!/bin/bash

# THIS SCRIPT MUST BE RUN FROM WITHIN THE GLUON-SITE-CONFIG PATH!

BRANCH=${2:-"stable"}
COMMUNITIES=(augustusburg colditz doebeln floeha geringswalde grimma grossschirma hartha leisnig mittweida oschatz ostrau rosswein waldheim wermsdorf)
TARGETS=(ar71xx-generic ar71xx-nand mpc85xx-generic x86-generic x86-kvm_guest x86-xen_domu x86-64)

rm -r "images"
rm /data1/gluon/build.log

# clean and update
for TARGET in ${TARGETS[@]}
do
    cd /data1/gluon
    echo -e "\n\n\n============================================================\n\n" >> build.log
    echo "Pre-Building: Starting work on target $TARGET" | tee -a build.log
    echo -e "\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH update -j6" >> build.log
    make GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH update -j6 >> build.log 2>&1
    echo -e "\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH clean -j6" >> build.log
    make GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH clean -j6 >> build.log 2>&1
    echo -e "\n\n------------------------------------------------------------\n\n" >> build.log

    for COMMUNITY in ${COMMUNITIES[@]}
    do
       rm /data1/gluon/site
       ln -s /data1/gluon-site-config/$COMMUNITY /data1/gluon/site
       mkdir -p /data1/gluon-site-config/images/$COMMUNITY /data1/gluon-site-config/images/$COMMUNITY/factory /data1/gluon-site-config/images/$COMMUNITY/sysupgrade

       echo "Starting work on target $TARGET for $COMMUNITY" | tee -a build.log
       echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH -j6" >> build.log
       make GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH -j6 >> build.log 2>&1
       echo -e "\n\n------------------------------------------------------------\n\n" >> build.log

       echo -e "Moving Images for $COMMUNITY ...\n\n" >> build.log
       mv /data1/gluon/output/images/factory/* /data1/gluon-site-config/images/$COMMUNITY/factory
       mv /data1/gluon/output/images/sysupgrade/* /data1/gluon-site-config/images/$COMMUNITY/sysupgrade
       echo "Compilation complete for $COMMUNITY\n\n" >> build.log
    done
done

echo "Done :)"
