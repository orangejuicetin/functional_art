# functional-art

Inspired by [RC's](https://recurse.com/about) Creative Coding meetup and [this blog post I stumbled upon](https://paytonturnage.com/writing/generating-art-with-haskell/)!

You can read my whole writeup on this in the [blog post](https://juicetin.bearblog.dev/generative-art-in-haskell) that I wrote for this project, but tl;dr (you gotta watch it for at least a few seconds):

![sample](https://github.com/orangejuicetin/functional_art/assets/47411373/d7a69389-0a12-4d70-ab56-dc644d70d45b)

Some really cool things you can do with the tools built in this file! Will be actively tinkering here and there with this as I research new designs, but ultimately has been incredibly helpful way to do something ~ tangible ~ in Haskell and learn a lot of the language and concepts in the process.

## How it works

In order to make this specific gif, we generate a 100 separate PNGs that are differing slightly in its RGB values – from there, we string it together using the `convert` CLI tool from [ImageMagick](https://imagemagick.org/index.php) (which unfortunately doesn't come standard in Terminal, so a quick `brew install` does the trick). And voilà!

Separately, in order to draw and color, we utilize a [Cairo binding](https://hackage.haskell.org/package/cairo-0.13.8.2/docs/Graphics-Rendering-Cairo.html) for Haskell that very well mimics the [typical C implementation](https://www.cairographics.org/)

For now this code is just a basic implementation that creates GIFs of varying transforming shades, and if you want to run it yourself you can use `run.sh` in order to compile them in your own directory. In the future however, I'll be updating this README with more creations that I end up tinkering with and try to draw out!
