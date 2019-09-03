context("test-sinimr.R")

test_that("get_sinim_cats returns a valid output", {

  cat <- get_sinim_cats()
  
  expect_is(cat, "list")
  expect_output(str(cat), "List of 10")
})