context("test-sinimr.R")

test_that("get_sinim_var_name returns a valid output", {
  
  varname <- get_sinim_var_name("ingreso")
  
  expect_is(varname, "character")
})