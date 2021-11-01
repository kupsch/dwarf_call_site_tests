#include "func.h"

double (*fp)(double d);

int main()
{
    fp = (double (*)(double))(addr());
    fp(1.0);
    return 0;
}
