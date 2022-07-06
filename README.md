# znote

A new Flutter project.

## Getting Started

自动生成代码
```
flutter packages pub run build_runner build
```

```
# 使用下面命令打开平台支持 
> flutter config --enable-windows-desktop
# 使用下面命令关闭某个平台支持
 > flutter config --no-enable-windows
```

```
flutter run -d windows
```

```
> flutter build windows
```

```
myapp/build/windows/runner/Release/
```

创建windows的`msix`安装包
```
> flutter pub run msix:create
```