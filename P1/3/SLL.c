#include <stdio.h>
#include <stdlib.h>
#include "SLL.h"

typedef struct SortedLinkedListNode{
    int data;
    struct SortedLinkedListNode *next;
}SortedLinkedListNode;

typedef struct SortedLinkedList{
    SortedLinkedListNode firstElement;
}SortedLinkedList;


SortedLinkedList* SortedLinkedList_create(){
    struct SortedLinkedListNode *head = NULL;
    SortedLinkedList sorted_list;
};

void SortedLinkedList_addToList(SortedLinkedList* list, int data){
    (*list).head = (struct SortedLinkedListNode *) malloc(sizeof(struct SortedLinkedListNode));
    (*list).head->data;
    (*list).head->next=NULL;
};

void SortedLinkedList_delete(SortedLLinkedList* list){
    //SLL_delete(list)
    /*
    struct SortedLinkedListNode *temp_delete1 = NULL;
    struct SortedLinkedListNode *temp_delete2 = NULL;
    temp_delete1 = head;
    while (temp_delete1 != NULL)
    {
        temp_delete2 = temp_delete1->next;
        free(temp_delete1);
        temp_delete1 = temp_delete2;
    }
    printf("delete\n");
    */

};

SortedLinkedListNode* SortedLinkedList_getSmallest(SortedlinkedList* list){

};

int main(){
    // create list
    SortedLinkedList *list = SortedLinkedList_create();

    // add element to list
    SortedLinkedList_addToList(list, 90);

    struct SortedLinkedListNode *temp_add;
    struct SortedLinkedListNode *add = (struct SortedLinkedListNode *) malloc(sizeof(struct SortedLinkedListNode));
    temp_add=head;
    add->data=42;
    add->next=NULL;
    if (temp_add->next==NULL)
    {
        temp_add->next=add;
    }
    else{
    while (add->data >= temp_add->data)
    {
        temp_add=temp_add->next;
    }
    add->next=temp_add->next;
    temp_add=add;}
    printf("Add\n");


    //SLL_get(list)
    if(head==NULL){
        printf("List Empty");
    }
    else{
        printf("%d", head->data);
    }

    return 0;
}
