from django.db import models
from django.utils.text import slugify

class Location(models.Model):
    name = models.CharField(max_length=120, db_index=True)
    region = models.CharField(max_length=120, blank=True, default="")
    country = models.CharField(max_length=120, default="United States")
    slug = models.SlugField(max_length=160, unique=True, blank=True)

    # popularity signals
    popularity_score = models.FloatField(default=0)
    search_hits = models.PositiveIntegerField(default=0)
    bookings_30d = models.PositiveIntegerField(default=0)

    class Meta:
        unique_together = [("name", "region", "country")]

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(f"{self.name}-{self.region}-{self.country}")[:160]
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.name}{', ' + self.region if self.region else ''}, {self.country}"

class TravelPackage(models.Model):
    location = models.ForeignKey(Location, on_delete=models.CASCADE, related_name="packages")
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    capacity = models.PositiveIntegerField(default=2)
    start_date = models.DateField()
    end_date = models.DateField()
    price_usd = models.DecimalField(max_digits=10, decimal_places=2)
    total_bookings = models.PositiveIntegerField(default=0)

    def __str__(self):
        return f"{self.title} @ {self.location}"
