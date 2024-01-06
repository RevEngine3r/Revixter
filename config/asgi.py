"""
ASGI config for config project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.0/howto/deployment/asgi/
"""

import os

from django.core.asgi import get_asgi_application
from channels.auth import AuthMiddlewareStack
from channels.routing import ProtocolTypeRouter, URLRouter
from messenger import ws_routing
from channels_auth_token_middlewares.middleware import SimpleJWTAuthTokenMiddleware

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

application = ProtocolTypeRouter(
    {
        "http": get_asgi_application(),
        "websocket": SimpleJWTAuthTokenMiddleware(
            URLRouter(
                ws_routing.ws_urlpatterns
            )
        )
    }
)
