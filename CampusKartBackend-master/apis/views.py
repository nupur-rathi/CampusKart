import json
from django.shortcuts import HttpResponse
from rest_framework import generics

# Create your views here.
from product_user_info import models
from .serializers import CategorySerializer, LikedProductsSerializer, UserSerializer, ProductSerializer, OrderSerializer, \
    ImageSerializer, TokenSerializer, NotificationSerializer, UserImageSerializer
from django.db.models.functions import Lower
from .notifications import sendPush
from django.views.decorators.csrf import csrf_exempt

class ListCategory(generics.ListCreateAPIView):
    queryset = models.Category.objects.all()
    serializer_class = CategorySerializer


class DetailCategory(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.Category.objects.all()
    serializer_class = CategorySerializer


class ListUser(generics.ListCreateAPIView):
    queryset = models.User.objects.all()
    serializer_class = UserSerializer

    def get_queryset(self):

        queryset = models.User.objects.all()
        u_id = self.request.query_params.get('u_id')
        if u_id is not None:
            queryset = queryset.filter(username=u_id)

        return queryset

class DetailUser(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.User.objects.all()
    serializer_class = UserSerializer


class ListUserImage(generics.ListCreateAPIView):
    queryset = models.UserImage.objects.all()
    serializer_class = UserImageSerializer


class DetailUserImage(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.UserImage.objects.all()
    serializer_class = UserImageSerializer
    

class ListImage(generics.ListCreateAPIView):
    queryset = models.Image.objects.all()
    serializer_class = ImageSerializer

    def get_queryset(self):

        queryset = models.Image.objects.all()
        p_id = self.request.query_params.get('product_id')
        if p_id is not None:
            queryset = queryset.filter(product_id=p_id)
        c_id = self.request.query_params.get('category_id')
        if c_id is not None:
            queryset = queryset.filter(category_id=c_id)

        return queryset


class DetailImage(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.Image.objects.all()
    serializer_class = ImageSerializer

    def get_queryset(self):

        queryset = models.Image.objects.all()
        p_id = self.request.query_params.get('product_id')
        if p_id is not None:
            queryset = queryset.filter(product_id=p_id)
        c_id = self.request.query_params.get('category_id')
        if c_id is not None:
            queryset = queryset.filter(category_id=c_id)

        return queryset


class ListProduct(generics.ListCreateAPIView):
    queryset = models.Product.objects.all()
    serializer_class = ProductSerializer
    
    def get_queryset(self):

        queryset = models.Product.objects.all()
        c_id = self.request.query_params.get('category_id')
        stype = self.request.query_params.get('sort')
        search = self.request.query_params.get('search')
        owner = self.request.query_params.get('owner')
        prange = self.request.query_params.get('filter')
        u_id = self.request.query_params.get('user')
        neg_status = self.request.query_params.get('neg_status')
        if stype is not None:
            if stype == 'date':
                queryset = models.Product.objects.order_by('-time_uploaded')
            elif stype == 'HighToLow':
                queryset = models.Product.objects.order_by('-price')
            elif stype == 'LowToHigh':
                queryset = models.Product.objects.order_by('price')
        if prange is not None:
            if prange != '10000':
                queryset = queryset.filter(price__lte=int(prange))
        if neg_status is not None:
            if neg_status != 'All':
                queryset = queryset.filter(negotiation_status=neg_status)
        if c_id is not None:
            queryset = queryset.filter(category_id=c_id)
        if u_id is not None:
            queryset = queryset.filter(username=u_id)

        p_id = self.request.query_params.get('product_id')
        if p_id is not None:
            queryset = queryset.filter(id=p_id)
        if search is not None:
            queryset = queryset.annotate(title_lower=Lower('title')).filter(title_lower__icontains=search)
        if owner is not None:
            queryset = queryset.annotate(username_lower=Lower('username')).filter(username=owner)
        return queryset


class DetailProduct(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.Product.objects.all()
    serializer_class = ProductSerializer


class ListRecentProduct(generics.ListCreateAPIView):
    queryset = models.Product.objects.all()
    serializer_class = ProductSerializer


    def get_queryset(self):

        queryset = models.Product.objects.order_by('-time_uploaded')[:3]
        print(queryset)
        return queryset


class DetailRecentProduct(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.Product.objects.all()
    serializer_class = ProductSerializer

    def get_queryset(self):

        queryset = models.Product.objects.order_by('-time_uploaded')[:3]
        print(queryset)
        return queryset


class ListOrder(generics.ListCreateAPIView):
    queryset = models.Order.objects.all()
    serializer_class = OrderSerializer

class ListLikedProduct(generics.ListCreateAPIView):
    queryset = models.LikedProducts.objects.all()
    serializer_class = LikedProductsSerializer

    def get_queryset(self):
        queryset = models.LikedProducts.objects.all()
        p_id = self.request.query_params.get('p_id')
        u_id = self.request.query_params.get('u_id')
        if u_id is not None:
            queryset = queryset.filter(username=u_id)
        if p_id is not None:
            queryset = queryset.filter(product_id=p_id)
        return queryset

class DetailLikedProduct(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.LikedProducts.objects.all()
    serializer_class = LikedProductsSerializer

class DetailOrder(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.Order.objects.all()
    serializer_class = OrderSerializer


class ListToken(generics.ListCreateAPIView):
    queryset = models.Token.objects.all()
    serializer_class = TokenSerializer


class DetailToken(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.Token.objects.all()
    serializer_class = TokenSerializer


class ListNotification(generics.ListCreateAPIView):
    queryset = models.Notification.objects.all()
    serializer_class = NotificationSerializer


class DetailNotification(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.Notification.objects.all()
    serializer_class = NotificationSerializer


@csrf_exempt 
def SendNotification(request):
    if request.method == 'POST':
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)

        print(body)
        title = "A new product uploaded to CampusKart"
        desc = body['title']

        tokens = models.Token.objects.all()

        alltokens = []

        for tokenlist in tokens:
            alltokens.append(tokenlist.token)

        alltokens = list(set(alltokens))

        print(alltokens)

        sendPush(title, desc, alltokens)

        return HttpResponse('Success')

    else: 
        return HttpResponse('Failure')