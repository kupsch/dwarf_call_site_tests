double (*fp)(double d);

int main()
{
    fp = (double (*)(double))1000;
    fp(1.0);
    return 0;
}
