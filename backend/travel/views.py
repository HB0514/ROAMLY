from datetime import datetime
from django.db.models import Q
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from rest_framework.pagination import PageNumberPagination
from .models import Location, TravelPackage
from .serializers import TravelPackageSerializer

def _parse_date(s):
    if not s: return None
    for fmt in ("%Y-%m-%d","%m/%d/%Y","%Y/%m/%d"):
        try:
            return datetime.strptime(s, fmt).date()
        except ValueError:
            continue
    return None

class SmallPage(PageNumberPagination):
    page_size = 12
    page_size_query_param = "size"
    max_page_size = 100

@api_view(["GET"])
def search_packages(request):
    """
    Search with location + date range + travelers.
    Query params:
      - location: text | slug | numeric id
      - start, end: dates (YYYY-MM-DD, or MM/DD/YYYY)
      - guests: int (min capacity)
      - page, size: pagination
    """
    qs = TravelPackage.objects.select_related("location")

    # --- location filter ---
    loc_q = (request.query_params.get("location") or "").strip()
    if loc_q:
        # allow id=123 or slug, or generic text match
        if loc_q.isdigit():
            qs = qs.filter(location__id=int(loc_q))
        else:
            qs = qs.filter(
                Q(location__slug=loc_q) |
                Q(location__name__icontains=loc_q) |
                Q(location__region__icontains=loc_q) |
                Q(location__country__icontains=loc_q)
            )

    # --- dates filter (overlap) ---
    start = _parse_date(request.query_params.get("start"))
    end   = _parse_date(request.query_params.get("end"))

    if start and not end:
        end = start
    if end and not start:
        start = end
    if start and end and end < start:
        return Response({"error": "end date must be on/after start date"}, status=status.HTTP_400_BAD_REQUEST)

    if start and end:
        # package is available if its window overlaps requested window
        qs = qs.filter(start_date__lte=end, end_date__gte=start)

    # --- travelers (capacity) ---
    guests_q = request.query_params.get("guests")
    if guests_q:
        try:
            guests = max(1, int(guests_q))
            qs = qs.filter(capacity__gte=guests)
        except ValueError:
            return Response({"error": "guests must be an integer"}, status=status.HTTP_400_BAD_REQUEST)

    # order consistently
    qs = qs.order_by("price_usd", "start_date")

    paginator = SmallPage()
    page = paginator.paginate_queryset(qs, request)
    return paginator.get_paginated_response(TravelPackageSerializer(page, many=True).data)
