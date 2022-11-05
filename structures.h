#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX_CHILDREN 500

typedef struct node
{
    struct node *children[MAX_CHILDREN]; // list of children of this node
    int number_children;                 // to access the next empty child
    struct node *bro;
    struct node *parent;
    char *type;
    char *value;
} node;

struct node *create_node(char *type, char *name);
struct node *create_node_2(char *type);
struct node *add_sibling(struct node *s1, struct node *s2);
struct node *add_child(struct node *parent, struct node *child);
int get_number_siblings(struct node *node);
void print_node(struct node *root, int depth);