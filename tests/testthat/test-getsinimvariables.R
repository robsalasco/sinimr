context("test-sinimr.R")

test_that("getsinimvariables returns a valid output", {
  
  tbl <- getsinimvariables(262)
  
  expect_is(tbl, "data.frame")
  expect_output(str(tbl), "4 obs. of  3 variables")
})