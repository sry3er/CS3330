#ifndef LL_H_
#define LL_H_

/*

This header file provides the interface for a circular doubly linked list.

The actual implementation is in ll.c.

Each node of the linked list contains a string value and a next and prev
pointer to another node. A node of the list with a NULL string value
represents `root'. Unlike a traditional linked list, the prev pointer of
the head node points to this root, and the next pointer of the tail node
also points to this root. The circular nature of the list simplifies
some of the insertion and deletion code by not making management of
the head/tail pointers a special case.

Given the `root' of this list iterating forwards looks something like:

  ll_node *cur = root->next;
  while (cur != root) {
      ...
      cur = cur->next;
  }

and iterating backwards looks the same, but replacing 'next' with 'prev'.

Except for the root node, all nodes should have a non-NULL value, pointing
to memory allocated with malloc(). All nodes should have a non-NULL next
and prev pointer.

*/

typedef struct ll_node ll_node;
struct ll_node {
    struct ll_node *prev;
    struct ll_node *next;
    char *value;
};

/* Create an empty list, return its root. */
ll_node *ll_new();

/* Free an entire list given its root. */
void ll_free(ll_node *root);

/* Add a node after a particular node -- or if new_prev is the root of the list,
   add a new node at the beginning of the list. */
ll_node *ll_add_after(ll_node *new_prev, const char *new_value);

/* Add a node before a particular node -- or if new_prev is the root of the list,
   add a new node at the end of the list. */
ll_node *ll_add_before(ll_node *new_prev, const char *new_value);

/* Remove a node from the linked list. */
void ll_remove(ll_node *node);

/* Change the value in a node in-place. */
void ll_replace(ll_node *node, const char *new_value);

/* Relocate a node without reallocating it to be after new_prev.
   This may move a node between lists. */
void ll_move_after(ll_node *node, ll_node *new_prev);

/* Make a copy of an entire list given its root. */
ll_node *ll_copy_list(ll_node *root);

/* Print out a list for debugging. */
void ll_print(ll_node *root);

#endif
