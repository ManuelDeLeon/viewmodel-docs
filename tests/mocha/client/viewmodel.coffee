if typeof MochaWeb isnt 'undefined'
  MochaWeb.testOnly ->
    objectsAreEqual = (obj1, obj2) ->
      return false if obj1.length isnt obj2.length
      for p of obj1
        return false if obj1[p] isnt obj2[p]
      true

    arraysAreEqual = (a, b) ->
      a.length is b.length and a.every (elem, i) -> elem is b[i]

    describe "ViewModel", ->
      vm = {}
      beforeEach ->
        vm = new ViewModel
          name: 'John'
          age: 21
          message: -> "Name: #{@name()} - Age: #{@age()}"

      describe "New ViewModel", ->
        it "should have all methods", ->
          chai.assert.equal vm.name(), 'John'
          chai.assert.equal vm.age(), 21
          chai.assert.equal vm.message(), 'Name: John - Age: 21'

        it "should notify when object property is set to the same object", (done) ->
          vm.extend
            obj:
              num: 1
          Tracker.autorun (c) ->
            obj = vm.obj()
            if not c.firstRun
              chai.assert.equal obj.num, 2
              c.stop()
              done()

          vm.obj().num = 2
          vm.obj vm.obj()

        it "should notify when array property is set to the same object", (done) ->
          vm.extend
            obj: [1]
          Tracker.autorun (c) ->
            obj = vm.obj()
            if not c.firstRun
              chai.assert.equal obj.length, 1
              c.stop()
              done()

          vm.obj vm.obj()

      describe "reset", ->
        it "should reset all values", ->
          vm.extend
            address: '21 Jumpstreet'

          vm.name 'A'
          vm.age 1
          vm.address ''

          vm.reset()

          chai.assert.equal vm.name(), 'John'
          chai.assert.equal vm.age(), 21
          chai.assert.equal vm.message(), 'Name: John - Age: 21'
          chai.assert.equal vm.address(), '21 Jumpstreet'

      describe "toJS", ->
        it "should return object without functions", ->
          obj = vm.toJS()
          chai.assert objectsAreEqual obj,
            name: 'John'
            age: 21
        it "should return object with functions", ->
          obj = vm.toJS true
          chai.assert objectsAreEqual obj,
            name: 'John'
            age: 21
            message: 'Name: John - Age: 21'

        it "should output Array", ->
          vm.extend
            arr: ['a', 'b']
          obj = vm.toJS()
          chai.assert.isTrue obj.arr instanceof Array
          chai.assert.isFalse obj.arr instanceof ReactiveArray

      describe "fromJS", ->
        it "should load all values", ->
          vm.fromJS
            name: 'Doe'
            age: 31
          chai.assert.equal vm.name(), 'Doe'
          chai.assert.equal vm.age(), 31
          chai.assert.equal vm.message(), 'Name: Doe - Age: 31'

        it "should load less values", ->
          vm.fromJS
            name: 'Doe'
          chai.assert.equal vm.name(), 'Doe'
          chai.assert.equal vm.age(), 21

        it "should load falsy values", ->
          vm.extend
            last: 'Doe'

          vm.fromJS
            name: ''
            age: 0
            last: null
          chai.assert.equal vm.name(), ''
          chai.assert.equal vm.age(), 0
          chai.assert.equal vm.last(), null

        it "should load from object with more values", ->
          vm.fromJS
            name: 'Doe'
            age: 31
            message: 'Nada'
            address: 'circle'
          chai.assert.equal vm.name(), 'Doe'
          chai.assert.equal vm.age(), 31
          chai.assert.equal vm.message(), 'Name: Doe - Age: 31'

        it "should convert Array to ReactiveArray", ->
          vm.extend
            arr: ['a', 'b']
          vm.fromJS
            arr: ['c']
          chai.assert.isTrue vm.arr() instanceof ReactiveArray
          chai.assert.equal vm.arr().length, 1
          chai.assert.equal vm.arr()[0], 'c'

      describe "returnKey binding", ->
        input = {}
        beforeEach ->
          input = $("<input type='text' data-bind='value: name, returnKey: changeEnter'>")
          template = $("<div></div>").append(input)
          vm.extend
            enterPressed: false
            changeEnter: -> @enterPressed true
          vm.bind template
        it "should call method upon return key", (done) ->
          e = jQuery.Event("keypress")
          e.which = 13
          e.keyCode = 13
          input.trigger(e)
          Global.delay 1, ->
            chai.assert.isTrue vm.enterPressed()
            done()

      describe "all viewmodels", ->
        input = {}
        beforeEach ->
          vm = new ViewModel('test', { })
          template = $("<div></div>")
          vm.bind template
        it "should return vm by id", ->
          chai.assert.equal vm._vm_id, ViewModel.byId('test')._vm_id
        it "should return empty array by Template", ->
          chai.assert.isTrue ViewModel.byTemplate('test') instanceof Array
          chai.assert.equal 0, ViewModel.byTemplate('test').length
        it "should return 1 from all", ->
          chai.assert.isTrue ViewModel.all instanceof ReactiveArray

      describe "multiple value binding", ->
        input1 = {}
        input2 = {}
        beforeEach ->
          template = $("<div></div>")
          input1 = $("<input type='text' data-bind='value: name'>")
          template.append(input1)
          input2 = $("<input type='text' data-bind='value: name'>")
          template.append(input2)
          vm.bind template

        it "should set input's default value", ->
          Global.delay 1, ->
            chai.assert.equal 'John', input1.val()
            chai.assert.equal 'John', input2.val()
        it "should change input's value when vm changes", (done) ->
          vm.name 'Bob'
          Global.delay 1, ->
            chai.assert.equal 'Bob', input1.val()
            chai.assert.equal 'Bob', input2.val()
            done()
        it "should change vm value when input changes via input", (done) ->
          input1.val 'Bob'
          input1.trigger 'input'
          Global.delay 1, ->
            chai.assert.equal 'Bob', vm.name()
            Global.delay 1, ->
              chai.assert.equal 'Bob', input2.val()
              done()


      describe "value binding", ->
        input = {}
        beforeEach ->
          input = $("<input type='text' data-bind='value: name'>")
          template = $("<div></div>").append(input)
          vm._vm_id = Math.random().toString()
          vm.bind template
        it "should set input's default value", ->
          Global.delay 1, ->
            chai.assert.equal 'John', input.val()
        it "should change input's value when vm changes", (done) ->
          vm.name 'Bob'
          Global.delay 1, ->
            chai.assert.equal 'Bob', input.val()
            done()
        it "should change vm value when input changes via keypress", (done) ->
          input.val 'Bob'
          input.trigger 'keypress'
          Global.delay 1, ->
            chai.assert.equal 'Bob', vm.name()
            done()
        it "should change vm value when input changes via input", (done) ->
          input.val 'Bob'
          input.trigger 'input'
          Global.delay 1, ->
            chai.assert.equal 'Bob', vm.name()
            done()
        it "should change vm value when input changes via cut", (done) ->
          input.val 'Bob'
          input.trigger 'cut'
          Global.delay 1, ->
            chai.assert.equal 'Bob', vm.name()
            done()
        it "should change vm value when input changes via paste", (done) ->
          input.val 'Bob'
          input.trigger 'paste'
          Global.delay 1, ->
            chai.assert.equal 'Bob', vm.name()
            done()
        it "should change toJS when vm changes", (done) ->
          vm.name 'Bob'
          Global.delay 1, ->
            chai.assert.equal 'Bob', vm.toJS().name
            done()

        it "should not delay toJS when input changes via keypress", (done) ->
          input.val 'Bob'
          input.trigger 'keypress'
          Global.delay 1, ->
            chai.assert.equal 'Bob', vm.toJS().name
            done()

        it "should delay _vm_toJS when input changes via keypress before 500ms", (done) ->
          input.val 'Bob'
          input.trigger 'keypress'
          Global.delay 1, ->
            chai.assert.equal 'John', vm._vm_toJS().name
            done()

        it "should delay _vm_toJS when input changes via keypress after 500ms", (done) ->
          input.val 'Bob'
          input.trigger 'keypress'
          Global.delay 800, ->
            chai.assert.equal 'Bob', vm._vm_toJS().name
            done()

      describe "value binding with sessions", ->
        input = {}
        vm = {}
        beforeEach ->
          vm = new ViewModel 'valueBindingWithSessions',
            name: 'John'
          input = $("<input id='blah' type='text' data-bind='value: name'>")
          template = $("<div></div>").append(input)
          vm.bind template
        it "should set input's default value", ->
          Global.delay 1, ->
            chai.assert.equal 'John', input.val()
        it "should change input's value when vm changes", (done) ->
          Global.delay 1, ->
            vm.name 'Bob'
            Global.delay 1, ->
              chai.assert.equal 'Bob', input.val()
              done()
        it "should change vm value when input changes via keypress", (done) ->
          input.val 'Bob'
          input.trigger 'keypress'
          Global.delay 1, ->
            chai.assert.equal 'Bob', vm.name()
            done()
        it "should change vm value when input changes via input", (done) ->
          input.val 'Bob'
          input.trigger 'input'
          Global.delay 1, ->
            chai.assert.equal 'Bob', vm.name()
            done()
        it "should change vm value when input changes via cut", (done) ->
          input.val 'Bob'
          input.trigger 'cut'
          Global.delay 1, ->
            chai.assert.equal 'Bob', vm.name()
            done()
        it "should change vm value when input changes via paste", (done) ->
          input.val 'Bob'
          input.trigger 'paste'
          Global.delay 1, ->
            chai.assert.equal 'Bob', vm.name()
            done()

      describe "text binding", ->
        div = {}
        beforeEach ->
          div = $("<div data-bind='text: name'></div>")
          template = $("<div></div>").append(div)
          vm.bind template
        it "should set div's default text", ->
          chai.assert.equal 'John', div.text()
        it "should change div's text when vm changes", (done) ->
          vm.name 'Bob'
          Global.delay 1, ->
            chai.assert.equal 'Bob', div.text()
            done()

      describe "html binding", ->
        div = {}
        beforeEach ->
          vm.extend
            html: '<i>Italic</i>'
          div = $("<div data-bind='html: html'></div>")
          template = $("<div></div>").append(div)
          vm.bind template
        it "should set div's default html", ->
          chai.assert.equal '<i>Italic</i>', div.html()
        it "should change div's html when vm changes", (done) ->
          vm.html '<i>Italic!</i>'
          Global.delay 1, ->
            chai.assert.equal '<i>Italic!</i>', div.html()
            done()

      describe "class binding single", ->
        div = {}
        beforeEach ->
          vm.extend
            showPrimary: true
          div = $("<div data-bind='class: { btn-primary: showPrimary }'></div>")
          template = $("<div></div>").append(div)
          vm.bind template
        it "should set div's default class", ->
          chai.assert.isTrue div.hasClass('btn-primary')
        it "should change div's class when vm changes", (done) ->
          vm.showPrimary false
          Global.delay 1, ->
            chai.assert.isFalse div.hasClass('btn-primary')
            done()

      describe "class binding multiple", ->
        div = {}
        beforeEach ->
          vm.extend
            css: 'primary large'
          div = $("<div data-bind='class: css'></div>")
          template = $("<div></div>").append(div)
          vm.bind template
        it "should set div's default class", ->
          chai.assert.isTrue div.hasClass('primary')
          chai.assert.isTrue div.hasClass('large')
        it "should change div's class when vm changes", (done) ->
          vm.css 'secondary small'
          Global.delay 1, ->
            chai.assert.isFalse div.hasClass('primary')
            chai.assert.isFalse div.hasClass('large')
            chai.assert.isTrue div.hasClass('secondary')
            chai.assert.isTrue div.hasClass('small')
            done()

      describe "style binding single", ->
        div = {}
        beforeEach ->
          vm.extend
            divColor: 'red'
          div = $("<div data-bind='style: { color: divColor }'></div>")
          template = $("<div></div>").append(div)
          vm.bind template
        it "should set div's default style", ->
          chai.assert.equal 'red', div.css('color')
        it "should change div's style when vm changes", (done) ->
          vm.divColor 'blue'
          Global.delay 1, ->
            chai.assert.equal 'blue', div.css('color')
            done()

      describe "style binding multiple", ->
        div = {}
        beforeEach ->
          vm.extend
            css: 'color: red, background: blue'
          div = $("<div data-bind='style: css'></div>")
          template = $("<div></div>").append(div)
          vm.bind template
        it "should set div's default style", ->
          chai.assert.equal 'red', div.css('color')
          chai.assert.equal 'blue', div.css('background')
        it "should change div's style when vm changes", (done) ->
          vm.css 'color: white, background: black'
          Global.delay 1, ->
            chai.assert.equal 'white', div.css('color')
            chai.assert.equal 'black', div.css('background')
            done()

      describe "style binding object", ->
        div = {}
        beforeEach ->
          vm.extend
            css: { color: 'red', background: 'blue' }
          div = $("<div data-bind='style: css'></div>")
          template = $("<div></div>").append(div)
          vm.bind template
        it "should set div's default style", ->
          chai.assert.equal 'red', div.css('color')
          chai.assert.equal 'blue', div.css('background')
        it "should change div's style when vm changes", (done) ->
          vm.css { color: 'white', background: 'black' }
          Global.delay 1, ->
            chai.assert.equal 'white', div.css('color')
            chai.assert.equal 'black', div.css('background')
            done()

      describe "click binding", ->
        button = {}
        beforeEach ->
          button = $("<button data-bind='click: changeEnter'>")
          template = $("<div></div>").append(button)
          vm.extend
            enterPressed: false
            changeEnter: -> @enterPressed true
          vm.bind template
        it "should call method upon click", (done) ->
          button.trigger('click')
          Global.delay 1, ->
            chai.assert.isTrue vm.enterPressed()
            done()

      describe "parameters in markup", ->
        button = {}
        beforeEach ->
          button = $("<button data-bind='click: name(\"Bob\")'>")
          template = $("<div></div>").append(button)
          vm.bind template

        it "should NOT call method without click", (done) ->
          Global.delay 1, ->
            chai.assert.equal vm.name(), 'John'
            done()
        it "should call method upon click", (done) ->
          button.trigger('click')
          Global.delay 1, ->
            chai.assert.equal vm.name(), 'Bob'
            done()

      describe "hover binding", ->
        button = {}
        beforeEach ->
          button = $("<button data-bind='hover: over'>")
          template = $("<div></div>").append(button)
          vm.extend
            over: false
          vm.bind template
        it "should have default value", ->
          chai.assert.isFalse vm.over()
        it "should call method upon mouseover", (done) ->
          button.trigger('mouseover')
          Global.delay 1, ->
            chai.assert.isTrue vm.over()
            done()
        it "should call method upon mouseout", (done) ->
          button.trigger('mouseover')
          button.trigger('mouseout')
          Global.delay 1, ->
            chai.assert.isFalse vm.over()
            done()

      describe "enabled binding - button", ->
        button = {}
        beforeEach ->
          button = $("<button data-bind='enabled: isEnabled'>")
          template = $("<div></div>").append(button)
          vm.extend
            isEnabled: false
          vm.bind template
        it "should have default value", ->
          chai.assert.isFalse vm.isEnabled()
          chai.assert.isTrue button.is(":disabled")
          chai.assert.isFalse button.hasClass("disabled")
        it "should change with vm change", (done) ->
          vm.isEnabled true
          Global.delay 1, ->
            chai.assert.isFalse button.is(":disabled")
            chai.assert.isFalse button.hasClass("disabled")
            done()

      describe "enabled binding - input", ->
        input = {}
        beforeEach ->
          input = $("<input data-bind='enabled: isEnabled'>")
          template = $("<div></div>").append(input)
          vm.extend
            isEnabled: false
          vm.bind template
        it "should have default value", ->
          chai.assert.isFalse vm.isEnabled()
          chai.assert.isTrue input.is(":disabled")
          chai.assert.isFalse input.hasClass("disabled")
        it "should change with vm change", (done) ->
          vm.isEnabled true
          Global.delay 1, ->
            chai.assert.isFalse input.is(":disabled")
            chai.assert.isFalse input.hasClass("disabled")
            done()

      describe "enabled binding - div", ->
        div = {}
        beforeEach ->
          div = $("<div data-bind='enabled: isEnabled'><div>")
          template = $("<div></div>").append(div)
          vm.extend
            isEnabled: false
          vm.bind template
        it "should have default value", ->
          chai.assert.isFalse vm.isEnabled()
          chai.assert.isFalse div.is(":disabled")
          chai.assert.isTrue div.hasClass("disabled")
        it "should change with vm change", (done) ->
          vm.isEnabled true
          Global.delay 1, ->
            chai.assert.isFalse div.is(":disabled")
            chai.assert.isFalse div.hasClass("disabled")
            done()
            
      describe "disabled binding - button", ->
        button = {}
        beforeEach ->
          button = $("<button data-bind='disabled: isDisabled'>")
          template = $("<div></div>").append(button)
          vm.extend
            isDisabled: false
          vm.bind template
        it "should have default value", ->
          chai.assert.isFalse vm.isDisabled()
          chai.assert.isFalse button.is(":disabled")
          chai.assert.isFalse button.hasClass("disabled")
        it "should change with vm change", (done) ->
          vm.isDisabled true
          Global.delay 1, ->
            chai.assert.isTrue button.is(":disabled")
            chai.assert.isFalse button.hasClass("disabled")
            done()

      describe "disabled binding - input", ->
        input = {}
        beforeEach ->
          input = $("<input data-bind='disabled: isDisabled'>")
          template = $("<div></div>").append(input)
          vm.extend
            isDisabled: false
          vm.bind template
        it "should have default value", ->
          chai.assert.isFalse vm.isDisabled()
          chai.assert.isFalse input.is(":disabled")
          chai.assert.isFalse input.hasClass("disabled")
        it "should change with vm change", (done) ->
          vm.isDisabled true
          Global.delay 1, ->
            chai.assert.isTrue input.is(":disabled")
            chai.assert.isFalse input.hasClass("disabled")
            done()

      describe "disabled binding - div", ->
        div = {}
        beforeEach ->
          div = $("<div data-bind='disabled: isDisabled'></div>")
          template = $("<div></div>").append(div)
          vm.extend
            isDisabled: false
          vm.bind template
        it "should have default value", ->
          chai.assert.isFalse vm.isDisabled()
          chai.assert.isUndefined div.attr("disabled")
          chai.assert.isFalse div.hasClass("disabled")
        it "should change with vm change", (done) ->
          vm.isDisabled true
          Global.delay 1, ->
            chai.assert.isUndefined div.attr("disabled")
            chai.assert.isTrue div.hasClass("disabled")
            done()

      describe "visible binding", ->
        it "should have it", ->
          chai.assert.isTrue ViewModel.hasBind('visible')

      describe "focused binding", ->
        it "should have it", ->
          chai.assert.isTrue ViewModel.hasBind('focused')
          
      describe "if binding", ->
        it "should have it", ->
          chai.assert.isTrue ViewModel.hasBind('if')

      describe "attr binding multiple", ->
        anchor = {}
        beforeEach ->
          vm.extend
            href: '1'
            title: '2'
          anchor = $("<a data-bind='attr: { href: href, title: title }'></a>")
          template = $("<div></div>").append(anchor)
          vm.bind template
        it "should set anchor's default attr", ->
          chai.assert.equal '1', anchor.attr('href')
          chai.assert.equal '2', anchor.attr('title')
        it "should change anchor's attr when vm changes", (done) ->
          vm.href '11'
          vm.title '22'
          Global.delay 1, ->
            chai.assert.equal '11', anchor.attr('href')
            chai.assert.equal '22', anchor.attr('title')
            done()

      describe "checked binding", ->
        input = {}
        beforeEach ->
          vm.extend
            isChecked: false
          input = $("<input type='checkbox' data-bind='checked: isChecked'>")
          template = $("<div></div>").append(input)
          vm.bind template
        it "should set input's default value", ->
          chai.assert.isFalse input.is(':checked')
        it "should change input's value when vm changes", (done) ->
          vm.isChecked true
          Global.delay 1, ->
            chai.assert.isTrue input.is(':checked')
            done()
        it "should change vm value when input changes", (done) ->
          input.prop('checked', true)
          input.trigger 'change'
          Global.delay 1, ->
            chai.assert.isTrue vm.isChecked()
            done()

      describe "checked binding radios", ->
        inputRed = {}
        inputBlue = {}
        beforeEach ->
          vm.extend
            color: 'red'
          inputRed = $("<input type='radio' name='color' value='red' data-bind='checked: color'>")
          inputBlue = $("<input type='radio' name='color' value='blue' data-bind='checked: color'>")
          template = $("<div></div>").append(inputRed).append(inputBlue)
          vm.bind template
        it "should set input's default value", ->
          chai.assert.isTrue inputRed.is(':checked')
          chai.assert.isFalse inputBlue.is(':checked')
        it "should change input's value when vm changes", (done) ->
          vm.color 'blue'
          Global.delay 1, ->
            chai.assert.isFalse inputRed.is(':checked')
            chai.assert.isTrue inputBlue.is(':checked')
            done()
        it "should change vm value when input changes", (done) ->
          inputBlue.prop('checked', true)
          inputBlue.trigger 'change'
          Global.delay 1, ->
            chai.assert.equal vm.color(), 'blue'
            done()

      describe "delay value binding", ->
        input = {}
        beforeEach ->
          input = $("<input type='text' data-bind='value: name, delay: 100'>")
          template = $("<div></div>").append(input)
          vm.bind template

        it "should change input's value immediately", (done) ->
          vm.name 'Bob'
          Global.delay 1, ->
            chai.assert.equal 'Bob', input.val()
            done()
        it "should not change vm value immediately", (done) ->
          input.val 'Bob'
          input.trigger 'keypress'
          Global.delay 1, ->
            chai.assert.notEqual 'Bob', vm.name()
            done()
        it "should change vm value later", (done) ->
          input.val 'Bob'
          input.trigger 'keypress'
          Global.delay 150, ->
            chai.assert.equal 'Bob', vm.name()
            done()

      describe "delay returnKey binding", ->
        input = {}
        beforeEach ->
          input = $("<input type='text' data-bind='value: name, returnKey: changeEnter, delay: 10'>")
          template = $("<div></div>").append(input)
          vm.extend
            enterPressed: false
            changeEnter: -> @enterPressed true
          vm.bind template
        it "should call method upon return key immediately", (done) ->
          e = jQuery.Event("keypress")
          e.which = 13
          e.keyCode = 13
          input.trigger(e)
          Global.delay 1, ->
            chai.assert.isTrue vm.enterPressed()
            done()

      describe "options binding", ->
        it "should throw error when bound to div", ->
          select = $("<div data-bind='options: countries'></div>")
          template = $("<div></div>").append(select)
          chai.assert.throws((-> vm.bind template), Error)

        it "should convert quotes in options values", ->
          select = $("<select data-bind='options: countries'></select>")
          template = $("<div></div>").append(select)
          vm.extend
            countries: ['"', "'", "&quot;"]
          vm.bind template
          options = select.find("option")
          chai.assert.equal options[0].value, '"'
          chai.assert.equal options[1].value, "'"
          chai.assert.equal options[2].value, "&quot;"

        describe "with array - single selection", ->
          beforeEach ->
            vm.extend
              countries: ['France', 'Germany', 'Spain']
              selectedCountry: 'Germany'

          it "combobox should select first value if not using the value binding", ->
            select = $("<select data-bind='options: countries'></select>")
            template = $("<div></div>").append(select)
            vm.bind template
            chai.assert.equal template.find(":selected").length, 1
            chai.assert.equal template.find(":selected").first().val(), "France"

          it "listbox (size) should not select a value if not using the value binding", ->
            select = $("<select size='5' data-bind='options: countries'></select>")
            template = $("<div></div>").append(select)
            vm.bind template
            chai.assert.equal template.find(":selected").length, 0

          it "listbox (multiple) should not select a value if not using the value binding", ->
            select = $("<select multiple data-bind='options: countries'></select>")
            template = $("<div></div>").append(select)
            vm.bind template
            chai.assert.equal template.find(":selected").length, 0

          describe "listbox - single", ->
            select = {}
            template = {}

            it "throws error value points to an array", ->
              vm.extend
                selectedCountries: ['France', 'Germany', 'Spain']
              select = $("<select size='5' data-bind='options: countries, value: selectedCountries'></select>")
              template = $("<div></div>").append(select)
              chai.assert.throws (-> vm.bind template), Error

            describe "normal", ->
              beforeEach ->
                select = $("<select size='5' data-bind='options: countries, value: selectedCountry'></select>")
                template = $("<div></div>").append(select)
                vm.bind template

              it "should select a value", ->
                chai.assert.equal template.find(":selected").length, 1
                chai.assert.equal template.find(":selected").first().val(), "Germany"

              it "should update vm", (done) ->
                select.val 'Spain'
                select.trigger 'change'
                Global.delay 1, ->
                  chai.assert.equal vm.selectedCountry(), 'Spain'
                  done()

              it "should update UI", (done) ->
                vm.selectedCountry 'Spain'
                Global.delay 1, ->
                  chai.assert.equal select.val(), 'Spain'
                  done()


          describe "combobox", ->
            select = {}
            beforeEach ->
              select = $("<select data-bind='options: countries, value: selectedCountry'></select>")
              template = $("<div></div>").append(select)
              vm.bind template

            it "should select a value", ->
              chai.assert.equal select.find(":selected").length, 1
              chai.assert.equal select.find(":selected").first().val(), "Germany"

            it "should update vm", (done) ->
              select.val 'Spain'
              select.trigger 'change'
              Global.delay 1, ->
                chai.assert.equal vm.selectedCountry(), 'Spain'
                done()

            it "should update UI", (done) ->
              vm.selectedCountry 'Spain'
              Global.delay 1, ->
                chai.assert.equal select.val(), 'Spain'
                done()

            it "throws error value points to an array", ->
              vm.extend
                selectedCountries: ['France', 'Germany', 'Spain']
              select = $("<select data-bind='options: countries, value: selectedCountries'></select>")
              template = $("<div></div>").append(select)
              chai.assert.throws (-> vm.bind template), Error


        describe "with array - multiple selection", ->
          beforeEach ->
            vm.extend
              countries: ['France', 'Germany', 'Spain']
              selectedCountries: ['Germany', 'Spain']
              badSelect: 'Germany'

          it "throws error value doesn't point to an array", ->
            select = $("<select multiple data-bind='options: countries, value: badSelect'></select>")
            template = $("<div></div>").append(select)
            chai.assert.throws (-> vm.bind template), Error

          describe "with multiple attribute", ->
            select = {}
            beforeEach ->
              select = $("<select multiple data-bind='options: countries, value: selectedCountries'></select>")
              template = $("<div></div>").append(select)
              vm.bind template

            it "notifies when selection changes", (done) ->
              Tracker.autorun (c) ->
                arr = vm.selectedCountries()
                if not c.firstRun
                  chai.assert.equal arr[0], 'Spain'
                  chai.assert.equal arr.length, 1
                  c.stop()
                  done()

              select.val ['Spain']
              select.trigger 'change'

            it "should update vm", (done) ->
              select.val ['France', 'Germany']
              select.trigger 'change'
              Global.delay 1, ->
                chai.assert.equal vm.selectedCountries().length, 2
                chai.assert.equal vm.selectedCountries()[0], 'France'
                chai.assert.equal vm.selectedCountries()[1], 'Germany'
                done()

            it "should update UI passing an array", (done) ->
              vm.selectedCountries ['France', 'Germany']
              Global.delay 1, ->
                chai.assert.isTrue arraysAreEqual(select.val(), ['France', 'Germany'])
                done()

            it "should update UI pushing an element", (done) ->
              vm.selectedCountries().push 'France'
              Global.delay 200, ->
                chai.assert.isTrue arraysAreEqual(select.val(), ['France', 'Germany', 'Spain'])
                done()

            it "should select the default values", ->
              selected = select.find(":selected")
              chai.assert.equal selected.length, 2
              chai.assert.equal selected[0].value, 'Germany'
              chai.assert.equal selected[1].value, 'Spain'