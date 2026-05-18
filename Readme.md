# Music Progression - 音乐软件打包项目

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub issues](https://img.shields.io/github/issues/yourusername/music-progression.svg)](https://github.com/yourusername/music-progression/issues)

> 三款老旧的打谱软件，低配电脑可用。**本工程主要学习如何进行软件打包。**

## 📋 目录

- [简介](#简介)
- [项目结构](#项目结构)
- [EyeSong](#eyesong)
- [GuitarPro](#guitarpro)
- [Overture](#overture)
- [技术栈](#技术栈)
- [安装说明](#安装说明)
- [使用说明](#使用说明)
- [贡献指南](#贡献指南)
- [许可证](#许可证)
- **[打包教程](#打包教程)**

## 简介

本项目包含了三款音乐打谱软件的打包和配置：

1. **EyeSong** - 远古时期的五线谱简谱软件，兼容Win10系统
2. **GuitarPro** - 吉他谱制作软件
3. **Overture** - 五线谱制作软件

本项目的主要目标是学习如何使用Inno Setup进行软件打包，并为低配置电脑提供可用的音乐软件解决方案。

## 项目结构

```
Music-Progression/
├── EyeSong/                 # EyeSong软件打包项目
│   ├── Eyesong.iss         # Inno Setup安装脚本
│   └── EyeSongDemo/        # 软件演示文件
├── GuitarPro/              # GuitarPro软件打包项目
│   ├── GuitarPro.iss       # Inno Setup安装脚本
│   └── GuitarPro/          # 软件主目录
├── Overture/               # Overture软件打包项目
│   ├── Overture5/          # 软件主目录
│   └── Overture.iss        # Inno Setup安装脚本
├── Readme/                 # 相关文档和图片
├── LICENSE                 # MIT许可证
└── README.md               # 项目说明文档
```

## EyeSong

作为一款远古时期的五线谱简谱软件，竟然能在Win10上正常使用。必然应该分享一波。

![EyeSong界面截图](Readme/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2d6bWluZzIwMDk=,size_16,color_FFFFFF,t_70.png)

### 特点
- 古老但功能完整的五线谱简谱软件
- 兼容现代Windows系统（Win10测试通过）
- 低配置电脑友好

## GuitarPro

专业的吉他谱制作软件，支持多种乐器和乐谱格式。

### 特点
- 专业的吉他谱制作工具
- 支持多种乐器音轨
- 丰富的乐谱编辑功能

## Overture

专业的五线谱制作软件，适合作曲家和音乐制作人使用。

### 特点
- 专业的五线谱编辑工具
- 支持多种乐器和音轨
- 适合作曲和编曲工作

## 技术栈

- **打包工具**: Inno Setup
- **脚本语言**: Pascal (Inno Setup脚本)
- **目标平台**: Windows
- **兼容性**: Windows 10/11

## 安装说明

### EyeSong安装

1. 进入 `EyeSong/` 目录
2. 运行 `Eyesong.iss` 脚本
3. 按照安装向导完成安装

### GuitarPro安装

1. 进入 `GuitarPro/` 目录
2. 运行 `GuitarPro.iss` 脚本
3. 按照安装向导完成安装

### Overture安装

1. 进入 `Overture/` 目录
2. 运行 `Overture.iss` 脚本
3. 按照安装向导完成安装

## 使用说明

各软件的使用说明请参考各自的官方文档或软件内的帮助文件。由于这些是老旧软件，建议在使用前：

1. 检查系统兼容性
2. 备份重要数据
3. 了解软件的基本操作

## 贡献指南

欢迎提交Issue和Pull Request来改进这个项目！

### 开发流程

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

## 许可证

本项目采用 [MIT](LICENSE) 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 打包教程

软件打包技术分享：[【打包教程】0vertrue/Gu1tar Pro6软件打包技术分享](https://ybcq.github.io/2019/03/01/%E3%80%90%E6%89%93%E5%8C%85%E6%95%99%E7%A8%8B%E3%80%910verture5%20Gu1tar%20Pro6%E8%BD%AF%E4%BB%B6%E6%89%93%E5%8C%85%E6%8A%80%E6%9C%AF%E5%88%86%E4%BA%AB/)

---

**作者**: 御坂初琴  
**最后更新**: 2025年
