#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct weapon { // 1. Compiler error typedef added
    char* name;
    int     range;
    float   damage;
    bool    in_inventory;
} weapon;

weapon* 
create_weapon(
    char* name,
    int     range,
    float   damage,
    bool    in_inventory
) {
    weapon* new_weapon=malloc(sizeof(weapon)); //2nd compiler error initialize variable by allocating space
    new_weapon -> name = name;
    (*new_weapon).range = range; //3rd compiler error lines 21-23 use (* ). or ->
    (*new_weapon).damage = damage;
    (*new_weapon).in_inventory = in_inventory;
    return new_weapon;
}

int main() {
    weapon* weapons[5];
    weapon* bow = create_weapon("bow", 100, 15.5, true);
    weapons[0] = bow;
    weapon* crossbow = create_weapon("crossbow", 75, 20.75, false);
    weapons[1] = crossbow;
    weapon* sword = create_weapon("sword", 5, 30.0, true);
    weapons[2] = sword;
    weapon* longsword = create_weapon("longsword", 7, 35.8, false);
    weapons[3] = longsword;
    weapon* rapier = create_weapon("rapier", 4, 22.5, false);
    weapons[4] = rapier;

    printf("Weapons in inventory:\n");

    for (int i = 0; i < 5; i++) { // 1. runtime array out of bounds with i=5
        if (weapons[i]->in_inventory == true) { // 2. runtime error, compare and not is
            printf("%s \n", weapons[i]->name); //4. compiler error, printf need char* datatype
        }
    }

    for (int i = 0; i < 5; i++) {
        free(weapons[i]);
    }
}

