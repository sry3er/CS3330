/* do not remove these definitions or replace them #includes */
#define NULL 0
typedef long size_t;
void *malloc(size_t size);
void *realloc(void *ptr, size_t size);
void free(void* ptr);
int printf(const char *format, ...);

/* The following #ifdef and its contents need to remain as-is. */
#ifndef TYPE
#define TYPE short
TYPE sentinel = -1234;
#else
extern TYPE sentinel;
#endif

/* typedefs needed for this task: */
typedef struct node_t { TYPE payload; struct node_t *next; } node;
typedef struct range_t { unsigned int length; TYPE *ptr; } range;

int lengthOf(node *list) {
    int i=0; while(list) { list = (*list).next; i+=1; } return i;
}

range convert(node *list) {
  range output; 
  output.length = lengthOf(list);
  output.ptr = malloc(output.length * sizeof(TYPE));
  TYPE *pIter = output.ptr;
  for (unsigned int i = 0; i< output.length;i++)
  {
    *pIter = list->payload;
    pIter++;
    list = list->next;
  }
  return output;
}
void append(range *dest, range source) {
  TYPE* newPtr = malloc((dest->length + source.length)*sizeof(TYPE));
  unsigned int i = 0;
  unsigned int newLen = dest->length + source.length;
  while (i< dest->length)
  {
   newPtr[i] = (dest->ptr)[i];
   i++;  
  }
  unsigned int j = 0;
  while (j< source.length && i<newLen)
  {
   newPtr[i] = source.ptr[j];
   i++;
  	j++;
  }
  dest->length = newLen;
  free(dest->ptr);
  dest->ptr = newPtr;
  return;
}
void remove_if_equal(range *dest, TYPE value) {
  unsigned int i = 0;
  unsigned int newLen = dest->length;
  TYPE* ptrIter = dest->ptr;
  while (i< dest->length)
  {
   if (*ptrIter == value)
   {
     newLen--;
   }
   i++;
   ptrIter++;
  }
  TYPE* newPtr = malloc(newLen* sizeof(TYPE));
  i = 0;
  unsigned int j = 0;
  while (i<newLen)
  {
   if (dest->ptr[j] == value)
   {
    j++;
    continue;
   }
   newPtr[i] = dest->ptr[j];
   i++;
   j++;
  }
  free(dest->ptr);
  dest->ptr = newPtr;
  dest->length = newLen;
  return;
}
