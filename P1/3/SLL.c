#include <stdio.h>
#include <stdlib.h>
#include "SLL.h"

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
    SortedLinkedListNode *head = NULL;
    return sorted_list;
};

// void SortedLinkedList_addToList2(SortedLinkedList* list, int data){
//     // compare size of data with list
//     SortedLinkedListNode* new_element = malloc(sizeof(struct SortedLinkedListNode));
//     (*new_element).data = data;
//     (*new_element).next = NULL;
    
//     if (list->head == NULL){
//         list->head = new_element;
//     }else{
//         while(data > )
//     }
//     // struct SortedLinkedListNode *tmp_add;
//     // struct SortedLinkedListNode *add = (struct SortedLinkedListNode *) malloc(sizeof(struct SortedLinkedListNode));
//     // tmp_add = head;
//     // add->data=42;
//     // add->next=NULL;
//     // if (tmp_add->next==NULL)
//     // {
//     //     tmp_add->next=add;
//     // }
//     // else{
//     // while (add->data >= tmp_add->data)
//     // {
//     //     tmp_add=tmp_add->next;
//     // }
//     // add->next=tmp_add->next;
//     // tmp_add=add;}
//     // printf("Add\n");
//     /*
    
//     */
// };

void SortedLinkedList_addToList(SortedLinkedList* list, int data){
    struct SortedLinkedListNode *tmp_add;
    struct SortedLinkedListNode *add = (struct SortedLinkedListNode *) malloc(sizeof(struct SortedLinkedListNode));
    tmp_add = list->head;
    add->data = data;
    add->next = NULL;
    if (tmp_add->next == NULL){
        tmp_add->next = add;
    }
    else{
        while (add->data >= tmp_add->data){
            tmp_add=tmp_add->next;
    }
        add->next=tmp_add->next;
        tmp_add=add;
    }
    printf("Added the element %d to the list\n", data);
};

void SortedLinkedList_delete(SortedLinkedList* list){
    struct SortedLinkedListNode *tmp_delete1 = NULL;
    struct SortedLinkedListNode *tmp_delete2 = NULL;
    tmp_delete1 = list->head;
    while (tmp_delete1 != NULL)
    {
        tmp_delete2 = tmp_delete1->next;
        free(tmp_delete1);
        tmp_delete1 = tmp_delete2;
    }
    printf("deleted list\n");
};

SortedLinkedListNode* SortedLinkedList_getSmallest(SortedLinkedList* sorted_list){
    //smallest element should be the first one as the list is sorted
    SortedLinkedListNode *current = sorted_list->head;

    if(current == NULL){
        printf("List Empty");
    }
    else{
        printf("%d", current->data);
    }

};

void print_list(SortedLinkedList* list){
    auto current = list->head;
    int j = 1;

    while (current != NULL){
        printf("The %d. element of the list is: %d", j, list->head->data);
        j++;
    }
}

int main(){
    // create list
    SortedLinkedList* sorted_list = SortedLinkedList_create();

    // add element to list
    SortedLinkedList_addToList(sorted_list, 90);
    SortedLinkedList_addToList(sorted_list, 42);

    print_list(sorted_list);

    // get smallest element
    SortedLinkedListNode* smallest =  SortedLinkedList_getSmallest(sorted_list);
    printf("The smallest element is ", smallest->data);

    // delete list
    SortedLinkedList_delete(sorted_list);
    
    print_list(sorted_list);

    return 0;
}
