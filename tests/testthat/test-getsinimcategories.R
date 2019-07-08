context("test-sinimr.R")

test_that("getcategories returns a valid output", {

  cat <- getsinimcategories()
  
  expect_is(cat, "list")
  expect_output(str(cat), "List of 10")
})