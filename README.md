# dotfiles
个人的 ubuntu dotfiles文件

## 快速开始

### 安装
```bash
# 使用PIP安装Mackup
pip install --upgrade mackup
```

### 备份
```bash
# 备份文件
mackup backup
```
### 恢复
```bash
# 恢复文件
mackup restore
```

## 配置

### 配置文件
所有配置都在名为.mackup.cfg存储在主文件夹根目录的文件中完成。
要配置Mackup，请在主目录中创建名为“.mackup.cfg”的文件。
```bash
vi ~/.mackup.cfg
```
通过包含configuration_files标题添加要同步的个人文件，例如
```bash
[configuration_files] 
.gitignore_global 
.config/your-custom-file
```
请注意，Mackup假定此处列出的文件路径与您的主目录相关。

### 储存
您可以指定Mackup将用于存储配置文件的存储类型。现在你有4个选项：dropbox，google_drive，copy和file_system。如果没有指定，Mackup将尝试使用默认值：dropbox。使用dropbox存储引擎，Mackup将自动找出您的Dropbox文件夹。

#### Google云盘
```bash
[storage] 
engine = dropbox
```

#### 文件系统
如果你想指定另一个目录，你可以使用file_system引擎，并设置path。
```bash
[storage]
engine = file_system
path = some/folder/in/your/home
# or path = /some/folder/in/your/root
```
