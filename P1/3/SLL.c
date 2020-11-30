#include <stdio.h>
#include <stdlib.h>
//#include "sorted_list.h"

struct SortedLinkedListNode{
    int data;
    struct SortedLinkedListNode *next;
};

int main(){
    //SortedLinkedList_create()
    struct SortedLinkedListNode *head = NULL;
    head = (struct SortedLinkedListNode *) malloc(sizeof(struct SortedLinkedListNode));
    head->data=90; //NULL
    head->next=NULL;
    printf("create\n");

    //SLL_add(list, data) 
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

    //SLL_get(list)
    if(head==NULL){
        printf("List Empty");
    }
    else{
        printf("%d", head->data);
    }

    return 0;
}