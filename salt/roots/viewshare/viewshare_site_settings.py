import os
DEBUG = False
TEMPLATE_DEBUG = DEBUG
REQUIRE_DEBUG = DEBUG

DATABASES = {
    'default': {
        'NAME': 'viewshare',
        'ENGINE': 'django.db.backends.mysql',
        'USER': 'viewshare',
        'PASSWORD': '{{ client_password }}',
        'HOST': 'localhost',
        'PORT': '',
    },
}

MEDIA_ROOT = '/srv/viewshare/shared/media/'
STATIC_ROOT = '/srv/viewshare/shared/static/'
FILE_UPLOAD_PATH = '/srv/viewshare/shared/upload'
FILE_DOWNLOAD_NGINX_OPTIMIZATION = True

AKARA_URL_PREFIX='{{ akara_url }}'

LOCAL_INSTALLED_APPS=('gunicorn',)

SECRET_KEY = '{{ secret_key }}'

COMPRESS_ROOT = STATIC_ROOT
COMPRESS_CSS_FILTERS=('compressor.filters.css_default.CssAbsoluteFilter',
                      'compressor.filters.cssmin.CSSMinFilter')
COMPRESS_ENABLED=True
COMPRESS_OFFLINE=False
COMPRESS_STORAGE='compressor.storage.GzipCompressorFileStorage'

TEMPLATE_LOADERS = (
    ('django.template.loaders.cached.Loader', (
        'django.template.loaders.filesystem.Loader',
        'django.template.loaders.app_directories.Loader',
    )),
)

LOCAL_PRE_MIDDLEWARE_CLASSES = (
    'django.middleware.gzip.GZipMiddleware',
)

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '127.0.0.1:11211',
    }
}

SESSION_ENGINE = 'django.contrib.sessions.backends.cached_db'

SITE_ID = '1'
SITE_NAME= 'Viewshare'
SITE_NAME_STATUS = ''
CELERY_ALWAYS_EAGER = False
SIMILE_PAINTER_SERVICE_URL = 'http://viewshare.org/painter'
ALLOWED_HOSTS = ('viewshare.org',)

{% if smtp_host %}
EMAIL_CONFIRMATION_DAYS = 2
EMAIL_DEBUG = DEBUG
EMAIL_HOST = '{{ smtp_host }}'
EMAIL_PORT = 587
EMAIL_HOST_USER = '{{ smtp_user }}'
EMAIL_HOST_PASSWORD = '{{ smtp_password }}'
EMAIL_USE_TLS = True
{% endif %}

CONTACT_EMAIL = 'ndiippaccess@loc.gov'
USER_APPROVAL_EMAIL_LIST=('ndiippaccess@loc.gov',)
DEFAULT_FROM_EMAIL = 'ndiippaccess@loc.gov'
USER_REGISTRATION_FROM_EMAIL = 'ndiippaccess@loc.gov'

{% if uservoice_account_key %}
USERVOICE_SETTINGS = {
    'ACCOUNT_KEY':'{{ uservoice_account_key }}',
    'HOST': 'viewshare.uservoice.com',
    'FORUM': '152959',
    'SSO_KEY': '{{ uservoice_sso_key }}',
    'support_queues': {
        'ignored_fields': 'Ignored Data',
        'augmentation': 'Augmentation',
        'upload': 'Data Load'
    }
}

SUPPORT_BACKEND = 'viewshare.apps.support.backends.uservoice.UservoiceSupportBackend'
SUPPORT_USER = 'support'
{% endif %}
