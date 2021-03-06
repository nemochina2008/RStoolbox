context("ggplot: ggR, ggRGB & fortify")


test_that("ggR returns proper ggplot2 classes or data.frames", {
            data(rlogo) 
            
            tests <- expand.grid(forceCat = c(TRUE, FALSE), anno = c(TRUE, FALSE), ggLayer = c(TRUE, FALSE), ggObj = c(TRUE,FALSE))
            builds <- lapply(1:nrow(tests), function(i) ggR(rlogo, forceCat = tests$forceCat[i], ggObj = tests$ggObj[i], geom_raster = !tests$anno[i], ggLayer = tests$ggLayer[i]))            
            tinfo <- paste0("forceCat=", tests[,1], ", anno=", tests[,2], ", ggLayer=", tests[,3], ", ggObj=", tests[,4])
            
            ## Annotation vs geom_raster    
            for(s in which(with(tests, ggObj & !ggLayer))) expect_is(builds[[s]], c("gg", "ggplot"), info = tinfo[s])
            
            ## ggLayers
            if(!inherits(builds[[which(with(tests, ggObj & ggLayer))[1]]], "ggproto")){
                ## Current ggplot2 release version
                for(s in which(with(tests, ggObj & ggLayer))) expect_is(builds[[s]], c("proto"), info = tinfo[s])
                for(s in which(with(tests, ggObj & ggLayer & anno)))  expect_equal(builds[[s]]$geom$objname, "raster_ann", info = tinfo[s])
                for(s in which(with(tests, ggObj & ggLayer & !anno))) expect_equal(builds[[s]]$geom$objname, "raster", info = tinfo[s])                       
            } else {
                ## Upcoming ggplot2 version (>=1.0.1.9002)
                for(s in which(with(tests, ggObj & ggLayer))) expect_is(builds[[s]]$geom, "GeomRaster", info = tinfo[s])
                for(s in which(with(tests, ggObj & ggLayer & anno)))  expect_is(builds[[s]]$geom, "GeomRasterAnn", info = tinfo[s])
                for(s in which(with(tests, ggObj & ggLayer & !anno))) expect_is(builds[[s]]$geom, "GeomRaster", info = tinfo[s])                       
                
                
            }
            ## Data.frames
            for(s in  which(with(tests, !ggObj))) expect_is(builds[[s]], "data.frame", info = tinfo[s])
            for(s in  which(with(tests, !ggObj & forceCat))) expect_is(builds[[s]][,3], "factor", info = tinfo[s])
            for(s in  which(with(tests, !ggObj ))) expect_is(builds[[s]]$fill, "character", info = tinfo[s])
            
            
        })



test_that("ggRGB returns proper ggplot2 classes or data.frames", {
            data(rlogo) 
            
            tests  <- expand.grid(anno = c(TRUE, FALSE), ggLayer = c(TRUE, FALSE), ggObj = c(TRUE,FALSE))
            builds <- lapply(1:nrow(tests), function(i) ggRGB(rlogo, ggObj = tests$ggObj[i], geom_raster = !tests$anno[i], ggLayer = tests$ggLayer[i]))            
            tinfo <- paste0("anno=", tests$anno, ", ggLayer=", tests$ggLayer, ", ggObj=", tests$ggObj)
            
            ## Stand-alone
            for(s in which(with(tests, ggObj & !ggLayer))) expect_is(builds[[s]], c("gg", "ggplot"), info = tinfo[s])
            
            ## ggLayers
            if(!inherits(builds[[which(with(tests, ggObj & ggLayer))[1]]], "ggproto")){
                ## Current ggplot2 release version
                for(s in which(with(tests, ggObj & ggLayer))) expect_is(builds[[s]], c("proto"), info = tinfo[s])
                for(s in which(with(tests, ggObj & ggLayer & anno)))  expect_equal(builds[[s]]$geom$objname, "raster_ann", info = tinfo[s])
                for(s in which(with(tests, ggObj & ggLayer & !anno))) expect_equal(builds[[s]]$geom$objname, "raster", info = tinfo[s])                       
            } else {
                ## Upcoming ggplot2 version (>=1.0.1.9002)
                for(s in which(with(tests, ggObj & ggLayer))) expect_is(builds[[s]]$geom, "GeomRaster", info = tinfo[s])
                for(s in which(with(tests, ggObj & ggLayer & anno)))  expect_is(builds[[s]]$geom, "GeomRasterAnn", info = tinfo[s])
                for(s in which(with(tests, ggObj & ggLayer & !anno))) expect_is(builds[[s]]$geom, "GeomRaster", info = tinfo[s])                       
            }    
            
            ## Data.frames
            for(s in  which(with(tests, !ggObj))) expect_is(builds[[s]], "data.frame", info = tinfo[s])
            for(s in  which(with(tests, !ggObj))) expect_is(builds[[s]]$fill, "character", info = tinfo[s])
        })



test_that("fortify.raster returns proper data.frames", {
            data(rlogo)
            
            for(i in 1:2) {
                df <- fortify(rlogo)
                expect_named(df, c("x", "y", "red", "green", "blue"))       
                expect_identical(nrow(df), 7777L)  
                expect_identical(nrow(fortify(rlogo, maxpixels = 10)), 6L)
                ## Single layer
                expect_named(fortify(rlogo[[1]]), c("x", "y", "red"))
                rlogo <- stack(rlogo)
            }
            
            
        })
