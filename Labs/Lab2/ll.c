/* Kun Fang (kf5wf) */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ll.h"

/* For a description of what the functions in this file are supposed to do,
   read ll.h
 */

static void give_up_on_malloc_error() {
    fprintf(stderr, "allocating memory failed!\n");
    abort();
}

ll_node *ll_new() {
    ll_node *new_node = (ll_node *)malloc(sizeof(ll_node));
    if (!new_node) give_up_on_malloc_error();
    new_node->next = new_node->prev = new_node;
    new_node->value = NULL;
    return new_node;
}

void ll_free(ll_node *root) {
    if (NULL == root)
    {
        return;
    }
    ll_node *cur = root->next;
    //prevents use after free
    if (cur == root)
    {
        if (NULL != root->next->value)
        {
            free(root->value);
        }
        free(root);
        return;
    }
    //cannot free root first since we cannot decide when to stop freeing with the list being circular
    //at this point at least one element is present in the list. whenever the next element is root, stop the loop
    do 
    {
        if (cur->value != NULL)
        {
            free(cur->value);
        }
        ll_node* temp = cur;
        cur = cur->next;
        free(temp);
    }
    while (cur != root);
    
    //free root node last
    if (NULL != root->value)
    {
        free(root->value);
    }
    free(root);
    return;
}


ll_node *ll_add_after(ll_node *new_prev, const char *new_value) {
    ll_node *new_node = (ll_node *)malloc(sizeof(ll_node));
    if (!new_node) give_up_on_malloc_error();
    
    new_node->value = (char*)malloc(strlen(new_value)+1);
    memset(new_node->value, 0, strlen(new_value)+1);
    if (!new_node->value) give_up_on_malloc_error();
    strncpy(new_node->value, new_value, strlen(new_value));
    new_node->next = new_prev->next;
    new_node->prev = new_prev;
    new_node->next->prev = new_node;
    new_node->prev->next = new_node;
    return new_node;
}

ll_node *ll_add_before(ll_node *new_next, const char *new_value) {
    return ll_add_after(new_next->prev, new_value);
}

void ll_remove(ll_node *node) {
    node->prev->next = node->next;
    node->next->prev = node->prev;
    free(node);
}

void ll_replace(ll_node *node, const char *new_value) {
    if (strlen(node->value) == strlen(new_value))
    {
        strncpy(node->value, new_value, strlen(new_value));
    }
    else
    {
        printf("Kun Fang");
        char* temp = node->value;
        free(temp);
        node->value = NULL;
        node->value = (char*)malloc(strlen(new_value)+1);
        memset(node->value, 0, strlen(new_value)+1);
        if (!node->value) give_up_on_malloc_error();
        strncpy(node->value, new_value, strlen(new_value));
    }
}

void ll_move_after(ll_node *node, ll_node *new_prev) {
    node->prev->next = node->next;
    node->next->prev = node->prev;
    node->prev = new_prev;
    node->next = new_prev->next;
    node->next->prev = node;
    node->prev->next = node;
}

ll_node *ll_copy_list(ll_node *root) {
    ll_node *new_root = ll_new();
    ll_node *new_cur = new_root;
    ll_node *old_cur = root->next;
    while (old_cur != root) {
        new_cur = ll_add_after(new_cur, old_cur->value);
        old_cur = old_cur->next;
    }
    return new_root;
}

void ll_print(ll_node *root) {
    int i = 0;
    ll_node *cur = root->next;
    while (cur != root) {
        printf("node #%d: value=[%s]\n", i, cur->value);
        i += 1;
        cur = cur->next;
    }
}
