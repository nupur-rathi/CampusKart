from django.db import models
import uuid
from phonenumber_field.modelfields import PhoneNumberField
from sqlalchemy import desc
from django.db.models.signals import pre_delete
from django.dispatch.dispatcher import receiver

# Create your models here.
class Category(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    logo = models.ImageField(upload_to='categories/')


class User(models.Model):
    username = models.CharField(primary_key=True, max_length=200, unique=True, default='')
    first_name = models.CharField(max_length=100, null=True)
    last_name = models.CharField(max_length=100, null=True)
    phone_number = PhoneNumberField(null=True, blank=False, unique=True)
    emailId = models.EmailField(max_length=254, unique=True)
    # image = models.ImageField(upload_to='profile_image/', null=True)


class UserImage(models.Model):
    username = models.CharField(primary_key=True, max_length=200, unique=True, default='')
    image = models.ImageField(upload_to='profile_image/', null=True)


class Product(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    title = models.CharField(max_length=200, default='')
    category_id = models.ForeignKey(Category, on_delete=models.CASCADE, default='')
    description = models.TextField(default='')
    price = models.IntegerField(default=1)
    username = models.ForeignKey(User, on_delete=models.CASCADE, default='')
    time_uploaded = models.DateTimeField(auto_now_add=True)
    negotiation_status = models.BooleanField(default=False)
    selling_reason = models.TextField(default='Used in last semester')
    brand = models.CharField(max_length=100, default='')
    time_used = models.CharField(max_length=100, default='1-1-1')

class LikedProducts(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    username = models.ForeignKey(User, on_delete=models.CASCADE)
    product_id = models.ForeignKey(Product, on_delete=models.CASCADE)

    # class Meta:
    #     unique_together = (("username", "product_id"),)

class Image(models.Model):
    image = models.ImageField(upload_to='products/')
    product_id = models.ForeignKey(Product, on_delete=models.CASCADE)
    category_id = models.ForeignKey(Category, on_delete=models.CASCADE)

@receiver(pre_delete, sender=Image)
def image_delete(sender, instance, **kwargs):
    # Pass false so FileField doesn't save the model.
    instance.image.delete(False)


class Order(models.Model):
    username = models.ForeignKey(User, on_delete=models.CASCADE)
    product_id = models.ForeignKey(Product, on_delete=models.CASCADE)


class Token(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    token = models.CharField(max_length=1000)
    username = models.ForeignKey(User, on_delete=models.CASCADE)
    

class Notification(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    username = models.ForeignKey(User, on_delete=models.CASCADE)
    description = models.TextField(default='')
    read = models.BooleanField(default=False)