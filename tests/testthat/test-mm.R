context("test-sinimr.R")

test_that("mm returns a valid output", {
  
  var <- mm(5807587000)
  
  expect_is(var, "character")
})