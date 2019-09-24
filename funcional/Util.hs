module Util where

repeatNewLine :: Int -> String
repeatNewLine 0 = ""
repeatNewLine n = "\n" ++ repeatNewLine (n-1)