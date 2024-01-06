from django.urls import path
from messenger.ws_consumer import ChatConsumer

ws_urlpatterns = [
    path('ws/', ChatConsumer.as_asgi())
]
