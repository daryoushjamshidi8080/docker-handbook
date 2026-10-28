# 🐳 Docker Cheat Sheet & Notes

یک مرجع جامع، سریع و کاربردی برای دستورات پرکاربرد داکر، مدیریت کانتینرها و راهنمای کامل Dockerfile.

---

## 📌 دستورات پایه و مدیریت کانتینرها

### ۱. نمایش وضعیت و اطلاعات

| دستور                                       | کاربرد                                     |
| :------------------------------------------ | :----------------------------------------- |
| `docker images`                             | لیست تمام ایمیج‌های موجود روی سیستم        |
| `docker ps`                                 | لیست کانتینرهای در حال اجرا (Running)      |
| `docker ps -a`                              | لیست تمام کانتینرها (فعال و متوقف‌شده)     |
| `docker container ls -a`                    | نمایش تمامی کانتینرها به همراه وضعیت آن‌ها |
| `docker container inspect <container_name>` | نمایش جزئیات کامل فنی و پیکربندی کانتینر   |

---

### ۲. ساخت و اجرای کانتینرها (docker run)

````bash
# اجرای یک کانتینر جدید از ایمیج
docker run <image_name>

# اجرای کانتینر با نام اختصاصی
docker run --name daryoush hello-world

# حذف خودکار کانتینر بلافاصله پس از اتمام کار
docker run --rm hello-world

# اجرای تعاملی (اتصال ترمینال به کانتینر)
docker run -it <image_name> bash

# اجرای کانتینر در پس‌زمینه (Detach Mode)
docker run -d redis

# اجرای تعاملی در پس‌زمینه (مناسب برای توزیع‌های سبک مثل busybox)
docker run -dit busybox

# عوض کردن نام کانتینر یا تگ جدید
dokcer tag busybox:lastes daryous80/busybox:1.2

# پوش کردن کانتنیر به داخل ریپازیتور داکر
docker push daryoush80/busybox:1.2 #قبلش باشد لاگین کنیم داخل داکر بعدشم باید dayroush80/ قبل اسم ریپازیتوریمون باشه

# ۱. ساخت کانتینر بدون اجرای فوری
docker create -it --name bx busybox

# ۲. روشن کردن کانتینر متوقف‌شده
docker start bx

# ۳. ورود به کانتینرِ روشن و اجرای شِل جدید (روش استاندارد)
docker exec -it bx sh

# ۴. متوقف کردن کانتینر در حال اجرا
docker stop <container_name>

# ۵. حذف کانتینر متوقف‌شده
docker rm <container_name




================================================================================
## 🔄 سیاست‌های بازراه‌اندازی (Restart Policies)

تعیین رفتار داکر در صورت خروج کانتینر، بروز خطا یا ری‌استارت شدن سیستم:

| سیاست | رفتار داکر |
| :--- | :--- |
| **`no`** | عدم بازراه‌اندازی خودکار (حالت پیش‌فرض). |
| **`always`** | کانتینر همواره ری‌استارت می‌شود، مگر اینکه دستی توسط کاربر `stop` شده باشد. |
| **`unless-stopped`** | مانند `always` است، با این تفاوت که اگر دستی متوقف شده باشد، با ری‌استارت شدن سیستم روشن نمی‌شود. |
| **`on-failure`** | کانتینر **فقط** در صورت خروج با کد خطا (Exit Code غیر صفر) ری‌استارت می‌شود. |

```bash
# تنظیم سیاست ری‌استارت در زمان ساخت کانتینر
docker run -itd --restart always python:3.11-slim bash

# تغییر یا اضافه کردن سیاست ری‌استارت به کانتینر از قبل ساخته شده
docker update --restart always python3

# تبدل امیج ها به فایل های tar
docker save -o my-image.tar my-image-docker:v1.20 # برای انتقال ایمیج بدون اینترنت استفاده میشه

# لود کردن ایمج ذخیره شده با فایل tar
docker load -i my-image.tar

======================================================================================
## 📜 راهنمای دستورات Dockerfile

مرجع دستورالعمل‌های استاندارد برای ساخت ایمیج اختصاصی (Custom Image):

### ۱. دستورات پایه و ساختار (Core Setup)
* **`FROM`**: تعیین ایمیج پایه (Base Image) برای شروع ساخت.
* **`WORKDIR`**: تنظیم دایرکتوری کاری فعال برای تمام دستورات بعدی.
* **`USER`**: تعیین کاربر (UID) یا گروه متناظر برای اجرای دستورات.
* **`LABEL`**: افزودن متادیتا به ایمیج (مانند نسخه، توضیحات یا نام سازنده).
* **`MAINTAINER`**: تعیین نام سازنده یا پشتیبان ایمیج *(منسوخ شده؛ بهتر است از `LABEL` استفاده شود)*.

### ۲. انتقال فایل‌ها و متغیرها (Files & Variables)
* **`COPY`**: کپی کردن فایل‌ها و دایرکتوری‌های محلی سیستم به داخل ایمیج.
* **`ADD`**: مانند `COPY` است، اما قابلیت استخراج فایل‌های فشرده (`tar`) و دانلود از URL را هم دارد.
* **`ENV`**: تعریف متغیرهای محیطی که در زمان اجرای کانتینر نیز در دسترس هستند.
* **`ARG`**: تعریف متغیرهای اختصاصی که فقط در زمان ساخت ایمیج (`docker build`) معتبر هستند.

### ۳. اجرا و پیکربندی دستورات (Execution & Commands)
* **`RUN`**: اجرای دستورات در زمان ساخت ایمیج (مانند نصب پکیج‌ها با `apt` یا `pip`).
* **`CMD`**: تعیین دستور پیش‌فرض کانتینر هنگام اجرا (به‌راحتی قابل تغییر یا Override است).
* **`ENTRYPOINT`**: تعیین دستور اصلی و ثابت کانتینر که مثل یک برنامه اجرایی عمل کند.
* **`SHELL`**: تغییر شِل پیش‌فرض برای اجرای دستورات (مثلاً تغییر از `sh` به `bash`).

### ۴. شبکه، ذخیره‌سازی و مدیریت (Network, Storage & Health)
* **`EXPOSE`**: مشخص کردن پورت‌هایی که برنامه داخل کانتینر روی آن‌ها گوش می‌دهد.
* **`VOLUME`**: تعریف نقطه اتصال (Mount Point) برای ذخیره داده‌های ماندگار خارج از کانتینر.
* **`HEALTHCHECK`**: تعیین دستوراتی برای بررسی سلامت و زنده بودن برنامه داخل کانتینر.
* **`STOPSIGNAL`**: تعیین سیگنال خروج سیستم‌عامل (مثل `SIGTERM`) برای متوقف کردن کانتینر.
* **`ONBUILD`**: تعیین دستوراتی که تنها در صورت استفاده از این ایمیج به عنوان پایه (`FROM`) در یک Dockerfile دیگر اجرا می‌شوند.

````

==================================
#port forwarding

## به صورت پیشفرض کانتینر ها یک محیط کاملا ایزوله شده هستن و هیچ دسترسی از بیرون به داخل کانتینر وجود ندارد

## برای این که بتونیم از خارج از داکر به کانتینری که در داخل در حال اجرا میباشد وصل بشیم برای خطایابی یا دیدن پروژه درحال ران از (port forwarding ) استفاده میکنیم

## برای مثال پروژه جنگو در داخل کانتینر درحال ران هست و میتونتیم با استفاده از فرواردینگ یک پورت باز کنیم و از مرورگر لپتاپ بهش وصل بشیم

# باز کردن port جدید

docker run -p 9000:8080 my-django-project # پورت اول پورت جدیدی هست که ما باز کردیم پورت دورم پورتی هست که در داخل داکر فعال هست

# برای ارتباط کانینر با کانیتر از networking استفاده میکنیم

### file docker compose در رابطه با پروت ها

version : 3.8

services:
web:
build: .
command: python manage.py runserver 0.0.0.0:8080
port : - "9000:8080" # [Host Port]:[Container Port]

    db:
      image: postgres:15
      ports:
        - "2050:5432" # اختیاری: فقط اگر می‌خواهید با ابزارهای خارجی به Postgres وصل شوید

==========================

# docker commit

## دستور docker commit برای تبدیل یک «کانتینرِ تغییریافته» به یک «ایمیج (Image) جدید» استفاده می‌شود.

## زمانی استفاده می‌شود که داخل یک کانتینر در حال اجرا، تغییراتی (مثل نصب یک پکیج جدید یا تغییر فایل‌ها) ایجاد کرده‌ایم و می‌خواهیم آن کانتینر را همراه با تغییراتش به عنوان یک ایمیج جدید ذخیره کنیم.

## با اجرای commit، یک لایه (Layer) جدید حاوی تغییرات به ایمیج اصلی اضافه شده و ایمیج جدید ساخته می‌شود.

# ساختار دستور:

docker commit <container_id_or_name> <new_image_name>:<tag>

# میتوانیم با -a نویسنده رو مشخص کنیم

# میتوانیم با -m یک متنی رو بهش اضافه کنیم که چیکار کردیم

# با inspect image میتوانیم ببنیم author and comment

docker commit ubn -a "dayoush" -m "add file a.py" ubuntu:v15.4

=============================

# Docker Volumes (ذخیره‌سازی و پایداری داده‌ها)

## کانتینرها به صورت پیش‌فرض موقتی (Ephemeral) هستند؛ یعنی اگر کانتینری حذف شود، تمام داده‌های ایجادشده داخل آن نیز به طور کامل پاک می‌شوند.

## برای داده‌های مهم (مثل اطلاعات پایگاه داده PostgreSQL، فایل‌های Media یا عکس‌های آپلودشده) که باید همواره باقی بمانند، از Volume استفاده می‌کنیم.

## نقش Volume این است که داده‌ها را خارج از کانتینر و روی سیستم اصلی (Host) ذخیره کند تا پایداری داده‌ها (Data Persistence) تضمین شود.

## با استفاده از Volume، حتی اگر کانتینر قدیمی را کاملاً حذف کنیم، می‌توانیم کانتینر جدیدی بسازیم و آن را به همان Volume قبلی متصل کنیم تا اطلاعات بدون هیچ تغییری برگردند.

# ساختار تعریف Volume در Docker Compose:

# create volume

docker volume create my-vol1

# Inquiry Volume

docker volume ls

# information Volime

docker volume inspect my-vol1

# delete volume

docker volume rm my-vol1

### مسیر پیشفرض ذخیره شده والیوم های در سیستم لینوکسی /var/lib/docker/volumes/my-vol1/\_data

docker run -it --name newpython -v my-vol1:/home python:latest bash

# connecting volume to a container

docker run -it --name newpython -v my-vol1:/home python:latest bash # my-vol1:/home یعنی هرچی تو والیوم ما بود بریز به دایکتور home
هرجی هم در دایکتوری home ساخته میشه ذخیره کن در والیوم

# تفاوت اتصال مستقیم Volume با volumes-from--

## ۱. اتصال مستقیم (v v1:/home-):

مستقیماً اسم والیوم (v1) و مسیر متصل شدن آن در کانتینر (/home) را مشخص می‌کنیم.

## ۲. استفاده از volumes-from bx2--:

به داکر می‌گوییم تمام والیوم‌های متصل به کانتینر bx2 را (با همان مسیرها) عینا به کانتینر جدید متصل کند.

## کارایی اصلی volumes-from:

- کپی کردن سریع تنظیماتِ کانتینرهایی که چندین والیوم دارند (بدون نیاز به تایپ مجدد آدرس‌ها).
- اجرای کانتینرهای موقت برای پشتیبان‌گیری (Backup) یا عیب‌یابی از والیوم‌های یک کانتینر دیگر.

docker run -it --name bx1 -v v1:/home busybox:latest
docker run -it --name bx1 --volumes-from bx2:ro busybox:latest

# bx2:ro باشه فقط میتونه بخونه نمی تونه رایت کنه

# bx خالی باشه بدون :or میتونه رایت هم بکنه

# docker compose with volume

version : 3.8

services:
db:
image: postgres:15
volume:
-postgres_data:/var/lib/postgres/data [نام والیوم]:[مسیر داخل کانتینر]

======================

## networking

# برای اتباط بین کانتینر ها استفاده میشه بحث نتورکنیگ

# create network

docker network create my-net

# remove network

docker network rm my-net

# show list network

docker network ls

# connect a container to user-defined

docker network connect my-net my-container

# disconnect a container to user-defined

docker network disconnect my-net my-container

#برای فهمیدن متصل شدن دوتا از کانتینر ها به هم دیگه میتوانیم داخل کانتینر یک پنگ بگیریم از اسم کانیتنر دیگر یا انسپکت بگیرم از نتورک ساخته شده

===================================================

# 🛠 مستندات معماری داکر و خدمات پروژه (Docker Architecture)

این پروژه از یک معماری چندکانتینری (Multi-Container Architecture) بر پایه **Docker Compose** استفاده می‌کند. در ادامه، نقش و تنظیمات دقیق هر سرویس تشریح شده است.

---

## 🏗 فایل کانفیگ اصلی (`docker-compose.yml`)

```yaml
version: "3.8"

services:
  # -----------------------------------------------------------------
  # 1. سرویس RabbitMQ (Message Broker)
  # واسط تبادل پیام‌ها و مدیریت صف وظایف بین Django و Celery
  # -----------------------------------------------------------------
  rabbitmq:
    container_name: rabbitmq # نام اختصاصی کانتینر در داکر
    image: rabbitmq:3-management # استفاده از ایمیج رسمی همراه با پنل مدیریتی وب
    networks:
      - main # اتصال به شبکه ایزوله داخلی
    ports:
      - "5672:5672" # پورت اصلی پروتکل AMQP برای تبادل پیام
      - "15672:15672" # پورت پنل مدیریت وب (http://localhost:15672)
    restart: always # ری‌استارت خودکار کانتینر در صورت خروج ناگهانی یا ریبوت سرور

  # -----------------------------------------------------------------
  # 2. سرویس PostgreSQL (Database)
  # پایگاه داده اصلی پروژه
  # -----------------------------------------------------------------
  postgres:
    container_name: postgres
    image: postgres:16-alpine # استفاده از نسخه سبک و امن Alpine برای کاهش حجم
    environment:
      - POSTGRES_DB=postgres # نام پایگاه داده پیش‌فرض
      - POSTGRES_USER=postgres # نام کاربر ارشد دیتابیس
      - POSTGRES_PASSWORD=postgres # رمز عبور دیتابیس (در محیط واقعی از .env فراخوانی شود)
    networks:
      - main
    ports:
      - "5432:5432" # اکسپوز پورت برای دسترسی ابزارهایی مانند DBeaver در محیط توسعه
    restart: always
    volumes:
      - postgres_data:/var/lib/postgresql/data # ذخیره دائمی داده‌ها در Volume جهت جلوگیری از پاک‌شدن اطلاعات

  # -----------------------------------------------------------------
  # 3. سرویس اصلی وب (Django App)
  # اجرای وب‌سرور Gunicorn و هندل کردن درخواست‌های API/Web
  # -----------------------------------------------------------------
  app:
    build: . # ساخت ایمیج از روی Dockerfile موجود در مسیر جاری
    image: my_django_app:latest # برچسب‌گذاری ایمیج ساخته‌شده جهت اشتراک‌گذاری با Celery
    container_name: app
    command: sh -c "python manage.py migrate && gunicorn A.wsgi:application --bind 0.0.0.0:8000"
    # دستور فوق ابتدا Migration دیتابیس را اعمال کرده و در صورت موفقیت، Gunicorn را اجرا می‌کند
    volumes:
      - .:/code/ # مپ کردن کدهای سورس سیستم به کانتینر جهت اعمال زنده تغییرات (Hot-Reload)
    depends_on:
      - postgres # عدم اجرا تا زمان آماده‌سازی سرویس دیتابیس
      - rabbitmq # عدم اجرا تا زمان آماده‌سازی سرویس صف پیام
    expose:
      - "8000" # باز نگه داشتن پورت 8000 فقط داخل شبکه داخلی داکر (برای Nginx)
    networks:
      - main
    restart: always

  # -----------------------------------------------------------------
  # 4. سرویس پردازش کارهای پس‌زمینه (Celery Worker)
  # اجرای Taskهای زمان‌بر و غیرهم‌زمان پایتون
  # -----------------------------------------------------------------
  celery_worker:
    container_name: celery_worker
    image: my_django_app:latest # استفاده مستقیم از ایمیج ساخته‌شده در سرویس app (جلوگیری از Build تکراری)
    command: "celery -A A worker -l INFO" # دستور اجرای ورکر سلری روی برنامه A
    depends_on:
      - app
      - rabbitmq
      - postgres
    environment:
      - C_FORCE_ROOT=true # اجازه به Celery جهت اجرا تحت کاربر Root (فقط برای محیط توسعه)
    networks:
      - main
    restart: always

  # -----------------------------------------------------------------
  # 5. سرویس Nginx (Reverse Proxy & Static Server)
  # مدیریت ورودی‌های شبکه، SSL و هدایت درخواست‌ها به Gunicorn
  # -----------------------------------------------------------------
  nginx:
    container_name: nginx
    image: nginx:alpine # استفاده از نسخه سبک Alpine برای Nginx
    command: nginx -g 'daemon off;' # اجرای Nginx در حالت Foreground جهت زنده ماندن کانتینر
    depends_on:
      - app
    networks:
      - main
    ports:
      - "80:80" # اکسپوز پورت استاندارد وب به اینترنت/سیستم اصلی
    restart: always
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro # تزریق تنظیمات Nginx به کانتینر به صورت فقط‌خواندنی (Read-Only)

# -------------------------------------------------------------------
# تعاریف سطح اصلی (Root-Level Definitions)
# -------------------------------------------------------------------
networks:
  main:
    driver: bridge # ایجاد یک شبکه مجازی بر پایه درایور bridge جهت ارتباط کانتینرها

volumes:
  postgres_data: # تعریف Named Volume جهت ماندگاری داده‌های PostgreSQL
```

```
#------------------------------------------------------------------
# وقتی در بخشی داکر کامپوز رو عوض کردیم با استفاده از
docker compose down # docker موجود رو خاموش میکنم
docker compose up --build  # در این صورت هر چی تغییرات انجام شده بود انجام میشه از اول ساخته میشه

# بعد اچرا شدن داکر کامپوز میتوانیم دستورات خاص یا کتابخوانه ای نصب کنیم
docker-compose exec backend python manage.py migrate
#------------------------------------------------------------------
```
# add new libray in docker before starting 
docker compose exec backend sh -c "pip install python-decouple"

# display logs docker compose before starting docker 
docker compose logs -f backend


