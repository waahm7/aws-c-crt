#sudo yum install python3-pip git cmake gcc g++
sudo mkfs -t xfs /dev/nvme1n1 #format
sudo mount /dev/nvme1n1 data #mount
sudo chown $(whoami):$(whoami) data -R
cd data
mkdir work
cd work
mkdir build
git clone https://github.com/awslabs/aws-crt-s3-benchmarks
sudo ./aws-crt-s3-benchmarks/scripts/install-tools-AL2023.py
cd aws-crt-s3-benchmarks/scripts
python3 -m pip install -r requirements.txt

# python3 ./prep-build-run-benchmarks.py --bucket waqar-aws-c-s3-test-bucket --region us-west-2 --throughput 100 --build-dir ../../build --files-dir ../../files --s3-clients crt-c --workloads ../workloads/upload-Caltech256.run.json ../workloads/upload-Caltech256Sharded.run.json ../workloads/upload-c4-en.run.json
# M6
# python3 ./prep-build-run-benchmarks.py --bucket waqar-aws-c-s3-test-bucket --region us-west-2 --throughput 150 --build-dir ../../build --files-dir ../../files --s3-clients crt-c --workloads ../workloads/download-30GiB-1x.run.json


python3 ./prep-build-run-benchmarks.py --bucket waqar-aws-c-s3-test-bucket --region us-west-2 --throughput 150 --build-dir ../../build --files-dir ../../files --s3-clients sdk-java-client-classic --workloads ../workloads/download-30GiB-1x-ram.run.json ../workloads/download-5GiB-1x-ram.run.json ../workloads/download-Caltech256-ram.run.json  ../workloads/download-Caltech256Sharded-ram.run.json  ../workloads/upload-30GiB-1x-ram.run.json ../workloads/upload-5GiB-1x-ram.run.json   ../workloads/upload-Caltech256-ram.run.json ../workloads/upload-Caltech256Sharded-ram.run.json

python3 ./prep-build-run-benchmarks.py --bucket waqar-aws-c-s3-test-bucket --region us-west-2 --throughput 150 --build-dir ../../build --files-dir ../../files --s3-clients crt-c --workloads ../workloads/download-5GiB-1x-ram.run.json
