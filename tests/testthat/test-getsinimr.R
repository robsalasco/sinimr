context("test-sinimr.R")

test_that("getsinimr returns a valid output", {
  
  tbl <- getsinimr(880, 2015)
  
  expect_is(tbl, "data.frame")
  expect_output(str(tbl), "345 obs. of  3 variables")
})