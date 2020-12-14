#include <stdio.h>
#include <stdlib.h>
#include "sorted_list.h"

typedef struct SortedLinkedListNode{
    int data;
    struct SortedLinkedListNode *next;
}SortedLinkedListNode;

typedef struct SortedLinkedList{
    SortedLinkedListNode *head;
}SortedLinkedList;

SortedLinkedList* SortedLinkedList_create(){
    // eine leere liste soll hier erstellt werden
    SortedLinkedList* sorted_list=malloc(sizeof(SortedLinkedList));
    //SortedLinkedListNode *head = NULL;
    sorted_list->head = NULL;
    return sorted_list;
};

void SortedLinkedList_addToList(SortedLinkedList* list, int data){
    struct SortedLinkedListNode *tmp_add1;
    struct SortedLinkedListNode *tmp_add2;
    struct SortedLinkedListNode *add = (struct SortedLinkedListNode *) malloc(sizeof(struct SortedLinkedListNode));
    tmp_add1 = list->head;
    tmp_add2 = list->head;
    add->data = data;
    add->next = NULL;
    if (tmp_add1 == NULL){ //case 1: list empty
        list->head = add;
    }
    else{
        if (add->data <= tmp_add1->data)
        {
            add->next=tmp_add1;
            list->head=add;
        }
        else{
        while (add->data >= tmp_add1->data){//case 2: somewhere in the middle 
            if(tmp_add1->next==NULL){// case 4: element at the very end?
               break; 
            }
            //traverse list
            tmp_add2=tmp_add1;
            tmp_add1=tmp_add1->next;
    }
        if (tmp_add1->next == NULL){//case 4 yup, at the very end
            tmp_add1->next = add;
        }
        else{//case 2/3 middle or smallest but not empty
        add->next=tmp_add1;
        tmp_add2->next=add;
        }
        }
    }
    printf("Added the element %d to the list\n", data);
};

void SortedLinkedList_delete(SortedLinkedList* list){
    struct SortedLinkedListNode *tmp_delete1;
    struct SortedLinkedListNode *tmp_delete2;
    tmp_delete1 = list->head;
    tmp_delete2 = list->head;
    while (tmp_delete1 != NULL)
    {
        tmp_delete2 = tmp_delete1->next;
        free(tmp_delete1);
        tmp_delete1 = tmp_delete2;
    }
    free(tmp_delete1);
    free(tmp_delete2);
    list->head=NULL;
    free(list);
    printf("Deleted list\n");
};

SortedLinkedListNode* SortedLinkedList_getSmallest(SortedLinkedList* list){
    //smallest element should be the first one as the list is sorted
    struct SortedLinkedListNode *current;
    current = list->head;
    if(current == NULL){
        printf("List Empty\n");
        return NULL;
    }
    else{
        printf("The smallest element is %d\n", current->data);
        return current;
    }

};

void print_list(SortedLinkedList* list){
    SortedLinkedListNode *current = list->head;
    int j = 1;

    while (current != NULL){
        printf("The %d. element of the list is: %d \n", j, current->data);
        current=current->next;
        j++;
    }
}

int main(){
    // create list
    SortedLinkedList* sorted_list = SortedLinkedList_create();
    // add element to list
    SortedLinkedList_addToList(sorted_list, 90);
    SortedLinkedList_addToList(sorted_list, 142);
    SortedLinkedList_addToList(sorted_list, 200);
    SortedLinkedList_addToList(sorted_list, 4);
    SortedLinkedList_addToList(sorted_list, 23);
    //print list
    print_list(sorted_list);

    // get smallest element
    SortedLinkedList_getSmallest(sorted_list);

    // delete list
    SortedLinkedList_delete(sorted_list);
    
    return 0;
}
