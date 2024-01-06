import django.urls as dj_urls

from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
    TokenVerifyView
)

from accounts.views import UserListAPIView

urlpatterns = [
    dj_urls.path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    dj_urls.path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    dj_urls.path('token/verify/', TokenVerifyView.as_view(), name='token_verify'),
    dj_urls.path('users/', UserListAPIView.as_view())
]
