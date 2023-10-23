# build-harbor-aarch64
Build an offline-deployable Harbor version for ARM64 architecture.

How to get the harbor-offline-installer-aarch64 package?

```
# 下载离线镜像包
docker pull alanpeng/harbor_images_aarch64:v2.7.2

# 创建一个新的容器实例
TEMP_CONTAINER_ID=$(docker create alanpeng/harbor_images_aarch64:v2.7.2)

# 从容器中拷贝文件
docker cp $TEMP_CONTAINER_ID:/harbor-offline-installer-aarch64.tgz ./harbor-offline-installer-aarch64.tgz

# 删除容器实例
docker rm $TEMP_CONTAINER_ID

# 以正常方式安装Harbor ARM64 Version
tar zcf harbor-offline-installer-aarch64.tgz
cd harbor
cp harbor.yml.tmpl harbor.yml

# 适当修改harbor.yml文件内容
vi harbor.yml
install.sh
```
