GIT_BRANCH="v2.9.1"

# first step: clone harbor ARM code
git clone https://github.com/goharbor/harbor-arm.git

# Replace dev-arm image tag
sed -i "s#dev-arm#${GIT_BRANCH}-arm#g" harbor-arm/Makefile

# execute build command：Download harbor source code
cd harbor-arm
git clone --branch ${GIT_BRANCH} https://github.com/goharbor/harbor.git src/github.com/goharbor/harbor

mkdir v2.7.2
cd v2.7.2
git clone --branch v2.7.2 https://github.com/goharbor/harbor.git src/github.com/goharbor/harbor
#rm -f ../harbor/Makefile
rm -f ../harbor/make/photon/Makefile
#cp harbor/Makefile ../harbor/Makefile
cp harbor/make/photon/Makefile ../harbor/make/photon/Makefile

# Fix the issue of "missing separator (did you mean TAB instead of 8 spaces?)"
#sed -i 's/^[[:space:]]*/	/g' harbor/Makefile
#sed -i 's/^[[:space:]]*/        /g' harbor/make/photon/Makefile

# compile redis:
make compile_redis

# Prepare to build arm architecture image data:
make prepare_arm_data

# Replace build arm image parameters：
make pre_update

# Compile harbor components:
make compile COMPILETAG=compile_golangimage

# Build harbor arm image:
make build GOBUILDTAGS="include_oss include_gcs" BUILDBIN=true NOTARYFLAG=true TRIVYFLAG=true CHARTFLAG=true GEN_TLS=true PULL_BASE_FROM_DOCKERHUB=false
