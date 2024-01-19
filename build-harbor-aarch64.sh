GIT_BRANCH="v2.10.0"

# first step: clone harbor ARM code
git clone https://github.com/alanpeng/harbor-arm.git

# Replace dev-arm image tag
sed -i "s#dev-arm#${GIT_BRANCH}-arm#g" harbor-arm/Makefile

# execute build command：Download harbor source code
cd harbor-arm
git clone --branch ${GIT_BRANCH} https://github.com/alanpeng/harbor.git src/github.com/goharbor/harbor
#git clone https://github.com/alanpeng/harbor-multi-arch
#echo $GIT_BRANCH > harbor-multi-arch/version
#cd harbor-multi-arch
#make all

#cd ..
#mkdir -p src/github.com/goharbor/
#mv harbor-multi-arch/harbor src/github.com/goharbor/

# compile redis:
make compile_redis

# Prepare to build arm architecture image data:
make prepare_arm_data

# Replace build arm image parameters：
make pre_update

# Compile harbor components:
make compile COMPILETAG=compile_golangimage

# Build harbor arm image:
#make build GOBUILDTAGS="include_oss include_gcs" BUILDBIN=true NOTARYFLAG=false TRIVYFLAG=true CHARTFLAG=false GEN_TLS=true PULL_BASE_FROM_DOCKERHUB=false
make build GOBUILDTAGS="include_oss include_gcs" BUILDBIN=true TRIVYFLAG=true GEN_TLS=true PULL_BASE_FROM_DOCKERHUB=false
