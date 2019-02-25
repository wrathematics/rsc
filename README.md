# rsc

Some build scripts to help with bootstrapping an R+pbdR environment on some of the supercomputers I regularly run on. Run the bootstrap script from the shared file system (lustre/gpfs/whatever).

* load the appropriate R module or build locally with the buildr script if there's no system installation
* packages are in src/. build with the pkgbuild script
* run job from the bootstrap dir
