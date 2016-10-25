module Calculator exposing (calculator)

type alias Calculator = {add : Float->Float->Float, 
                         minus : Float->Float->Float,
                         times : Float->Float->Float,
                         devide : Float->Float->Float}

calculator : Calculator
calculator = {add = (\x y -> x + y), 
              minus = (\x y -> x - y),
              times = (\x y -> x * y),
              devide = (\x y -> x / y)}