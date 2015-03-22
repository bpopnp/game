css =
'''
<style type="text/css">
.point {
    width: 4px;
    height: 4px;
    padding: 0;
    margin: 0
} \
.point-active {
    background-color: red
}
</style>
'''
document.write css
document.write '<table id="game"></table>'

table = {
    width: 50,
    height: 60
}

digit_points = [
    ['***', '* *', '* *', '* *', '***'],
    ['  *', '  *', '  *', '  *', '  *'],
    ['***', '  *', ' *', '*', '***'],
    ['***', '  *', '***', '  *', '***'],
    ['* *', '* *', '***', '  *', '  *'],
    ['***', '  *', '***', '*', '***'],
    ['***', '*', '***', '* *', '***'],
    ['***', '  *', '  *', '  *', '  *'],
    ['***', '* *', '***', '* *', '***'],
    ['***', '* *', '***', '  *', '***']
]

activate_point = (x, y) ->
    utils.get_td(x, y).addClass 'point-active'

deactivate_point = (x, y) ->
    utils.get_td(x, y).removeClass 'point-active'

clean_table = (x, y, width, height) ->
    for i in [x..x + width - 1]
        for j in [y..y + height - 1]
            deactivate_point i, j
draw_points = (points, x, y) ->
    for i in [0..points.length - 1]
        line = points[i]
        for j in [0..line.length - 1]
            if line.charAt(j) == '*'
                activate_point j + x, i + y

draw_number = (number) ->
    digits = number.toString()
    for i in [0..digits.length - 1]
        x = 2 + 4 * i
        y = table.height - 7
        draw_points digit_points[parseInt(digits.charAt(i))], x, y

class Game
    constructor: ->
        @snake = new Snake
    draw: =>
        @snake.draw()
        for i in [0..table.width - 1]
            activate_point i, 0
            activate_point i, table.height - 1
            activate_point i, table.height - 1 - 10
        for i in [0..table.height - 1]
            activate_point 0, i
            activate_point table.width - 1, i
    start: =>
        if window.addEventListener
            window.addEventListener 'keydown', @onkeydown, false
        else if document.attachEvent
            document.attachEvent 'onkeydown', @onkeydown
        else
            document.addEventListener 'keydown', @onkeydown, false
        @main_loop()
    onkeydown: (event) =>
        code = if event.charCode then event.charCode else event.keyCode
        dir = @snake.direction
        if code == 'w'.charCodeAt(0) or code == 'W'.charCodeAt(0) or code == 38
            dir = 0
        else if code == 'd'.charCodeAt(0) or code == 'D'.charCodeAt(0) or code == 39
            dir = 1
        else if code == 's'.charCodeAt(0) or code == 'S'.charCodeAt(0) or code == 40
            dir = 2
        else if code == 'a'.charCodeAt(0) or code == 'A'.charCodeAt(0) or code == 37
            dir = 3
        @snake.turn dir
    main_loop: =>
        if @snake.go_ahead()
            setTimeout @main_loop, 50 / @snake.speed
        else
            clean_table 1, 1, table.width - 2, table.height - 2 - 10
            draw_points [
                '****  **  *   * ****  **** * * **** *** ',
                '*    *  * ** ** *     *  * * * *    *  *',
                '*  * **** * * * ****  *  * * * **** *** ',
                '*  * *  * * * * *     *  * * * *    * * ',
                '**** *  * * * * ****  ****  *  **** *  *'
            ], 4, 2

class Snake
    constructor: ->
        @direction = 1
        @points = [1, 5, 2, 5, 3, 5, 4, 5]
        @generate_food()
        @has_turned = false
        @speed = 1.0
        @eaten = 0
        draw_number 0
    draw: =>
        for i in [0..@points.length / 2 - 1]
            x = @points[2*i]
            y = @points[2*i+1]
            activate_point x, y
    go_ahead: =>
        deactivate_point @points[0], @points[1]
        @points = @points.slice(2)
        activate_point @food.x, @food.y
        return @extend()
    extend: =>
        @has_turned = false
        x = @points[@points.length - 2]
        y = @points[@points.length - 1]
        new_x = x
        new_y = y
        switch @direction
            when 0
                new_x = x
                new_y = y - 1
            when 1
                new_x = x + 1
                new_y = y
            when 2
                new_x = x
                new_y = y + 1
            when 3
                new_x = x - 1
                new_y = y
        if new_x >= table.width - 1 or new_x < 1 or
           new_y < 1 or new_y >= table.height - 10 - 1
            return false
        for i in [0..@points.length / 2 - 1]
            if new_x == @points[2*i] and new_y == @points[2*i+1]
                return false
        @points.push new_x
        @points.push new_y
        activate_point new_x, new_y
        if new_x == @food.x and new_y == @food.y
            @extend()
            @generate_food()
            @speed *= 1.035
            @eaten += 1
            clean_table 2, table.height - 7, 4 * @eaten.toString().length - 1, 5
            draw_number @eaten
            switch @eaten
                when 10 then utils.recover 1
                when 12 then utils.recover 2
                when 14 then utils.recover 3
                when 16 then utils.recover 4
                when 18 then utils.recover 5
                when 20 then utils.recover 6
                when 25 then utils.recover 7
        return true
    generate_food: =>
        @food = {
            x: Math.floor(Math.random() * (table.width - 4) + 2),
            y: Math.floor(Math.random() * (table.height - 4 - 10) + 2)
        }
    turn: (dir) =>
        if @has_turned
            return
        if @direction % 2 and dir % 2
            return
        else if !(@direction % 2) and !(dir % 2)
            return
        @has_turned = true
        @direction = dir

$ ->
    utils.set_style()
    utils.make_table table.width, table.height, 'point'
    game = new Game
    game.draw()
    game.start()