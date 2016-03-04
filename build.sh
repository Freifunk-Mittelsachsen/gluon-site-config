#!/bin/bash

# THIS SCRIPT MUST BE RUN FROM WITHIN THE GLUON-SITE-CONFIG PATH!

BRANCH=${2:-"stable"}

rm -r "images"

for COMMUNITY in doebeln geringswalde hartha leisnig mittweida oschatz ostrau waldheim
do
  ln -s ~/gluon-site-config/$COMMUNITY ~/gluon/site
  mkdir "images/"$COMMUNITY

  for TARGET in  ar71xx-generic ar71xx-nand mpc85xx-generic x86-generic x86-kvm_guest x86-xen_domu x86-64
  do
      cd ~/gluon
  		echo "Starting work on target $TARGET for $COMMUNITY" | tee -a build.log
  		echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH update" >> build.log
  		make GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH update >> build.log 2>&1
  		echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH clean" >> build.log
  		make GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH clean >> build.log 2>&1
  		echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH -j3" >> build.log
  		make GLUON_TARGET=$TARGET GLUON_BRANCH=$BRANCH -j3 >> build.log 2>&1
  		echo -e "\n\n\n============================================================\n\n" >> build.log
  done

  mv ~/gluon/output/images ~/gluon-site-config/images/$COMMUNITY
  echo "Compilation complete for $COMMUNITY"
done

echo "Done :)"
