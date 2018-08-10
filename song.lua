require "import"
require "xiaodanche"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
cjson = require "cjson"

MD主题()
载入布局("song_a")
import "android.graphics.PorterDuffColorFilter"
import "android.graphics.PorterDuff"
b1.getBackground().setColorFilter(PorterDuffColorFilter(0xFFFF4081,PorterDuff.Mode.SRC_ATOP))
b2.getBackground().setColorFilter(PorterDuffColorFilter(0xff19a2f7,PorterDuff.Mode.SRC_ATOP))

t,n=...
s = luajava.astable(t[n])
主题配置("[KMusic]"..s["title"].." "..s["author"],0xff19a2f7,0xff158bd3)

function encodeUrl(s)
  s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
  return string.gsub(s, " ", "+")
end

function GetRoundedCornerBitmap(bitmap,roundPx) 
  import "android.graphics.PorterDuffXfermode"
  import "android.graphics.Paint"
  import "android.graphics.RectF"
  import "android.graphics.Bitmap"
  import "android.graphics.PorterDuff$Mode"
  import "android.graphics.Rect"
  import "android.graphics.Canvas"
  import "android.util.Config"
  width = bitmap.getWidth()
  output = Bitmap.createBitmap(width, width,Bitmap.Config.ARGB_8888)
  canvas = Canvas(output); 
  color = 0xff424242; 
  paint = Paint()
  rect = Rect(0, 0, bitmap.getWidth(), bitmap.getHeight()); 
  rectF = RectF(rect); 
  paint.setAntiAlias(true);
  canvas.drawARGB(0, 0, 0, 0); 
  paint.setColor(color); 
  canvas.drawRoundRect(rectF, roundPx, roundPx, paint); 
  paint.setXfermode(PorterDuffXfermode(Mode.SRC_IN)); 
  canvas.drawBitmap(bitmap, rect, rect, paint); 
  return output; 
end
import "android.graphics.drawable.BitmapDrawable"
bitmap=loadbitmap(s["pic"])
RoundPic=GetRoundedCornerBitmap(bitmap,5)
img.setImageBitmap(RoundPic)

url = "https://www.owohi.top/km-api/player/post.php"
Http.post(url,"lrc="..encodeUrl(s["lrc"]),nil,nil,nil,function(a,b,c)
  data = "n="..encodeUrl(s["title"]).."&a="..encodeUrl(s["author"]).."&u="..encodeUrl(s["url"]).."&c="..encodeUrl(s["pic"]).."&lrc="..b
  settings = player.getSettings()
  settings.setJavaScriptEnabled(true)
  settings.setDomStorageEnabled(true)
  settings.setMixedContentMode(0)
  pu = "https://www.owohi.top/km-api/player/?"..data
  player.loadUrl(pu)
end)
downType = ".mp3"
if(s["type"] == "kg") then
  s["type"] = "全民K歌"
  downType = ".m4a"
end
if(s["type"] == "netease") then
  s["type"] = "网易云音乐(云村)"
  downType = ".mp3"
end
e1.text = s["title"]
e2.text = s["author"]
e3.text = s["type"]
e4.text = s["lrc"]
e5.text = s["url"]



import "android.media.MediaPlayer"

local player=MediaPlayer()
function play(path)
  player.reset()
  player.setDataSource(path)
  MD提示("正在缓冲: "..s["title"])
  player.prepare()
  MD提示("开始播放!(≧∇≦)/")
  player.start()
  player.setOnCompletionListener({
    onCompletion=function()
      MD提示("播放完成(›´ω`‹ )")
    end})
end

b1.onClick = function()
  if(b1.text == "后台播放") then
    b1.text = "停止"
    b1.getBackground().setColorFilter(PorterDuffColorFilter(0xff19a2f7,PorterDuff.Mode.SRC_ATOP))
    play(s["url"])
  else
    b1.text= "后台播放"
    b1.getBackground().setColorFilter(PorterDuffColorFilter(0xFFFF4081,PorterDuff.Mode.SRC_ATOP))
    player.stop()
  end
end

b2.onClick = function()
  x = 0
  import "xd"
  File("/sdcard/KMusic/Download/"..s["title"].." "..s["author"]..".lrc").createNewFile()
  io.open("/sdcard/KMusic/Download/"..s["title"].." "..s["author"]..".lrc","w"):write(s["lrc"]):close()
  download(s["url"],"/sdcard/KMusic/Download/"..s["title"].." "..s["author"]..downType)
  dialog6= ProgressDialog(this)
  dialog6.setTitle("下载: "..s["title"].." "..s["author"]..downType)
  dialog6.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
  dialog6.setCancelable(true)
  dialog6.setCanceledOnTouchOutside(false)
  dialog6.setOnCancelListener{
    onCancel=function(l)
      MD提示("你取消了下载︿(￣︶￣)︿")
    end}

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
  dialog6.dismiss()
  MD提示("下载完成,保存在:/sdcard/KMusic/Download/"..s["title"].." "..s["author"]..downType.."("..math.floor(c/1024/1024).."mb)")
end 
