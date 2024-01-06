from django.contrib.auth.models import User
from .serializers import UserSerializer
from rest_framework import generics, permissions, filters
from django_filters.rest_framework import DjangoFilterBackend


class UserListAPIView(generics.ListAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    http_method_names = ['get', ]
    filter_backends = [filters.SearchFilter, DjangoFilterBackend]
    permission_classes = [permissions.IsAuthenticated]
    filterset_fields = ['id', 'username', 'email', ]
    search_fields = ['id', 'username', 'email', ]
