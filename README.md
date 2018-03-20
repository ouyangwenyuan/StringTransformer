# 字符串转化小软件 （Mac 版）
Android strings.xml  and iOS Localizable.strings and iOS  plist , words  transform

这个小软件主要是在我开发学单词的App过程中方便国际化而写的一个mac小程序



## xml，plist ，strings格式转换器


## 1、产品实现功能
	这个软件主要是给英语练习app做的一个工具类，可以提取单词列表给运营人员做翻译，也方便将运营翻译后的单词转成我们需要的plist 格式文件，也可以成对应的xml文件给google翻译或者android app 的国际化string 文件，同时还支持转化成ios 的国际化localizable.strings文件。不仅如此，还支持plist 反转化成xml，xml反转化成单词列表，localizable.strings反转化成单词列表。 支持文件导入和实时编辑。

## 功能如下：
1、文本文件（文字词组，每个词组占一行）转成xml文件
2、2个文本词组转化xml文件，第一个文本做key，第二个文本做value，注意俩个文本每一行一一对应。
3、xml 转 plist文件，可以转成days下面的每八个词的词组，也可以转成根结点下的词组
4、plist 转化成xml文件
5、2个文本词组转成Ios的localizable.strings的文本。
6、localizable.strings 转成俩个词组
7、xml转成 俩个词组
8、支持文件导入，支持直接编辑
9、支持文本，xml，plist格式导出

## 2、注意：
选择的文件格式请确保正确，否则会出现一些奇怪的问题，
比如单词列表为每行一个词或者词组，如果是转化成android 的strings文件，请确保key值列表的每一行单词不要出现空格，多个单词可以用下划线连接。
xml文件是Android标准的国际化strings 格式文件
plist 也请确保是苹果公司的标准格式

## 具体操作
1、文本文件（文字词组，每个词组占一行）转成xml文件
 点击 打开key单词列表 按钮， 找到单词文件，打开文件，然后点击 转化xml 按钮，生成xml文件，然后点击 导出txt/xml 按钮

2、2个文本词组转化xml文件，第一个文本做key，第二个文本做value，注意俩个文本每一行一一对应。
 点击 打开key单词列表 按钮， 找到单词文件，打开文件，
然后 点击 打开words或xml文件，选择翻译文件，打开文件，
点击第二个 转化xml 按钮，生成xml文件，然后点击第二个 导出txt/xml 按钮

3、xml 转 plist文件，可以转成days下面的每八个词的词组，也可以转成根结点下的词组
点击 打开words或xml文件，选择xml文件，打开文件，
然后点击 转化plist 按钮，转化文件
如果是单词列表，点击 背单词plist 导出成单词列表的plist文件
如果是ui国际化，点击 导出strings.plist 导出国际化的plist文件

4、plist 转化成xml文件
点击 反转plist 按钮，选择plist文件，打开文件，

5、2个文本词组转成Ios的localizable.strings的文本。
 点击 打开key单词列表 按钮， 找到单词文件，打开文件，
然后 点击 打开words或xml文件，选择翻译文件，打开文件，
然后 点击 转化local.strings按钮，生成strings文件，然后点击第二个 导出local.string 按钮

6、localizable.strings 转成俩个词组
点击 反转strings 按钮，选择localizable.strings文件，打开文件，

7、xml转成 俩个词组
点击 打开words或xml文件，选择xml文件，打开文件，
然后点击 xml转化单词列表 按钮，转化出俩个单词列表
然后点击 导出txt/xml 按钮，导出txt 格式文件

## 目前软件还存在俩个小问题待解决
1、点左上脚关闭按钮关闭程序后程序没有退出，而只是界面关闭，在dock中点击程序图标不能显示界面，需要退出重启才能看到界面
2、不同的文本区域需要点击右键才能获得焦点，点击左键不行。



