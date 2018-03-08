#include <stdio.h>
#include <string.h>

#include "ll.h"

/* #x means "turn x into a string", so
   CHECK("foo", x == y) is the same as
   do_check("foo", "x == y", x == y)
*/
#define CHECK(y, x) do_check(y, #x, x)

static int failed_test = 0;

void do_check(const char* description, const char *code, int result) {
    if (!result) {
        fprintf(stderr, "failed test: %s: %s was false\n",
            description, code);
        failed_test = 1;
    }
}

ll_node *allocate_test_list(int id, int size) {
    ll_node *root = ll_new();
    for (int i = 0; i < size; ++i) {
        char buf[1024];
        sprintf(buf, "%d, element #%d", id, i);
        ll_add_before(root, buf);
    }
    return root;
}

void check_list(ll_node *root, const char *label) {
    int forward_length = 0;
    int backward_length = 0;
    CHECK(label, root->next->prev == root);
    CHECK(label, root->prev->next == root);
    CHECK(label, root->value == NULL);
    ll_node *cur = root->next;
    while (cur != root) {
        ++forward_length;
        CHECK(label, cur->value != NULL);
        CHECK(label, cur->next->prev == cur);
        CHECK(label, cur->prev->next == cur);
        cur = cur->next;
    }
    cur = root->prev;
    while (cur != root) {
        ++backward_length;
        cur = cur->prev;
    }
    CHECK(label, forward_length == backward_length);
}

void empty_list_test() {
    ll_node *list1 = ll_new();
    check_list(list1, "empty list");
    ll_free(list1);
}

void singleton_list_test() {
    ll_node *list1 = ll_new();
    ll_add_after(list1, "First Test Value");
    ll_node *list2 = ll_copy_list(list1);
    ll_replace(list1->next, "Second Test Value");
    CHECK("still one element list", list1->next->next == list1);
    CHECK("copy copied value", strcmp(list2->next->value , "First Test Value") == 0);
    CHECK("replace changed value", strcmp(list1->next->value , "Second Test Value") == 0);
    check_list(list1, "one-element list");
    ll_remove(list1->next);
    check_list(list1, "zero-element list from remove");
    ll_free(list1);
    check_list(list2, "copy of one-element list");
    ll_free(list2);
}

void replace_add_test() {
    ll_node *list1 = allocate_test_list(1, 8);
    ll_replace(list1->next->next->next, "replacement value 1");
    ll_add_after(list1->prev->prev->prev, "new value 1");
    ll_add_before(list1->prev->prev->prev, "new value 2");
    ll_node *list2 = ll_copy_list(list1);
    ll_remove(list1->next->next);
    ll_remove(list1->next->next->next);

    ll_move_after(list1->prev->prev->prev, list1->next->next->next);
    
    check_list(list1, "8-element list, after replace, add, add, remove, remove");
    CHECK("moved replacement value 1", strcmp(list1->next->next->value, "replacement value 1") == 0);
    CHECK("moved new value 1", strcmp(list1->next->next->next->next->value, "new value 1") == 0);
    
    check_list(list2, "copy of 8-element list after replace, add, add");
    CHECK("unmoved replacement value 1", strcmp(list2->next->next->next->value, "replacement value 1") == 0);
    CHECK("unmoved new value 1", strcmp(list2->prev->prev->prev->value, "new value 1") == 0);
    CHECK("unmoved new value 2", strcmp(list2->prev->prev->prev->prev->value, "new value 2") == 0);

    ll_free(list1);
    ll_free(list2);
}

void string_sizes_test() {
    ll_node *list1 = ll_new();
    for (int i = 0; i < 100; ++i) {
        char buf[1024];
        memset(buf, 'a', i);
        buf[i] = '\0';
        ll_add_before(list1, buf);
    }
    ll_node *cur = list1->next;
    for (int i = 0; i < 100; ++i) {
        CHECK("length of stored string", strlen(cur->value) == i);
        cur = cur->next;
    }
    check_list(list1, "increasing string lengths");
    ll_free(list1);
}


void big_list_test() {
    ll_node *list1 = allocate_test_list(1, 2 * 1024 * 1024);
    for (int i = 0; i < 1024 * 1024; ++i) {
        ll_remove(list1->next);
    }
    for (int i = 0; i < 1024 * 1024; ++i) {
        ll_add_before(list1, "new value");
    }
    check_list(list1, "big list");
    ll_free(list1);
}

int main(void) {
    printf(">>> running empty test\n");
    empty_list_test();
    printf(">>> running singleton test\n");
    singleton_list_test();
    printf(">>> running string sizes test\n");
    string_sizes_test();
    printf(">>> running replace/add test\n");
    replace_add_test();
    printf(">>> running big test\n");
    big_list_test();
    
    if (failed_test) {
        printf("FAILED A TEST -- ll.c is not correct!\n");
    } else {
        printf("PASSED ALL TESTS IN ll-test.c\n");
    }
}
