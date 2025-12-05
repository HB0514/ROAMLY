from django.db import models
from django.conf import settings

User = settings.AUTH_USER_MODEL

class ChatRoom(models.Model):
    """1:1 혹은 그룹 채팅방"""
    name = models.CharField(max_length=255, blank=True)
    participants = models.ManyToManyField(User, related_name='chat_rooms')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name or f"Room {self.id}"

class Message(models.Model):
    """메시지 본문"""
    room = models.ForeignKey(ChatRoom, on_delete=models.CASCADE, related_name='messages')
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sent_messages')
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.sender}: {self.content[:20]}"