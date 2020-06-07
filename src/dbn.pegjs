{
    let state;
}

start
    = lines:lines _
    {
        return function (_state) {
            //console.log("Run");
            state = _state;

            const locals = {};

            locals.mouse = function (locals, values) {
                if (values.length != 1) {
                    expected("Mouse needs 1, 2 or 3");
                }
                const select = values[0](locals);
                switch (select) {
                    case 1:
                        return state.mousex;
                    case 2:
                        return state.mousey;
                    default:
                        expected(`Mouse needs 1, 2 or 3, got ${select}`);
                }
            };

            locals.time = function (locals, values) {
                if (values.length != 1) {
                    expected("Time needs 1, 2, 3 or 4");
                }
                const select = values[0](locals);
                const now = new Date();
                switch (select) {
                    case 1:
                        return now.getHours();
                    case 2:
                        return now.getMinutes();
                    case 3:
                        return now.getSeconds();
                    case 4:
                        return now.getMilliseconds();
                    default:
                        expected(`Time needs 1, 2, 3 or 4, got ${select}`);
                }
            };

            lines(locals);
        }
    }

lines
    = lines:indented_line*
    {
        return function (locals) {
            let result = null;
            for (let line of lines) {
                result = line(locals);
            }
            return result;
        }
    }

indented_line
    = _ line:line
    { 
        return line;
    }

line
    = paper_command
    / pen_command
    / line_command
    / set_command
    / repeat_command
    / command_command
    / log_command
    / predicate_command
    / forever_command
    / stop_command
    / value_command
    / command_invocation

number
    = sign:"-"? number:[0-9]+
    {
        return function () {
            let n = parseInt(number.join(''), 10);
            if (sign == "-") {
                n *= -1;
            }
            return n;
        }
    }
    / "(" calculation:calculation ")"
    {
        return calculation;
    }
    / name:name
    {
        return function (locals) {
            if (!locals.hasOwnProperty(name)) {
                expected(`Variable ${name} not defined`);
            }
            //console.log("Var", name);
            return locals[name];
        }
    }
    / "<" _ name:name values:values ">"
    {
        return function (locals) {
            if (!locals.hasOwnProperty(name)) {
                expected(`Command ${name} not defined`);
            }
            console.log("Cmd as value", name);

            return locals[name](locals, values);
        }
    }
    / "[" _ x:number __ y:number _ "]"
    {
        return function (locals) {
            const _x = x(locals);
            const _y = y(locals);
            return state.getdot(_x, _y);
        }
    }

calculation
    = left:additive _ "+" _ right:calculation
    {
        return function (locals) {
            return left(locals) + right(locals); 
        }
    }
    / minuend:additive _ "-" _ subtrahend:calculation
    {
        return function (locals) {
            return minuend(locals) - subtrahend(locals);
        }
    }
    / additive
    / number

additive
    = left:number _ "*" _ right:additive
    {
        return function (locals) {
            return left(locals) * right(locals);
        }
    }
    / dividend:number _ "/" _ divisor:additive
    {
        return function (locals) {
            return dividend(locals) / divisor(locals);
        } 
    }
    / dividend:number _ "%" _ divisor:additive
    {
        return function (locals) {
            return dividend(locals) % divisor(locals);
        } 
    }
    / number

_
    = comment* [ \t\n]*

__
    = comment* [ \t\n]+

comment
    = [ \t\n]* "//" [^\n]*

paper_command
    = "paper" __ color:color
    {
        return function (locals) {
            const _color = color(locals);
            state.paper(_color);
        }
    }

pen_command
    = "pen" __ color:color
    {
        return function (locals) {
            const _color = color(locals);
            state.pen(_color);
        }
    }

line_command
    = "line" __ x1:coord _ y1:coord _ x2:coord _ y2:coord
    {
        return function (locals) {
            const _x1 = x1(locals);
            const _y1 = y1(locals);
            const _x2 = x2(locals);
            const _y2 = y2(locals);
            state.line(_x1, _y1, _x2, _y2);
        }
    }

set_command
    = "set" __ name:name _ value:number
    {
        return function (locals) {
            //console.log("Set", name, value());
            locals[name] = value(locals);
        }
    }
    / "set" __ "[" _ x:coord _ y:coord _ "]" _ color:color
    {
        return function (locals) {
            const _x = x(locals);
            const _y = y(locals);
            const _color = color(locals);
            state.dot(_x, _y, _color);
        }
    }

repeat_command
    = "repeat" __ variable:name _ start:number _ end:number _ "{" lines:lines _ "}"
    {
        return function (locals) {
            //console.log("Repeat var=", variable);
            for (locals[variable] = start(locals); locals[variable] < end(locals); locals[variable]++) {
                lines(locals);
            }
        }
    }

command_command
    = ("command" / "number") __ name:name args:args _ "{" lines:lines _ "}"
    {
        return function (command_locals) {
            command_locals[name] = function (invocation_locals, values) {
                const locals = { 
                    ...command_locals,
                    ...invocation_locals
                };

                // Merge in actual parameters
                args.forEach(function (arg, i) {
                    locals[arg] = values[i](locals);
                });
                console.log("Invoke", locals, lines);
                return lines(locals);
            }
        }
    }

command_invocation
    = name:name values:values "\n"
    {
        return function (locals) {
            if (!locals.hasOwnProperty(name)) {
                expected(`Command ${name} not defined`);
            }
            console.log("Cmd", name);

            return locals[name](locals, values);
        }
    }

log_command
    = "log" __ number:number
    {
        return function (locals) {
            console.log("Log", number(locals));
        }
    }

forever_command
    = "forever" _ "{" lines:lines _ "}"
    {
        return function (locals) {
            console.log("Forever");
            state.timer = setInterval(function () { lines(locals); }, 100);
        }
    }

stop_command
    = "stop"
    {
        return function (locals) {
            console.log("Stop");
            if (state.timer) {
                clearInterval(state.timer);
                state.timer = null;
            }
            else {
                expected("Not in a forever loop");
            }
        }
    }

value_command
    = "value" __ number:number
    {
        return function (locals) {
            console.log("Value", number(locals));
            return number(locals);
        }; 
    }

predicate_command
    = type:( "smaller?" / "notsmaller?" / "same?" / "notsame?" ) _ n1:number _ n2:number _ "{" lines:lines _ "}"
    {
        return function (locals) {
            //console.log("Predicate?", type, n1(locals), n2(locals));

            let check, _n1 = n1(locals), _n2 = n2(locals);
            switch (type) {
                case "smaller?":
                    check = _n1 < _n2;
                    break;
                case "notsmaller?":
                    check = _n1 >= _n2;
                    break;
                case "same?":
                    check = _n1 == _n2;
                    break;
                case "notsame?":
                    check = _n1 != _n2;
                    break;
            }

            if (check) {
                lines(locals);
            }
       }
    }

args
    = args:(arg)*
    {
        //console.log("Args", args);
        return args;
    }

arg
    = _ name:name
    {
        return name;
    }

values
    = (value)*

value
    = __ number:number
    {
        return number;
    }

color
    = number:number
    {
        return function (locals) {
            let color = number(locals);

            const unchecked = '_nocheck' in locals && locals['_nocheck'] == 1;
            //console.log("Color " + (unchecked ? '(unchecked)' : ''), color);

            if (!unchecked && (color < 0 || color > 100)) {
                expected('Color must be between 0 and 100, got ${color}');
            }
            color *= 2.55;
            let hex = Math.round(color).toString(16);
            if (hex.length < 2) hex = '0' + hex;

            return '#' + hex.repeat(3);
        }
    }

coord
    = number:number
    {
        return function (locals) {
            let coord = number(locals);

            //console.log("Checked", '_nocheck' in locals, locals['_nocheck'], locals['_nocheck'] == 1);

            const unchecked = '_nocheck' in locals && locals['_nocheck'] == 1;
            //console.log("Coord " + (unchecked ? '(checked)' : ''), coord);

            if (!unchecked && (coord < 0 || coord > 100)) {
                expected(`Coordinate must be between 0 and 100, got ${coord}`);
            }

            return coord;
        }
    }

name
    = n1:[_a-zA-Z] n2:[_a-zA-Z0-9]*
    {
        const name = n1 + n2.join('');
        //console.log("Name", name);
        return name;
    }

