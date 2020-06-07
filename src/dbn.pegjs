{
    let ctx;
}

start
    = lines:lines _
    {
        return function (_ctx) {
            ctx = _ctx;
            //console.log("Run");
            lines({});
        }
    }

lines
    = _ line:line lines:lines
    {
        return function (locals) {
            line(locals);
            lines(locals);
        }
    }
    / _ line:line
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
    / invocation

number
    = number:[0-9]+
    {
        return function () {
            return parseInt(number.join(''), 10);
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
    / number

_
    = comment* [ \t\n]*

__
    = comment* [ \t\n]+

comment
    = [ \t\n]* "//" [^\n]*

paper_command
    = "paper" _ color:color
    {
        return function (locals) {
            //console.log("Paper", color());
            ctx.fillStyle = color(locals);
            ctx.fillRect(0, 0, 100, 100);
        }
    }

pen_command
    = "pen" _ color:color
    {
        return function (locals) {
            //console.log("Pen", color());
            ctx.strokeStyle = color(locals);
        }
    }

line_command
    = "line" _ x1:coord _ y1:coord _ x2:coord _ y2:coord
    {
        return function (locals) {
            //console.log("Line", x1(), y1(), x2(), y2());
            ctx.moveTo(x1(locals), y1(locals));
            ctx.lineTo(x2(locals), y2(locals));
            ctx.stroke();
        }
    }

set_command
    = "set" _ name:name _ value:number
    {
        return function (locals) {
            //console.log("Set", name, value());
            locals[name] = value(locals);
        }
    }
    / "set" _ "[" _ x:coord _ y:coord _ "]" _ color:color
    {
        return function (locals) {
            //console.log("Dot", x(), y(), color());
            ctx.fillStyle = color(locals);
            ctx.fillRect(x(locals), y(locals), 1, 1);
        }
    }

repeat_command
    = "repeat" _ variable:name _ start:number _ end:number _ "{" lines:lines _ "}"
    {
        return function (locals) {
            //console.log("Repeat var=", variable);
            for (locals[variable] = start(locals); locals[variable] < end(locals); locals[variable]++) {
                lines(locals);
            }
        }
    }

command_command
    = "command" _ name:name args:args _ "{" lines:lines _ "}"
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
                console.log(locals);
                lines(locals);
            }
        }
    }

invocation
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
    = "log" _ number:number
    {
        return function (locals) {
            console.log("Log", number(locals));
        }
    }

args
    = arg:arg args:args
    {
        args.unshift(arg);
        return args;
    }
    / arg:arg
    {
        return [ arg ];
    }

arg
    = __ name:name
    {
        return name;
    }

values
    = value:value values:values
    {
        values.unshift(value);
        return values;
    }
    / value:value
    {
        return [ value ];
    }

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

