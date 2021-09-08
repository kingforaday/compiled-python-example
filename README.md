# Simple Compiled Python program example.

This is the source code to accompany a blog post:
<link>

```bash
docker run -it --volume ~/dev/compiled-python-example:/root/compiled-python-example ubuntu:latest

## Run from within the docker container:
apt install build-essential python3 python3-dev python3-pip -y
pip install pipenv
pipenv shell
pipenv install
```

Then navigate to the shared volume within the container and run `make`
```bash
cd /root/compiled-python-example
make
```

The output will be in the `build` folder.
