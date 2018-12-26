from django.shortcuts import render
from django.views.decorators.http import require_http_methods
from django.core import serializers
from django.http import JsonResponse
from django.db import models
import json
 
# from .models import logs
# Create your views here.
 
@require_http_methods(["GET"])
def show_logs(request):
    response = {}
    try:
        logs = models.UNSAFE_LOG.objects.all()
        response['list'] = json.loads(serializers.serialize("json", logs))
        response['msg'] = 'success'
        response['error_num'] = 0
    except  Exception as e:
        response['msg'] = str(e)
        response['error_num'] = 1
    return JsonResponse(response)

@require_http_methods(["GET"])
def show_graphs(request):
    return

