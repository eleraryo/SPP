#ifndef _SORTED_LIST_H_
#define _SORTED_LIST_H_

struct SortedLinkedListNode{};
struct SortedLinkedList{};

SortedLinkedList* SortedLinkedList_create();

void SortedLinkedList_addToList(SortedLinkedList* list, int data);

void SortedLinkedList_delete(SortedLLinkedList* list);

SortedLinkedListNode* SortedLinkedList_getSmallest(SortedlinkedList* list);

#endif
