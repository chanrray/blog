###UEFI启动引导修复学习笔记（基本万能）(2月25日更新)  
  本帖最后由 Roger抱大树菠萝 于 2015-2-25 11:50 编辑

[原帖地址](http://bbs.pcbeta.com/viewthread-1578044-1-1.html)  

致读者<br>
本文分享的修复方法是比较原始的、基于半手动或者全手动修复UEFI启动
其优点在于能够根据具体情况作出具体的修复方案，从而能修复99%以上的UEFI启动问题，故称基本万能
相比起无论什么原因都用EFI引导修复工具鼓捣一通，本文分享的修复方案更加灵活
同时，通过本文分享的修复方案，你对UEFI启动有更加深入的理解，让大家从此不再畏惧UEFI

注明

本学习笔记是本人学习无忧启动论坛UEFI区版主2011hiboy的帖子以及视频教程后整理所得，
我主要做了一下搬运工的工作，帖子提出的修复方法都是由2011hiboy提出，故在此向2011hiboy表示感谢！
由于本文原理部分也是转自2011hiboy的帖文，其宗旨是分享学习技术，
希望景友们二次转载时表明原始出处：[无忧bbs](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=303679)




前提
以下所有bcdboot命令在PE中操作完成，且要求PE是以UEFI模式启动的；如果景友们使用非UEFI启动的PE，那么bcdboot命令中还要用/f uefi参数来指定启动类型是传统BIOS启动。

具体关于bcdboot命令的用法，可以打开CMD，然后用以下命令查看：
`bcdboot /?`



#####板块1：直截了地先摆上这篇文章的核心内容，如何半手动或手动修复UEFI启动！（不想了解原理的可以只看这部分）

UEFI系统启动引导出错分类示意图如下图。



<img src="https://github.com/chenrui95/blog/raw/master/imagecache/qzone-blog/uefi-xiufu-wannengbiji/修复情况分解图.jpg" width = "600" height = "400">



A模块
Bcdboot命令修复成功的前提是：ESP分区存在且系统文件完好无损。


系统文件完好无损的含义：
C:\Windows\Boot目录下的EFI文件夹存在且里面的文件完好无损

系统文件部分丢失的含义
C:\Windows\Boot目录下的EFI文件夹里面的文件有缺失

A-1（系统文件完好无损）修复方法
修复命令：
`bcdboot C:\Windows /l zh-CN`


A-2（系统文件部分丢失）修复方法
先按照系统对应关系把正常系统中的C:\Windows\Boot目录下的EFI文件夹复制出来，还原到本机系统盘的相同位置；
然后用以下修复命令修复：
`bcdboot C:\Windows /l zh-CN`



B模块
1、ESP分区分析（这一部分的详细解释将会在板块2：UEFI启动原理概述详细说明）
a)  ESP分区中的  \EFI\Boot\bootx64.efi  是计算机默认引导，即该文件若存在，计算机默认启动项（硬盘启动）即可使用；
b)  ESP分区中的  \EFI\Microsoft\Boot\bootmgfw.efi  是Windows默认引导文件，当该文件存在，且ESP分区中的所有目录设置正确、bootx64.efi存在时，Windows Boot Manager启动项才可使用。


ESP分区目录树结构如下图。


 <img src="https://github.com/chenrui95/blog/raw/master/imagecache/qzone-blog/uefi-xiufu-wannengbiji/espshu.jpg" width="600" height="400">


PS：
对于Windows来说，bootx64.efi和C:\Windows\Boot\EFI里面的bootmgfw.efi是内容相同但文件名字不同的两个文件，因此bootx64.efi可以通过正常系统下的C:\Windows\Boot\EFI\bootmgfw.efi重命名为bootx64.efi获得。



2、B模块修复方法
对于B模块的修复，这里只讲对ESP分区的修复，修复后即可用A模块中的A-1或A-2修复方法来修复UEFI引导。
B模块的修复方法如下：
1.  重建一个260MB的FAT32分区（ESP分区的本质就是一个FAT32分区）并挂载，设挂载的盘符为H:
2.  接着用以下命令修复计算机默认引导
`bcdboot C:\Windows /s H: /l zh-CN`



补充（手动修复UEFI计算机默认引导教程）
1.  用diskpart命令挂载ESP分区；
2.  在挂载后的ESP分区建立如图2所示的文件目录；
3.  从对应系统中的C:\Windows\Boot\EFI中提取bootmgfw.efi到挂载后的ESP分区中的\EFI\Boot中，
并重命名为：bootx64.efi；
4.  用Bootice软件在ESP分区中的\EFI\Microsoft\Boot中新建BCD，并设置为如下图所示的状态；
5.  重启完成修复。

BCD设置图
 <img src="https://github.com/chenrui95/blog/raw/master/imagecache/qzone-blog/uefi-xiufu-wannengbiji/bcd设置.jpg" width="600" height="600">


小结
综上所述，能够修复99%的UEFI启动失败问题。
如果启动后，在看到系统启动的GUI界面（Windows标识）后再出现开机失败的情况，则一般不属于启动引导问题，而是系统有别的损坏等。






#####板块2：关于Windows Boot Manager、Bootmgfw.efi、Bootx64.efi、bcdboot.exe 的详解
（转自无忧启动论坛UEFI区版主2011hiboy的帖文：[无忧bbs](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=303679)）


前言：
1、本教程针对于UEFI启动来叙述的，根据普遍的支持UEFI的机器来叙述
2、本教程以Windows 8 X64 来作为参考

标题简要说明：
Windows Boot Manager  --------安装完Windows系统后而出现的启动选项（相关的信息存储在NVRAM），可以删除和建立和bcdboot.exe有关

Bootmgfw.efi  --------引导Windows的引导文件  

Bootx64.efi ---------UEFI的必需引导文件

bcdboot.exe--------修复UEFI启动的命令行工具，微软出品


开始前先引进两个概念：

计算机默认引导  -----------就是不管你的计算机有没有操作系统，定义了UEFI启动后将通过Bootx64.efi 引导你的计算机，并进入各种模式，维护、安装、计算机或者系统。这里是 Bootx64.efi ，它只是一个通用名，权限丰富且大于Windows 默认，就是说如果你的Windows 默认的启动文件不在了，启动计算机默认的引导文件Bootx64.efi 也是可以启动计算机的。使用计算机默认文件随时可以在各种环境下启动计算机，EFI SHELL、ISO、Windows、Linux...都可以，通吃型.

Windows默认引导 -------就是你为计算机安装了操作系统，或者修复了UEFI引导后，启动菜单会有 Windows Boot Manager 选项，该选项默认从bootmgfw.efi 启动系统。bootmgfw.efi 只能用于启动Windows，不是通用名，权限单一


part 0
对于UEFI启动环境来说，Bootx64.efi 用处更大，这里Bootx64.efi 是个通用名，就是所任意有效的efi改成Bootx64.efi 都被计算机启动加载，并启动。
bootmgfw.efi 不是通用名，只适合启动Windows。

当然对于UEFI启动Windows来说Bootx64.efi 和bootmgfw.efi 其实是同一个文件，二者的循环冗余校验CRC值是一样的。
他们都有启动windows的能力，但是身处的位置不一样，

efi\boot\bootx64.efi 
efi\microsoft\boot\bootmgfw.efi

对系统的引导产生的影响肯定也不一样，下面我们来验证....

========================================================

从三个方向来讲：（以下结论都经过事实验证，经得住任何怀疑和猜测！！）


part 1


光盘介质UEFI启动【已验证】：
通过分析微软原装镜像的UEFI引导记录(efisys.bin)我发现，最初出光盘的引导文件是efi\boot\bootx64.efi，因为此项验证较简单，我总共验证了：
win7 x64 ；win8 x86 ；win8 x64 三者的光盘引导文件分别是 bootx64.efi  bootia32.efi  bootx64.efi

结论：
UEFI在光盘上的启动不依赖于操作系统，可认为是无操作系统环境，故 bootx64.efi 是计算机默认引导文件


========================================================

part 2
移动磁盘介质UEFI启动【已验证】：

普遍的，可以从论坛上看到通过bootx64.efi 启动U盘

结论：
UEFI在移动磁盘介质上的启动不依赖于操作系统，可认为是无操作系统环境，故 bootx64.efi 是计算机默认引导文件

========================================================

part 3
本地磁盘介质UEFI启动【已验证】：

::原生ESP分区引导文件分析

我为此安装了微软win8 x64的操作系统，分析ESP分区的全部文件，分别存在：  

efi\boot\bootx64.efi   

efi\microsoft\boot\bootmgfw.efi

我们不禁思考：哪个文件测试真正用到的呢？计算机默认启动哪个呢？系统默认启动哪个呢？

那好很简单，我们依次删除他们看看系统能否启动就知道了....

1、删除 bootmgfw.efi ，保留 bootx64.efi  

>结果：
选择 从本地硬盘启动 系统仍然可以引导进入
选择 Windows Boot Manager 进入失败


2、删除 bootx64.efi ，保留 bootmgfw.efi  

>结果：
选择 从本地硬盘启动 进入失败
选择 Windows Boot Manager 系统仍然可以引导进入

结论：
bootx64.efi 是计算机默认引导文件
bootmgfw.efi 是 Windows默认引导文件

========================================================


part 4
bcdboot 和 “Windows Boot Manager ” “ Bootmgfw.efi” “  Bootx64.efi ” 之间的联系

bcdboot 修复系统引导的命令格式： bcdboot 系统位置 /l 语言
例如：
bcdboot c:\windows /l zh-cn

[color=rgb(51, 102, 153) !important]复制代码


当我们执行了上述代码后:

bcdboot.exe 会修复系统引导，而且会同时修复计算机默认引导和Windows 默认引导，在ESP分区同时出现bootx64.efi和bootmgfw.efi，

并且bootx64.efi是由bootmgfw.efi 改名而来的。与此同时在Boot Menu启动选择菜单那里生成“Windows Boot Manager”，

Windows Boot Manager 及其包含的信息是保存在主板上的NVRAM里面的，而不是保存在硬盘上，故删除Windows Boot Manager需要到BIOS设置区删除。

::这里我们如果通过bcdedit查看bcd文件的话，我们可以发现，bootmgfw.efi 是 Windows默认引导文件。所以我们的结论同原生ESP分区测试的结论一样。

UEFI规范中，关于NVRAM的正解：
NVRAM是BIOS ROM中的一段区域，一般定义为64k byte, 现在EFI把所有的变量都存在这里。

结论：
bootx64.efi 是计算机默认引导文件
bootmgfw.efi 是 Windows默认引导文件








#####板块3：对板块2的总结
（转自无忧启动论坛UEFI区版主2011hiboy的帖文：[bbs](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=303679)）

（同时分享2011hiboy制作的视频教程给景友，希望帮到更多的景友！）


通过上面的验证可以知道UEFI下修复Windows 引导可以分为：修复计算机默认引导和Windows默认引导。

比较通用的是修复计算机默认引导，如果你能够会UEFI下手动/自动修复计算机默认引导，那么修复Windows 默认引导也不在话下，

从UEFI层面上说，Windows其实是计算机的一个efi应用，它被计算机包含了。所以修复计算机默认引导才是万能的。

当然，在不会手动修复的时候，bcdboot还是很有用的，正常情况下都能修复。只要你的系统没有经过过度精简，bcdboot应该都能搞定，
能够学会手动修复就不用担心这些了。


下方是一个手动修复计算机默认引导的视频教程，在一楼底部，视频看起来很直观，一看就懂。修复计算机默认引导后，我们可以直接引导Windows，而可以不必理会Windows默认引导是否存在或者是否正确。

【完美版】挂载GPT磁盘的ESP分区的批处理+手动修复UEFI+GPT系统引导视屏教程
[bbs](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=300068&fromuid=396698)


计算机默认引导的一些文件参考：
UEFI启动详解：启动分析+N项操作实例，赶紧进来学习，不要落伍啦，该给自己充电咯...
[bbs](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=299643&fromuid=396698)
