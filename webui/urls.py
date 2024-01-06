from django.urls import path
from django.views.generic import TemplateView

from webui import views

urlpatterns = [
    path("", views.index, name="index"),
]
