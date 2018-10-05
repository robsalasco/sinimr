context("test-sinimr.R")

test_that("getsinimryears returns a valid output", {
  
  tbl <- getsinimryears(880, c(2016, 2017))
  
  expect_is(tbl, "data.frame")
  expect_output(str(tbl), "690 obs. of  4 variables")
})