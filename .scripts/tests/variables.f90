program variables
  implicit none

  integer :: amount
  real :: pi
  complex :: frequency
  character :: initial
  logical :: isOkay
  integer :: age

  amount = 10
  pi = 3.14159265358
  frequency = (1.0, -0.5)
  initial = 'A'
  isOkay = .false.

  print *, 'The value of amount (integer) is: ', amount
  print *, 'The value of pi is: ', pi
  print *, 'The value of frequency is: ', frequency
  print *, 'The value of initial (character) is: ', initial
  print *, 'The value of isOkay (logical) is: ', isOkay


  print *, 'Please enter your age: '
  read(*,*) age

  print *, 'This is your age: ', age

end program variables
