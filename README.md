# ydu-101-mono

language mastering repo

## Setup New Dev station

```shell
# @act=set kind=current.working.dir dir=_devspace/get-started-mini
cd _devspace/get-started-mini

# @act=anounce kind=install.stage desc='minimal os tools'
./task.ensure-base-os-tools.sh install-all

# @act=declare kind=install.stage desc='developer env settings'
./task.ensure-base-dev-space.sh.yml install-all
```


