context("test-sinimr.R")

test_that("searchsinimvar returns a valid output", {
  
  srch <- searchsinimvar("ingreso")
  
  expect_is(srch, "data.frame")
  expect_output(str(srch), "65 obs. of  6 variables")
})