#ifndef _SORTED_LIST_H_
#define _SORTED_LIST_H_

typedef struct SortedLinkedListNode SortedLinkedListNode;
typedef struct SortedLinkedList SortedLinkedList;

SortedLinkedList* SortedLinkedList_create();

void SortedLinkedList_addToList(SortedLinkedList* list, int data);

void SortedLinkedList_delete(SortedLinkedList* list);

SortedLinkedListNode* SortedLinkedList_getSmallest(SortedLinkedList* list);

#endif
