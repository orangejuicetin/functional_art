set -x
stack build &&
stack exec functional-art-exe &&
convert -delay 10 -loop 0 {1..100}.png out.gif