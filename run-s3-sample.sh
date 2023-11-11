mkdir crt
mkdir build
cd crt
git clone https://github.com/awslabs/aws-lc.git
git clone https://github.com/aws/s2n-tls.git
git clone https://github.com/awslabs/aws-c-common.git
git clone https://github.com/awslabs/aws-checksums.git
git clone https://github.com/awslabs/aws-c-cal.git
git clone https://github.com/awslabs/aws-c-io.git
git clone https://github.com/awslabs/aws-c-compression.git
git clone https://github.com/awslabs/aws-c-http.git
git clone https://github.com/awslabs/aws-c-sdkutils.git
git clone https://github.com/awslabs/aws-c-auth.git
git clone -b env_detection_waqar https://github.com/awslabs/aws-c-s3.git


cmake -S aws-lc -B aws-lc/build -DCMAKE_INSTALL_PREFIX=~/work/build  -DCMAKE_BUILD_TYPE=Debug -DDISABLE_GO=ON
cmake --build aws-lc/build --target install

cmake -S s2n-tls -B s2n-tls/build -DCMAKE_INSTALL_PREFIX=~/work/build -DCMAKE_PREFIX_PATH=~/work/build  -DCMAKE_BUILD_TYPE=Debug
cmake --build s2n-tls/build --target install


cmake -S aws-c-common -B aws-c-common/build -DCMAKE_INSTALL_PREFIX=~/work/build  -DCMAKE_BUILD_TYPE=Debug
cmake --build aws-c-common/build --target install


cmake -S aws-checksums -B aws-checksums/build -DCMAKE_INSTALL_PREFIX=~/work/build -DCMAKE_PREFIX_PATH=~/work/build  -DCMAKE_BUILD_TYPE=Debug
cmake --build aws-checksums/build --target install


cmake -S aws-c-cal -B aws-c-cal/build -DCMAKE_INSTALL_PREFIX=~/work/build -DCMAKE_PREFIX_PATH=~/work/build  -DCMAKE_BUILD_TYPE=Debug
cmake --build aws-c-cal/build --target install


cmake -S aws-c-io -B aws-c-io/build -DCMAKE_INSTALL_PREFIX=~/work/build -DCMAKE_PREFIX_PATH=~/work/build -DUSE_S2N=ON  -DCMAKE_BUILD_TYPE=Debug
cmake --build aws-c-io/build --target install


cmake -S aws-c-compression -B aws-c-compression/build -DCMAKE_INSTALL_PREFIX=~/work/build -DCMAKE_PREFIX_PATH=~/work/build -DCMAKE_BUILD_TYPE=Debug
cmake --build aws-c-compression/build --target install


cmake -S aws-c-http -B aws-c-http/build -DCMAKE_INSTALL_PREFIX=~/work/build -DCMAKE_PREFIX_PATH=~/work/build -DCMAKE_BUILD_TYPE=Debug
cmake --build aws-c-http/build --target install


cmake -S aws-c-sdkutils -B aws-c-sdkutils/build -DCMAKE_INSTALL_PREFIX=~/work/build -DCMAKE_PREFIX_PATH=~/work/build -DCMAKE_BUILD_TYPE=Debug
cmake --build aws-c-sdkutils/build --target install


cmake -S aws-c-auth -B aws-c-auth/build -DCMAKE_INSTALL_PREFIX=~/work/build -DCMAKE_PREFIX_PATH=~/work/build -DCMAKE_BUILD_TYPE=Debug
cmake --build aws-c-auth/build --target install


cmake -S aws-c-s3 -B aws-c-s3/build -DCMAKE_INSTALL_PREFIX=~/work/build -DCMAKE_PREFIX_PATH=~/work/build -DCMAKE_BUILD_TYPE=Debug
cmake --build aws-c-s3/build --target install


~/work/crt/aws-c-s3/build/samples/s3/s3 platform-info -v TRACE