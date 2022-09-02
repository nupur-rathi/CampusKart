from rest_framework import serializers
from product_user_info import models


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'id',
            'name',
            'logo'
        )
        model = models.Category


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'username',
            'first_name',
            'last_name',
            'phone_number',
            'emailId',
        )
        model = models.User


class UserImageSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'username',
            'image',
        )
        model = models.UserImage


class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'id',
            'title',
            'category_id',
            'description',
            'price',
            'username',
            'time_uploaded',
            'negotiation_status',
            'selling_reason',
            'brand',
            'time_used'
        )
        model = models.Product

class LikedProductsSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'id',
            'username',
            'product_id'
        )
        model = models.LikedProducts


class ImageSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'image',
            'product_id',
            'category_id',
        )
        model = models.Image


class OrderSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'username',
            'product_id'
        )
        model = models.Order


class TokenSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'id',
            'token',
            'username'
        )
        model = models.Token
        

class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'id',
            'username',
            'description',
            'read'
        )
        model = models.Notification