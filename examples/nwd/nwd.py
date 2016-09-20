a=int(input('liczba a='))
b=int(input('liczba b='))
while b != a:
  if a < b:
    b = b - a
  else:
    a = a - b
print(a)