from rest_framework.views import APIView
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.tokens import RefreshToken

User = get_user_model()

class HealthView(APIView):
    permission_classes = [AllowAny]
    def get(self, request):
        return Response({"ok": True, "app": "accounts"})

class RegisterView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        email = request.data.get("email")
        password = request.data.get("password")
        if not email or not password:
            return Response({"error": "email and password required"}, status=400)
        if User.objects.filter(email=email).exists():
            return Response({"error": "user already exists"}, status=400)
        User.objects.create_user(email=email, password=password)
        return Response({"message": "registered"}, status=status.HTTP_201_CREATED)

class LogoutView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request):
        refresh = request.data.get("refresh")
        if not refresh:
            return Response({"detail": "refresh token required"}, status=400)
        try:
            token = RefreshToken(refresh)
            token.blacklist()
        except Exception:
            return Response({"detail": "invalid refresh"}, status=400)
        return Response(status=204)
