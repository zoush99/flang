! Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
! See https://llvm.org/LICENSE.txt for license information.
! SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
!
! test I/O of quad-precision values

program test
  use ieee_arithmetic
  integer, parameter :: qp = 16, n = 22
  real(kind = qp) :: r(n)
  character(80) :: s(n)
  integer :: result(n), expect(n), i
  expect = 1
  result = 0
  r(1) = 123456789123456789.123456789123456789_qp
  r(2) = 123456789123456789123456789123456789._qp
  r(3) = 0.123456789123456789123456789123456789_qp
  r(4) = 0.0000000000000000123456789123456789123456789123456789_qp
  r(5) = 1.23456789123456789123456789123456789_qp
  r(6) = 1.23456789123456789123456789123456789e+9_qp
  r(7) = -1.23456789123456789123456789123456789e+99_qp
  r(8) = 1.23456789123456789123456789123456789e+999_qp
  r(9) = -1.23456789123456789123456789123456789e+4321_qp
  r(10) = 1.23456789123456789123456789123456789e-3_qp
  r(11) = -1.23456789123456789123456789123456789e-33_qp
  r(12) = 1.23456789123456789123456789123456789e-333_qp
  r(13) = -1.23456789123456789123456789123456789e-3333_qp
  r(14) = huge(0.0_qp)
  r(15) = -tiny(0.0_qp)
  r(16) = epsilon(0.0_qp)
  r(17) = ieee_value(r(17), ieee_positive_zero)
  r(18) = ieee_value(r(18), ieee_negative_zero)
  r(19) = ieee_value(r(19), ieee_positive_inf)
  r(20) = ieee_value(r(20), ieee_negative_inf)
  r(21) = ieee_value(r(21), ieee_signaling_nan)
  r(22) = ieee_value(r(22), ieee_quiet_nan)
  
  do i = 1, n
    write(s(i), 100) r(i)
  enddo
 
  if(s(1) == "123456789123456789.1234567891") result(1) = 1
  if(s(2) == "12.345678912345678912345678912E+34") result(2) = 1
  if(s(3) == "0.1234567891234567891234567891") result(3) = 1
  if(s(4) == "12.345678912345678912345678912E-18") result(4) = 1
  if(s(5) == "1.234567891234567891234567891") result(5) = 1
  if(s(6) == "1234567891.234567891234567891") result(6) = 1
  if(s(7) == "-12.345678912345678912345678912E+98") result(7) = 1
  if(s(8) == "12.345678912345678912345678912E+998") result(8) = 1
  if(s(9) == "-12.345678912345678912345678912E+4320") result(9) = 1
  if(s(10) == "12.345678912345678912345678912E-04") result(10) = 1
  if(s(11) == "-12.345678912345678912345678912E-34") result(11) = 1
  if(s(12) == "12.345678912345678912345678912E-334") result(12) = 1
  if(s(13) == "-12.345678912345678912345678912E-3334") result(13) = 1
  if(s(14) == "11.897314953572317650857593266E+4931") result(14) = 1
  if(s(15) == "-33.621031431120935062626778173E-4933") result(15) = 1
  if(s(16) == "19.259299443872358530559779426E-35") result(16) = 1
  if(s(17) == "0.000000000000000000000000000") result(17) = 1
  if(s(18) == "-0.000000000000000000000000000") result(18) = 1
  if(s(19) == "Inf") result(19) = 1
  if(s(20) == "-Inf") result(20) = 1
  if(s(21) == "NaN") result(21) = 1
  if(s(22) == "NaN") result(22) = 1
  100 FORMAT('', 2pG0.28, 5X, -2pG0.28)
  call check(result, expect, n)
end program
