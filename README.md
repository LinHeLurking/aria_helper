# Aria2 及其前端的自动下载脚本

## 使用方法

> 仅限 Windows 上通过 PowerShell 使用

通过 `.\start.ps1` 启动, 首次启动时会下载相应组件. 如果无法正常启动请通过 `.\reinstall.ps1` 重新下载.

## 下载说明

下述某些情形下可能需要通过 GitHub release 下载二进制程序. 考虑到 GitHub 在某些位置的访问速度, 每次下载前脚本会询问你一个代理服务器. 请提供给脚本一个 HTTP 代理地址(而不是 Socks 代理地址). 如果不需要脚本(~~或者不知道这段说的啥的~~)可以直接 enter, 相当于无代理.

然而实际的测试表明, 在不使用代理的情况下, 下载过程会非常, 非常漫长.

### Aria2

- 环境变量中可以找到 aria2c: 不下载
- 环境变量中无法找到 aria2c:
  - 存在 scoop: 通过 scoop 下载 aria2
  - 不存在 scoop: 通过 GitHub Release 下载最新版 aria2

### AriaNg

前端通过 AriaNg 提供. 根据系统内已存在软件的不同, 有这样两种下载方式.

- 不存在 node & npm: 下载单文件版本 AriaNg, `start.ps1` 将通过浏览器打开该单文件
- 存在 node & npm: 下载普通版本 AriaNg 并通过 npm 安装 http-server, `start.ps1` 将通过 http-server 启动前端

两种方式都是通过 GitHub Release 下载 AriaNg 的.

## 终止

提供了 `stop.ps1` 脚本可以终止启动的进程. **但是**, 由于 aria2 会启动多个线程, 最初启动的那个线程号只能用于关闭一个线程, 对此, 你可以通过 `.\stop.ps1 -byName 1`, 来解决. 但是需要注意的是, 如果你电脑上存在同名进程, 会被一并关闭掉, 请慎重使用.

## 贡献

欢迎提交修改至本仓库.
