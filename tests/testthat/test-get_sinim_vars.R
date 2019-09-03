context("test-sinimr.R")

test_that("get_sinim_vars returns a valid output", {
  
  tbl <- get_sinim_vars(262)
  
  expect_is(tbl, "data.frame")
  expect_output(str(tbl), "4 obs. of  3 variables")
})