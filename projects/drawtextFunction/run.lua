if ae2timer then
require("event").cancel(ae2timer) end
path = "/mnt/41a/home/projects/drawtextFunction/" -- Try this "./" or give your real path
os.execute(path.."timex")
os.execute(string.format("%sresetScreen %s %s",path,secgpu,ae2mon))
os.execute(path.."adjustScreen")
os.execute(path.."drawtext")
os.execute(string.format("%sAE2Crafting %s %s",path,secgpu,ae2mon))