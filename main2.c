#include "func.h"

double (*fp)(double d);

int main()
{
    fp = func;
    fp(1.0);
    return 0;
}
