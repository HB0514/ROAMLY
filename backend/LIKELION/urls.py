from django.contrib import admin
from django.urls import path, include
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

urlpatterns = [
    path('admin/', admin.site.urls),

    # API docs
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema')),

    # Accounts (회원가입, 로그인, 로그아웃)
    path('api/auth/', include('accounts.urls')),

    # Profiles (유저 프로필 관련)
    path('api/profiles/', include('profiles.urls')),
    path("api/messaging/", include("messaging.urls")),
]