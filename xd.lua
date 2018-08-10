function xdc(url,path)
  require "import"
  import "java.net.URL"
  local ur =URL(url)
  import "java.io.File"
  file =File(path);
  con = ur.openConnection();
  co = con.getContentLength();
  is = con.getInputStream();
  bs = byte[1024]
  local len,read=0,0
  import "java.io.FileOutputStream"
  wj= FileOutputStream(path);
  len = is.read(bs)
  while len~=-1 do
    wj.write(bs, 0, len);
    read=read+len
    pcall(call,"ding",read,co)
    len = is.read(bs)
  end
  wj.close();
  is.close();
  pcall(call,"dstop",co)
end
function download(url,path)
thread(xdc,url,path)
end


function xdc_(url,path)
  require "import"
  import "java.net.URL"
  local ur =URL(url)
  import "java.io.File"
  file =File(path);
  con = ur.openConnection();
  co = con.getContentLength();
  is = con.getInputStream();
  bs = byte[1024]
  local len,read=0,0
  import "java.io.FileOutputStream"
  wj= FileOutputStream(path);
  len = is.read(bs)
  while len~=-1 do
    wj.write(bs, 0, len);
    read=read+len
    pcall(call,"ding_",read,co)
    len = is.read(bs)
  end
  wj.close();
  is.close();
  pcall(call,"dstop_",co)
end
function download_(url,path)
thread(xdc_,url,path)
end