using Bonito
import Bonito.TailwindDashboard as D

function range_slider(orientation)
    range_slider = RangeSlider(1:100; value=[10, 80])
    range_slider.tooltips[] = true
    range_slider.ticks[] = Dict(
        "mode" => "range",
        "density" => 3
    )
    range_slider.orientation[] = orientation
    return range_slider
end

App() do
    titre  = DOM.div(DOM.h1("Classification des images manuelles"), js"""console.log('Classification')""")
    button = D.Button("click")
    textfield = D.TextField("type in your text")
    numberinput = D.NumberInput(0.0)
    file_input = D.FileInput()
    on(file_input.value) do file
        @show file
    end
    slider = D.Slider("Test", 1:5)

    checkbox = D.Checkbox("check this", true)
    table = Bonito.Table([(a=22, b=33, c=44), (a=22, b=33, c=44)])

    source = """
    function test(a, b)
        return a + b
    end
    """
    editor = CodeEditor("julia"; initial_source=source, width=250, height=200, scrollPastEnd=false)
    dropdown = D.Dropdown("chose", ["option 1", "option 2", "option 3"])

    vrange_slider = range_slider(Bonito.WidgetsBase.vertical)

    hrange_slider = range_slider(Bonito.WidgetsBase.horizontal)


    return DOM.div(
        D.Card.([
            D.FlexRow(
                
                D.Card(D.FlexCol(
                    titre,
                    button,
                    textfield,
                    numberinput,
                    dropdown,
                    file_input,
                    slider,
                    checkbox,
                    class="items-start"
                )),
                D.Card(D.FlexCol(
                    D.Card(DOM.div(vrange_slider; style="height: 200px; padding: 1px 50px")),
                    D.Card(DOM.div(hrange_slider; style="width: 200px; padding: 50px 1px"),
                    )),
                )),
            D.FlexRow(
                D.Card.([

                    D.Card(table; class="w-64")
                    editor
                ])
            ),
        ])...
    )
end



