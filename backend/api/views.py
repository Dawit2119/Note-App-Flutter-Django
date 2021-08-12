from rest_framework import generics, serializers
from rest_framework.response import Response
from rest_framework import status 
from rest_framework.decorators import api_view

from .serializers import NoteSerializer
from .models import Note 
 
@api_view(['GET'])
def getNotes(request):
    notes = Note.objects.all()
    serializer = NoteSerializer(notes,many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getNote(request,pk):
    try:
        note = Note.objects.get(pk=pk)
        serializer = NoteSerializer(note)
        return Response(serializer.data)
    except Note.DoesNotExist:
        return Response('Note doesn\'t exist',status=status.HTTP_404_NOT_FOUND) 

@api_view(['POST'])
def createNote(request):
    data = request.data 
    note = Note.objects.create( 
        body = data['body']
    )
    serializer = NoteSerializer(note)
    return Response(serializer.data,status=status.HTTP_201_CREATED)

@api_view(['PUT'])
def updateNote(request,pk):
    data = request.data
    note = Note.objects.get(id=pk)
    serializer = NoteSerializer(note,data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data,status=status.HTTP_202_ACCEPTED)
    else:
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)


@api_view(['DELETE'])
def deleteNote(request,pk):
    note = Note.objects.get(id=pk)
    note.delete()
    return Response('Note was deleted',status=status.HTTP_204_NO_CONTENT)
