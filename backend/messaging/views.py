from django.shortcuts import get_object_or_404
from rest_framework import generics, permissions
from rest_framework.exceptions import PermissionDenied
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import ChatRoom, Message
from .serializers import ChatRoomSerializer, MessageSerializer

class ChatRoomListCreateView(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = ChatRoomSerializer

    def get_queryset(self):
        return ChatRoom.objects.filter(participants=self.request.user)

    def perform_create(self, serializer):
        room = serializer.save()
        room.participants.add(self.request.user)

class MessageListCreateView(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = MessageSerializer

    def _get_room(self):
        """Ensure the requesting user has access to the room before returning it."""
        room = get_object_or_404(ChatRoom, pk=self.kwargs["room_id"])
        if not room.participants.filter(pk=self.request.user.pk).exists():
            raise PermissionDenied("You are not a participant in this room.")
        return room

    def get_queryset(self):
        room = self._get_room()
        return room.messages.all()

    def perform_create(self, serializer):
        room = self._get_room()
        serializer.save(sender=self.request.user, room=room)

class HealthView(APIView):
    def get(self, request):
        return Response({"ok": True, "app": "messaging"})
