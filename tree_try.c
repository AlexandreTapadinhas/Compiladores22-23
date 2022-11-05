#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

typedef struct node {
    char *word;
    struct node *left;
    struct node *right;
} node;

node *newNode(char *word) {
    node *new = malloc(sizeof(node));
    new->word = word;
    new->left = NULL;
    new->right = NULL;
    return new;
}

node *insert(node *root, char *word) {
    if (root == NULL) {
        return newNode(word);
    }
    if (strcmp(word, root->word) < 0) {
        root->left = insert(root->left, word);
    } else if (strcmp(word, root->word) > 0) {
        root->right = insert(root->right, word);
    }
    return root;
}

void printTree(node *root) {
    if (root == NULL) {
        return;
    }
    printf("node: %s\n", root->word);
    printf("..");
    printTree(root->left);
    printf("..");
    printTree(root->right);
}

int main() {
    node *root = NULL;
    char word[100];
    root = insert(root, word);
    printTree(root);
    return 0;
}