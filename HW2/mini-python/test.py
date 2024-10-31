# zero, one or several function definitions at the beginning of the file
def fibaux(a, b, k):
    if k == 0:
        return a
    else:
        return fibaux(b, a+b, k-1)
def fib(n):
    a = 2
    return fibaux(0, 1, n)
    # then one or several statements at the end of the file
print("a few values of the Fibonacci sequence:\n asdasd")
for n in [0, 1, 11, 42]:
    print(fib(n))