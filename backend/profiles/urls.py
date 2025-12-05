from django.urls import path
from rest_framework.response import Response
from rest_framework.views import APIView

class HealthView(APIView):
    def get(self, request):
        return Response({"ok": True, "app": "messaging"})

urlpatterns = [
    path("health/", HealthView.as_view(), name="messaging-health"),
]