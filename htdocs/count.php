<?php
session_start();//定义session，同一IP登录不累加
$filepath = 'count.txt';
$_SESSION['temp'] = 0;
if ($_SESSION['temp'] == '')//判断$_SESSION[temp]的值是否为空,其中的temp为自定义的变量
{
 if (!file_exists($filepath))//检查文件是否存在，不存在刚新建该文件并赋值为0
 {
 $fp = fopen($filepath,'w');
 fwrite($fp,0);
  fclose($fp);
  counter($filepath);
 }else
 {
  counter($filepath);
 }
 $_SESSION['temp'] = 1;//登录以后,给$_SESSION[temp]赋一个值1
}
$php_test=file_get_contents($filepath);
echo "var test='$php_test';"; 
//counter()方法用来得到文件内的数字
function counter($f_value)
{
 //用w模式打开文件时会清空里面的内容，所以先用r模式打开，取出文件内容，保存到变量
 $fp = fopen($f_value,'r') or die('打开文件时出错。');
 $countNum = fgets($fp,1024);
 fclose($fp);
 $countNum++;
 $fpw = fopen($f_value,'w');
 fwrite($fpw,$countNum);
 fclose($fpw);
}
//注释下面一行可以实现同一IP登录不累加效果，测试时可以打开
session_destroy();
?>
