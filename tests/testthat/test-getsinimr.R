context("test-sinimr.R")

test_that("getsinimr returns a valid output", {
  
  tbl <- getsinimr(880, 2015)
  
  expect_is(tbl, "data.frame")
  expect_output(str(tbl), "345 obs. of  5 variables")
})

test_that("getsinimr returns a numeric", {
  
  tbl <- getsinimr(880, 2015)
  
  expect_true(is.numeric(tbl$VALUE))
})

test_that("getsinimr returns a character", {
  
  tbl <-  getsinimr(4333, 2017)
  
  expect_true(is.character(tbl$VALUE))
})

test_that("getsinimr returns a numeric on mixed", {
  
  tbl <-  getsinimr(c(880, 4210), 2017)
  
  expect_true(is.numeric(tbl$VALUE))
})

test_that("getsinimr returns a character on mixed", {
  
  tbl <-  getsinimr(c(4333, 4211), 2017)
  
  expect_true(is.character(tbl$VALUE))
})

test_that("getsinimr returns a numeric on failed", {
  
  tbl <-  getsinimr(c(4333, 4211), 2015)
  
  expect_true(is.numeric(tbl$VALUE))
})
