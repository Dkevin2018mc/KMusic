require "import"
require "xiaodanche"
import "android.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.io.File"
cjson = require "cjson"


MD主题()
载入布局("layout")
主题配置("KMusic+ V1.1 Beta",0xff19a2f7,0xff158bd3)

function onCreateOptionsMenu(menu)
  menu.add("帮助").onMenuItemClick=function(a)
    help = "[简介]\n欢迎使用KMusic 这是一个萌萌哒App 可以通过音乐App分享链接解析出真实音频文件地址和信息并下载 支持批量操作\n[使用帮助]\n&找到你喜欢的歌曲或歌手\n&点击分享按钮->复制链接\n&粘贴到这里->点击GO!\n&你可以直接点击歌曲名查看详细信息并下载\n&也可以选择批量操作一键下载所有解析结果\n[特殊]\n网易云音乐链接需要在 https://music.163.com/ 后面加 m/ 否则无法匹配正则表达式\n[作者]QQ:3407053348"
    AlertDialog.Builder(this)
    .setTitle("帮助")
    .setMessage(help)
    .setPositiveButton("已阅!",nil)
    .show()
  end
  menu.add("鸣谢").onMenuItemClick=function(a)
    thanks = "KMusic使用了以下GitHub项目:\n#MCMusic\n#APlayer"
    AlertDialog.Builder(this)
    .setTitle("向开源致敬")
    .setMessage(thanks)
    .setPositiveButton("已阅!",nil)
    .show()
  end
  menu.add("联系作者").onMenuItemClick=function(a)
    import "android.net.Uri"
    import "android.content.Intent"
    url="mqqapi://card/show_pslcard?src_type=internal&version=1&uin=697996691&card_type=group&source=qrcode"
    activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))

  end
end



File("/sdcard/KMusic/Download/").mkdirs()

function file_exists(path)
  local f=io.open(path,'r')
  if f~=nil then io.close(f) return true else return false end
end

import "android.graphics.PorterDuffColorFilter"
import "android.graphics.PorterDuff"
button.getBackground().setColorFilter(PorterDuffColorFilter(0xff19a2f7,PorterDuff.Mode.SRC_ATOP))

version = 2
url = "https://www.owohi.top/km-api/version/?v="..version

Http.get(url,nil,nil,nil,function(a,b,c)
  if(a == 200 and b ~= "") then
    r = cjson.decode(b) 
    if(r.result == "200") then
      if(r.isNowAPP == "true") then
        AlertDialog.Builder(this)
        .setTitle("٩(๑^o^๑)۶公告")
        .setMessage(r.notice)
        .setPositiveButton("知道啦~",nil)
        .show()
      else
        AlertDialog.Builder(this)
        .setTitle("(≧∇≦)/有更新哦")
        .setMessage("更新内容:"..r.update_thing.."\n下载地址:"..r.durl)
        .setCancelable(false)
        .setPositiveButton("下载更新",{onClick=up})

        .show() 
      end
    else
      AlertDialog.Builder(this)
      .setTitle("ヽ(≧Д≦)ノ服务器不对劲")
      .setMessage("客户端版本太低, 或服务器已经跑路.\n请联系作者获取更新!\nQQ:3407053348")
      .setCancelable(false)
      .setPositiveButton("退出",{onClick=function() 结束程序() end})
      .show() 
    end
  else
    AlertDialog.Builder(this)
    .setTitle("(°ー°〃)服务器连不上了")
    .setMessage("请检查网络, 或服务器可能已经跑路.\n请联系作者获取更新!\nQQ:3407053348")
    .setCancelable(false)
    .setPositiveButton("退出",{onClick=function() 结束程序() end})
    .show()
  end
end)

button.onClick = function()
  ei = ed.text;
  if(ei ~= "") then
    url = "https://www.owohi.top/km-api/?u="..ei
    loadMusic=显示加载框("客官请稍等!","正在解析中...",true,false)
    Http.get(url,nil,nil,nil,function(e,d,f)
      if(d ~= '{"data":null,"code":200,"error":""}\n') then
        r = cjson.decode(d)
        t = luajava.astable(r.data)
        if(t ~= "" and t ~= nil) then
          n = 0
          a = {}
          items={}
          for key, value in ipairs(t) do 
            n = n + 1
            a[n] = luajava.astable(t[n])
            items[n]=a[n]["title"].." "..a[n]["author"]
          end

          AlertDialog.Builder(activity)
          .setTitle("解析出: "..n.."条内容")
          .setItems(items,{onClick=function(dialog,index)
              local selectItem=items[index+1]
              this.newActivity("song",{t,index+1})
            end})
          .setPositiveButton("批量操作(列表)",function() this.newActivity("list",{d}) end)
          .show()
          MD提示("解析成功啦 ( ੭ ˙ᗜ˙ )੭")
        else
          AlertDialog.Builder(this)
          .setTitle("ヽ(≧Д≦)ノ炸了")
          .setMessage("数据异常:"..t)
          .setPositiveButton("再试一次呗",nil)
          .show()
        end
      else
        MD提示("(╥ω╥`)解析失败(查询数据为空)")
      end
      关闭加载框(loadMusic)
    end)
  else
    MD提示("(°ー°〃)请输入有效的分享Url")
  end
end
function up()
  import "xd"
  x = 0
  download(r.durl,"/sdcard/KMusic/Up.apk")
  dialog6= ProgressDialog(this)
  dialog6.setTitle("正在下载新版本(/ω＼)")
  dialog6.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
  dialog6.setCancelable(false)
  dialog6.setCanceledOnTouchOutside(false)
  dialog6.setOnCancelListener{
    onCancel=function(l)
      MD提示("你取消了下载(๑• . •๑)")
    end}
  dialog6.setMax(100)
  dialog6.show()
end
function ding(a,b) --a:已下载 b:总长度 x:现在
  dialog6.setMax(b)
  c = a - x
  x = x + c
  dialog6.incrementProgressBy(c)
  dialog6.incrementSecondaryProgressBy(c)
end
function dstop(c)
  MD提示("请安装新版本(●—●)")
  import "android.content.*" 
  import "android.net.*" 

  intent = Intent(Intent.ACTION_VIEW); 
  intent.setDataAndType(Uri.parse("file:///sdcard/KMusic/Up.apk"), "application/vnd.android.package-archive"); 
  intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK); 
  activity.startActivity(intent); 
end 