from django.urls import path
from .views import DetailLikedProduct, ListCategory, ListImage, ListLikedProduct, ListOrder, ListProduct, ListUser, DetailCategory, \
    DetailImage, DetailOrder, DetailProduct, DetailUser, ListRecentProduct, DetailRecentProduct, \
        ListToken, DetailToken, SendNotification, ListNotification, DetailNotification, ListUserImage, DetailUserImage
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('category/', ListCategory.as_view()),
    path('category/<str:pk>/', DetailCategory.as_view()),
    path('image/', ListImage.as_view()),
    path('image/<str:pk>/', DetailImage.as_view()),
    path('order/', ListOrder.as_view()),
    path('order/<str:pk>/', DetailOrder.as_view()),
    path('product/', ListProduct.as_view()),
    path('product/<str:pk>/', DetailProduct.as_view()),
    path('recentProduct/', ListRecentProduct.as_view()),
    path('recentProduct/<str:pk>/', DetailRecentProduct.as_view()),
    path('user/', ListUser.as_view()),
    path('likedpro/', ListLikedProduct.as_view()),
    path('likedpro/<str:pk>/', DetailLikedProduct.as_view()),
    path('user/<str:pk>/', DetailUser.as_view()),
    path('token/', ListToken.as_view()),
    path('token/<str:pk>/', DetailToken.as_view()),
    path('shownotification/', ListNotification.as_view()),
    path('shownotification/<str:pk>/', DetailNotification.as_view()),
    path('notification/', SendNotification, name = 'notification'),
    path('userimage/', ListUserImage.as_view()),
    path('userimage/<str:pk>/', DetailUserImage.as_view()),
]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)