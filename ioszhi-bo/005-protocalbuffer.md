##Protocol Buffer

**前言**
- 习惯用 Json、XML 数据存储格式的你们，相信大多都没听过Protocol Buffer
- Protocol Buffer 其实 是 Google出品的一种轻量 & 高效的结构化数据存储格式，性能比 Json、XML 真的强！太！多！


####一、定义
**一种 结构化数据 的数据存储格式（类似于 XML、Json ）**
- 1、Google 出品 （开源）
- 2、Protocol Buffer 目前有两个版本：proto2 和 proto3
目前用的比较多的是 **proto2**

####二、作用

**通过将 结构化的数据 进行 串行化（序列化），从而实现 数据存储 / RPC 数据交换的功能**
- 1、序列化： 将 数据结构或对象 转换成 二进制串 的过程。
- 2、反序列化：将在序列化过程中所生成的二进制串 转换成 数据结构或者对象 的过程

####三、特点
**对比于 常见的  XML、Json 数据存储格式，Protocol Buffer有如下特点：**


- **优点：**
    - 性能：
        - 体积小，序列化后数据大小可能缩小约3倍。
        - 序列化速度快，比XML 、JSON 快20~100 倍。
        - 传输速度，因为体积小，传输起来带宽和速度会有优化。
    
    - 使用方面：
        - 使用简单，Protocal 编译器自动进行序列化 和 反序列化。
        - 维护成本低，多平台仅需维护一套对象协议文件。
        - 向后兼容性好，
        - 加密型号，http传输内容抓包只能看到字节。
    - 使用范围方面：
        - 跨平台
        - 跨语言
        - 可拓展性好
- **缺点：**
    - 功能方面
        - 不适合用于基于文本的标记文档（如： HTML建模），因为文档不适合描述数据结构。
    - 其它方面
        - 通用性较差，XML 、JSON 已经成为多种行业的编写工具，而Protocal 只是Google公司内部s会用的工具。
        - 自解释性差，以二进制方式存储（不可读），需要通过protocal文件 才能了解到数据的结构。
        
- **总结：**
    - protocal Buffer 比XML 、JSON 更小、更快、使用维护更简单。
    
    
####四、应用场景
传输数据量大 & 网络环境不稳定 的数据存储、RPC 数据交换 的需求场景
> 如 即时IM （QQ、微信）的需求场景


####五、 使用流程

- 1、环境配置
    - 开始
    - 下载Protocal Buffer 
    - 安装 HomeBrew
    - 安装 Protocal Buffer
    
- 2、构建Protocal Buffer 消息对象模型
    - 通过 Protocal Buffer 语法描述需要存储的数据结构（.proto文件）
    - 通过Protocal Buffer 编译器编译.proto文件
    
- 应用到具体平台









