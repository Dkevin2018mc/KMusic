require "import"
require "xiaodanche"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
cjson = require "cjson"


MD主题()
载入布局("list_a")
downType = ".mp3"

import "android.graphics.PorterDuffColorFilter"
import "android.graphics.PorterDuff"
button.getBackground().setColorFilter(PorterDuffColorFilter(0xFFFF4081,PorterDuff.Mode.SRC_ATOP))

list=
{
  LinearLayout;
  gravity="center";
  orientation="vertical";
  {
    LinearLayout;
    gravity="center";
    layout_width="100%w";
    layout_height="8%h";
    padding="10dp";
    {
      TextView;
      layout_marginLeft="1dp";
      text="0";
      id="id";
    };
    {
      TextView;
      layout_marginLeft="2%w";
      text="名字";
      id="title";
    };
    {
      LinearLayout;
      gravity="right|center";
      layout_width="-1";
      layout_height="-1";
      {
        ImageButton;
        layout_width="90dp";
        layout_height="50dp";
        src="res/b1.png";
        layout_marginRight="2%w";
        id="bt";
      };
    };
  };
};
--list.bt.getBackground().setColorFilter(PorterDuffColorFilter(0xff19a2f7,PorterDuff.Mode.SRC_ATOP))
d = ...
r = cjson.decode(d)
t = luajava.astable(r.data)
if(t ~= "" and t ~= nil) then
  n = 0
  a = {}
  adp=LuaAdapter(activity,list)
  lv.Adapter = adp
  function cl(e)
    local v = e.getParent().getParent().getParent()
    local n = tonumber(v.Tag.id.text)
    w = n
    s = a[n]
    downDi=显示加载框("正在下载中...",a[n]["title"].." "..s["author"]..downType,true,false)
    import "xd"
    if(s["type"] == "kg") then
      s["type"] = "全民K歌"
      downType = ".m4a"
    end
    if(s["type"] == "netease") then
      s["type"] = "网易云音乐(云村)"
      downType = ".mp3"
    end
    import "java.io.File"
    File("/sdcard/KMusic/Download/"..a[n]["title"].." "..s["author"]..".lrc").createNewFile()
    io.open("/sdcard/KMusic/Download/"..a[n]["title"].." "..s["author"]..".lrc","w"):write(a[n]["lrc"]):close()
    download(a[n]["url"],"/sdcard/KMusic/Download/"..a[n]["title"].." "..s["author"]..downType)
  end
  for key, value in ipairs(t) do 
    n = n + 1
    a[n] = luajava.astable(t[n])
    local title = a[n]["title"]
    adp.add{id=n,title=a[n]["title"].." "..a[n]["author"],bt={onClick=cl}}
  end
  主题配置("[KMusic]解析结果: "..n.."个",0xff19a2f7,0xff158bd3)
end

function ding(a,b)
  --dialog6.setTitle(math.floor(a/1024/1024).."mb/"..math.floor(b/1024/1024).."mb")
  --bt.text = a/b*100
end
function dstop(c)
  关闭加载框(downDi)
  MD提示("下载完成,保存在:/sdcard/KMusic/Download/"..a[w]["title"].." "..s["author"]..downType.."("..math.floor(c/1024/1024).."mb)")
end 

button.onClick = function()
  dialog6= ProgressDialog(this)
  dialog6.setTitle("批量下载(0/"..n..")")
  dialog6.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
  dialog6.setCancelable(true)
  dialog6.setCanceledOnTouchOutside(false)
  dialog6.setOnCancelListener{
    onCancel=function(l)
      MD提示("你取消了下载︿(￣︶￣)︿")
    end}
  dialog6.setMax(n)
  dialog6.show()
  o = 0
  for i=1,n do
    s = a[i]
    import "xd"
    if(s["type"] == "kg") then
      s["type"] = "全民K歌"
      downType = ".m4a"
    end
    if(s["type"] == "netease") then
      s["type"] = "网易云音乐(云村)"
      downType = ".mp3"
    end
    File("/sdcard/KMusic/Download/"..s["title"].." "..s["author"]..".lrc").createNewFile()
    io.open("/sdcard/KMusic/Download/"..s["title"].." "..s["author"]..".lrc","w"):write(s["lrc"]):close()
    download_(s["url"],"/sdcard/KMusic/Download/"..s["title"].." "..s["author"]..downType)
  end
end

function dstop_(c)
  o = o + 1
  dialog6.incrementProgressBy(1)
  dialog6.setTitle("批量下载("..o.."/"..n..")")
  if(o == n) then
    MD提示("成功下载: "..n.."个任务,保存在/sdcard/KMusic/Download/")
    dialog6.dismiss()
  end
end 