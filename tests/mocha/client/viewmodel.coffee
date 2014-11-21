if typeof MochaWeb isnt 'undefined'
  MochaWeb.testOnly ->
    objectsAreEqual = (obj1, obj2) ->
      return false if obj1.length isnt obj2.length
      for p of obj1
        return false if obj1[p] isnt obj2[p]
      true

    assert = (vm, actual, expected) ->
      Global.delay 1, -> chai.assert.equal vm.enterPressed(), true
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

        it "should load from object with more values", ->
          vm.fromJS
            name: 'Doe'
            age: 31
            message: 'Nada'
            address: 'circle'
          chai.assert.equal vm.name(), 'Doe'
          chai.assert.equal vm.age(), 31
          chai.assert.equal vm.message(), 'Name: Doe - Age: 31'

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

      describe "enabled binding", ->
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
        it "should change with vm change", (done) ->
          vm.isEnabled true
          Global.delay 1, ->
            chai.assert.isFalse button.is(":disabled")
            done()

      describe "disabled binding", ->
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
        it "should change with vm change", (done) ->
          vm.isDisabled true
          Global.delay 1, ->
            chai.assert.isTrue button.is(":disabled")
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
          input = $("<input type='text' data-bind='value: name, delay: 10'>")
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
          Global.delay 15, ->
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