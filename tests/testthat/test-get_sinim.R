context("test-sinimr.R")

test_that("get_sinim returns a valid output", {
  
  tbl <- get_sinim(880, 2015)
  
  expect_is(tbl, "data.frame")
  expect_output(str(tbl), "346 obs. of  5 variables")
})

test_that("get_sinim returns a numeric", {
  
  tbl <- get_sinim(880, 2015)
  
  expect_true(is.numeric(tbl$VALUE))
})

test_that("get_sinim returns a character", {
  
  tbl <-  get_sinim(4333, 2017)
  
  expect_true(is.character(tbl$VALUE))
})

test_that("get_sinim returns a numeric on mixed", {
  
  tbl <-  get_sinim(c(880, 4210), 2017)
  
  expect_true(is.numeric(tbl$VALUE))
})

test_that("get_sinim returns a character on mixed", {
  
  tbl <-  get_sinim(c(4333, 4211), 2017)
  
  expect_true(is.character(tbl$VALUE))
})

test_that("get_sinim returns a numeric on failed", {
  
  tbl <-  get_sinim(c(4333, 4211), 2015)
  
  expect_true(is.numeric(tbl$VALUE))
})

test_that("get_sinim returns a sf object", {
  
  tbl <-  get_sinim(c(4333, 4211), 2015, geometry=T)
  
  expect_is(tbl, c("sf", "data.frame"))
})

test_that("get_sinim returns a valid output using a region subset", {
  
  tbl <-  get_sinim(c(4333, 4211), 2015, region=1)
  
  expect_is(tbl, c("data.frame"))
  expect_output(str(tbl), "14 obs. of  5 variables")
})

test_that("get_sinim returns a valid output using a provincia subset", {
  
  tbl <-  get_sinim(c(4333, 4211), 2015, provincia=14)
  
  expect_is(tbl, c("data.frame"))
  expect_output(str(tbl), "10 obs. of  5 variables")
})

test_that("get_sinim returns a valid output using a comuna subset", {
  
  tbl <-  get_sinim(c(4333, 4211), 2015, comuna=13123)
  
  expect_is(tbl, c("data.frame"))
  expect_output(str(tbl), "2 obs. of  5 variables")
})

