from datetime import datetime, timedelta
from product_user_info import models
from apis.notifications import sendPush


def delete_product_after_month():
    products_for_notif = models.Product.objects.filter(
        time_uploaded__lte=datetime.now() - timedelta(days=25)
    )

    
    products_for_deletion = models.Product.objects.filter(
        time_uploaded__lte=datetime.now() - timedelta(days=30)    
    )
    
    for product in products_for_deletion:
        title = f"Product Deleted - {product.title}"
        desc = "Upload your product again to sell it."
        tokens = models.Token.objects.filter(username=product.username)
        alltokens = []
        for tokenlist in tokens:
            alltokens.append(tokenlist.token)
        print(title, desc)

        alltokens = list(set(alltokens))

        sendPush(title, desc, alltokens)


    for product in products_for_notif:
        title = "Action Required"
        desc = f"Your product '{product.title}' will be live for 5 days more."

        tokens = models.Token.objects.filter(username=product.username)

        alltokens = []

        for tokenlist in tokens:
            alltokens.append(tokenlist.token)

        alltokens = list(set(alltokens))


        sendPush(title, desc, alltokens)

    models.Product.objects.filter(
        time_uploaded__lte=datetime.now() - timedelta(days=30)
    ).delete()
