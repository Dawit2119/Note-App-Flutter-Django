from django.urls import path 
from . import views
urlpatterns = [ 
    path('note/<int:pk>/',views.getNote),
    path('notes/',views.getNotes),
    path('notes/create/',views.createNote), 
    path('notes/<int:pk>/update/',views.updateNote),
    path('notes/<int:pk>/delete/',views.deleteNote)
    # path('',views.home,name='home')
]