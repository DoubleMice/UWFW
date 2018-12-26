from django.conf.urls import url, include 
from . import views


urlpatterns = [
    url(r'logs$', views.show_logs, ),
    url(r'graphs$', views.show_graphs),
]