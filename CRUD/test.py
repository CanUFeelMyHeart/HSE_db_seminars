# *args -  позиционные и **kwargs - именованные

# *args

def mean(*nums):
    total = 0
    for num in nums:
        total += num
    return total / len(nums)
print(mean(1, 2, 3, 4, 5))

# **kwargs - аргументы по имени

def f(**test):
    return test.items()

print(f(a = 1, b = 2))
