from django.urls import path
from .views import (
    ping,
    suggest_locations,
    location_hit,
    search_packages,
    search_packages_by_keyword,
)

urlpatterns = [
    path("ping/", ping, name="api-ping"),
    path("locations/suggest/", suggest_locations, name="location-suggest"),
    path("locations/<int:pk>/hit/", location_hit, name="location-hit"),
    path("packages/search/", search_packages, name="packages-search"),
    path("packages/by-keyword/", search_packages_by_keyword, name="packages-by-keyword"),
]
