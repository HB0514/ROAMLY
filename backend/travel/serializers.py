from rest_framework import serializers
from .models import Location, TravelPackage

class LocationSuggestSerializer(serializers.ModelSerializer):
    display = serializers.SerializerMethodField()
    class Meta:
        model = Location
        fields = ["id", "name", "region", "country", "slug", "display"]
    def get_display(self, obj):
        return f"{obj.name} · {obj.region+', ' if obj.region else ''}{obj.country}"

class TravelPackageSerializer(serializers.ModelSerializer):
    location = LocationSuggestSerializer(read_only=True)
    class Meta:
        model = TravelPackage
        fields = ["id","title","description","location","capacity","start_date","end_date","price_usd"]
