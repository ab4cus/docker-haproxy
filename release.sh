set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=e4cash
# image name
IMAGE=haproxy
# version
VERSION=1.8.13

# ensure we're up to date
git pull

# bump version
#docker run --rm -v "$PWD":/app treeder/bump patch
docker run --rm -v "$PWD":/build $USERNAME/$IMAGE-$VERSION haproxy -v
version=`cat VERSION`
echo "version: $version"

# run build
./build.sh

# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags

docker tag $USERNAME/$IMAGE-$VERSION:latest $USERNAME/$IMAGE-$VERSION:$version

# push it
docker push $USERNAME/$IMAGE-$VERSION:latest
docker push $USERNAME/$IMAGE-$VERSION:$version
