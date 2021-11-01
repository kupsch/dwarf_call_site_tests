#include "func.h"

int main()
{
    ((double (*)(double))addr())(1.0);
    return 0;
}
