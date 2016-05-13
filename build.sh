#!/bin/bash

# THIS SCRIPT MUST BE RUN FROM WITHIN THE GLUON-SITE-CONFIG PATH!

BRANCH=${2:-"stable"}
COMMUNITIES=(augustusburg colditz doebeln floeha geringswalde grimma grossschirma hartha leisnig mittweida oschatz ostrau rosswein waldheim wermsdorf)
TARGETS=(ar71xx-generic ar71xx-nand mpc85xx-generic x86-generic x86-kvm_guest x86-xen_domu x86-64)

rm -r "images"
rm /data1/gluon/build.log

# clean and update
for TARGET in $TARGETS
do
    cd /data1/gluon
    echo "Pre-Building: Starting work on target $TARGET" | tee -a build.log
    echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH update -j6" >> build.log
    make GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH update -j6 >> build.log 2>&1
    echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH clean -j6" >> build.log
    make GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH clean -j6 >> build.log 2>&1
    echo -e "\n\n\n============================================================\n\n" >> build.log
done

for COMMUNITY in $COMMUNITIES
do
  rm /data1/gluon/site
  ln -s /data1/gluon-site-config/$COMMUNITY /data1/gluon/site
  mkdir -p /data1/gluon-site-config/images/$COMMUNITY

  for TARGET in $TARGETS
  do
      cd /data1/gluon
  		echo "Starting work on target $TARGET for $COMMUNITY" | tee -a build.log
  		echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH -j6" >> build.log
  		make GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH -j6 >> build.log 2>&1
  		echo -e "\n\n\n============================================================\n\n" >> build.log
  done

  mv /data1/gluon/output/images/* /data1/gluon-site-config/images/$COMMUNITY
  echo "Compilation complete for $COMMUNITY"
done

echo "Done :)"
