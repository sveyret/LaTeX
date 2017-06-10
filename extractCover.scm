(define (extract-cover inFile outFile res lostSpace)
  (let*
    (
      (image (car (gimp-file-load RUN-NONINTERACTIVE inFile inFile) ) )
      (drawable (car (gimp-image-active-drawable image) ) )
      (width (car (gimp-image-width image) ) )
      (height (car (gimp-image-height image) ) )
      (xsize (/ (* 148 res) 25.4) )
      (xpos (- (- width xsize) (/ (* lostSpace res) 25.4) ) )
      (ysize (/ (* 210 res) 25.4) )
      (ypos (- (- height ysize) (/ (* lostSpace res) 25.4) ) )
    )
    (gimp-image-crop image xsize ysize xpos ypos)
    (file-png-save-defaults RUN-NONINTERACTIVE image drawable outFile outFile)
  )
)

