import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html

-- component import example
import Components.Button exposing ( calculatorButton, calculatorButtonWide )
import Event exposing (Event(..))
import Calculator exposing (calculator)
import String exposing (toFloat)

-- APP
main : Program Never 
main =
  Html.beginnerProgram { model = defaultModel, view = view, update = update }


-- MODEL
type alias Model = {display : String, 
                    function : Float->Float->Float, 
                    lastValue : Float, 
                    append : Bool, 
                    chainOperation : Bool}

defaultModel : Model
defaultModel = {display = "", 
                function = (\x y -> y), 
                lastValue = 0, 
                append = True, 
                chainOperation = False}

update : Event -> Model -> Model
update event model =
  case event of
    None -> model
    Clear -> defaultModel
    Number number -> updateDisplay model number
    Dot -> dot model
    Zero -> zero model
    Divide -> operation model calculator.divide
    Times -> operation model calculator.times
    Minus -> operation model calculator.minus
    Add -> operation model calculator.add
    Equal -> equal model

parseFloat: String -> Float
parseFloat input = Result.withDefault 0 (String.toFloat input)

operation : Model -> (Float->Float->Float) -> Model
operation model function =  let
                                newDisplay = calculate model
                            in
                            if String.isEmpty model.display 
                            then
                                model
                            else
                            if model.chainOperation
                            then
                              {model | function = function,
                                       display = newDisplay,
                                       lastValue = (parseFloat newDisplay),
                                       append = False}
                             else 
                              {model | function = function,
                                       lastValue = (parseFloat model.display),
                                       append = False,
                                       chainOperation = True}

updateDisplay : Model -> Int -> Model
updateDisplay model number = if model.append 
                             then {model | display = model.display ++ toString(number)}
                             else {model | display = toString(number), append = True}
                        
equal : Model -> Model
equal model =  if String.isEmpty model.display 
               then
                  model
               else
               if model.append 
               then {model | display = calculate model, 
                                lastValue = (parseFloat model.display),
                                append = False,
                                chainOperation = False}
               else {model | display = model.function (parseFloat model.display) model.lastValue |> toString,
                                append = False,
                                chainOperation = False}

calculate : Model -> String
calculate model = model.function model.lastValue (parseFloat model.display) |> toString 

zero : Model -> Model
zero model = if String.isEmpty model.display || not model.append
             then {model | display = "0", 
                           append = False}
             else {model | display = model.display ++ "0"}

dot : Model -> Model
dot model = if not (String.isEmpty model.display) && model.append
            then {model | display = appendDecimal model.display}
            else {model | display = "0.", append = True}

appendDecimal : String -> String
appendDecimal string = if String.contains "." string
                       then string
                       else string ++ "."

-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Event
view model =
  div [ class "calculator"][
    div [ class "row" ][
      div [ class "col-xs-12" ][
        div [ class "display" ][
          div [ class "display-text" ]
              [ text ( model.display ) ]
        ],
        div [ class "buttons" ][calculatorButtonWide Clear "Clear",
                                calculatorButton (Number 7) "7", 
                                calculatorButton (Number 8) "8",
                                calculatorButton (Number 9) "9",
                                calculatorButton Divide "÷",
                                calculatorButton (Number 4) "4", 
                                calculatorButton (Number 5) "5",
                                calculatorButton (Number 6) "6",
                                calculatorButton Times "x",
                                calculatorButton (Number 1) "1", 
                                calculatorButton (Number 2) "2",
                                calculatorButton (Number 3) "3",
                                calculatorButton Minus "-",
                                calculatorButton Zero "0",
                                calculatorButton Dot ".",
                                calculatorButton Equal "=",
                                calculatorButton Add "+"
                                ]
      ]
    ]
  ]
