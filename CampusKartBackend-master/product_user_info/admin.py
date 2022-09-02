from tokenize import Token
from django.contrib import admin
from .models import Category, User, Product, Image, Order, Token, Notification, UserImage

# Register your models here.
admin.site.register(Category)
admin.site.register(User)
admin.site.register(Product)
admin.site.register(Image)
admin.site.register(Order)
admin.site.register(Token)
admin.site.register(Notification)
admin.site.register(UserImage)