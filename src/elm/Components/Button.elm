module Components.Button exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Event exposing ( Event(..) )

-- Button component
calculatorButton : Event -> String -> Html Event
calculatorButton event buttonText =
  button [class "button", onClick event ] 
         [span[][ text (buttonText) ]]


calculatorButtonWide : Event -> String -> Html Event
calculatorButtonWide event buttonText =
  button [class "button wide", onClick event ] 
         [span[][ text (buttonText) ]]