echo "将构建python3.7镜像"
echo "net.Dockerfile 通过网络的方式获取python包并安装 python 3.7, 依赖get-pip.py"
echo "make.Dockerfile 通过编译的方式在ubuntu20.04中安装 python3.7.13, 依赖Python 3.7.13.tgz"

echo "请选使用的Dockerfile"
docker build --progress=plain --cache-from ad_adp_base:2.3 --build-arg BUILDKIT_INLINE_CACHE=1 --tag ad_adp_base:2.3 --file Dockerfile .
