from django.urls import path
from .views import (
    ChatRoomListCreateView,
    MessageListCreateView,
    HealthView,
)

urlpatterns = [
    path("health/", HealthView.as_view(), name="messaging-health"),
    path("rooms/", ChatRoomListCreateView.as_view(), name="chatroom-list-create"),
    path(
        "rooms/<int:room_id>/messages/",
        MessageListCreateView.as_view(),
        name="message-list-create",
    ),
]
