context("test-sinimr.R")

test_that("getsinimvariables returns a valid output", {
  
  tbl <- getsinimvariables(262)
  
  expect_is(tbl, "data.frame")
})