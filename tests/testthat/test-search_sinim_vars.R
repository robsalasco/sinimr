context("test-sinimr.R")

test_that("search_sinim_vars returns a valid output", {
  
  srch <- search_sinim_vars("ingreso")
  
  expect_is(srch, "data.frame")
  expect_output(str(srch), "80 obs. of  6 variables")
})