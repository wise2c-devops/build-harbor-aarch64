# build-harbor-aarch64
Build an offline-deployable Harbor version for ARM64 architecture.

How to get the harbor-offline-installer-aarch64 package?

### Option1 （方法一）
直接从该项目的Release页面下载完整的离线包文件harbor-offline-installer-aarch64-v2.11.0.tgz

### Option2 （方法二）
下载离线镜像包
```
docker pull amy520/harbor_images_aarch64:v2.11.0
```

创建一个新的容器实例
```
TEMP_CONTAINER_ID=$(docker create amy520/harbor_images_aarch64:v2.11.0 /bin/true)
```

从容器中拷贝文件
```
docker cp $TEMP_CONTAINER_ID:/harbor-offline-installer-aarch64.tgz ./harbor-offline-installer-aarch64.tgz
```

删除容器实例
```
docker rm $TEMP_CONTAINER_ID
```
### 接下来便是正常安装过程了

以正常方式安装Harbor ARM64 Version
```
tar zxf harbor-offline-installer-aarch64.tgz
cd harbor
cp harbor.yml.tmpl harbor.yml
```

适当修改harbor.yml文件内容

vi harbor.yml

```
install.sh
```

![Harbor-v2.11.0-Aarch64](https://github.com/wise2c-devops/build-harbor-aarch64/assets/3273357/49ce7cc3-918e-421c-86d9-2c06e9b42bb3)
