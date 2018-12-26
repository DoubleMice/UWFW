from django.shortcuts import render
import os,json
from . import settings
def hello(request):
    LOG = "/tmp/ngx_unsafe_log"
    print(LOG)
    log_file = os.listdir(LOG)
    logs = open(os.path.join(LOG,log_file[0]),"r")
    content = []
    for log in logs:
        content.append(json.loads(log))
    context = {}
    context["logs"] = content
    return render(request, 'index.html', context)
