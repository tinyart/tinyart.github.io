{
    let ctx;
}

start
    = lines:lines
    {
        return function (_ctx) {
            ctx = _ctx;
            //console.log("Run");
            lines({});
        }
    }

lines
    = whitespace line:line lines:lines whitespace
    {
        return function (locals) {
            line(locals);
            lines(locals);
        }
    }
    / whitespace line:line
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
    / invocation
    / "//" [^\n]* "\n"
    {
        return function () {}
    }

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
                expected("Variable not defined");
            }
            //console.log("Var", name);
            return locals[name];
        }
    }

calculation
    = left:additive whitespace "+" whitespace right:calculation
    {
        return function (locals) {
            return left(locals) + right(locals); 
        }
    }
    / minuend:additive whitespace "-" whitespace subtrahend:calculation
    {
        return function (locals) {
            return minuend(locals) - subtrahend(locals);
        }
    }
    / additive
    / number

additive
    = left:number whitespace "*" whitespace right:additive
    {
        return function (locals) {
            return left(locals) * right(locals);
        }
    }
    / dividend:number whitespace "/" whitespace divisor:additive
    {
        return function (locals) {
            return dividend(locals) / divisor(locals);
        } 
    }
    / number

whitespace
    = [ \t\n]*

paper_command
    = "paper" whitespace color:color
    {
        return function (locals) {
            //console.log("Paper", color());
            ctx.fillStyle = color(locals);
            ctx.fillRect(0, 0, 100, 100);
        }
    }

pen_command
    = "pen" whitespace color:color
    {
        return function (locals) {
            //console.log("Pen", color());
            ctx.strokeStyle = color(locals);
        }
    }

line_command
    = "line" whitespace x1:coord whitespace y1:coord whitespace x2:coord whitespace y2:coord
    {
        return function (locals) {
            //console.log("Line", x1(), y1(), x2(), y2());
            ctx.moveTo(x1(locals), y1(locals));
            ctx.lineTo(x2(locals), y2(locals));
            ctx.stroke();
        }
    }

set_command
    = "set" whitespace name:name whitespace value:number
    {
        return function (locals) {
            //console.log("Set", name, value());
            locals[name] = value(locals);
        }
    }
    / "set" whitespace "[" whitespace x:coord whitespace y:coord whitespace "]" whitespace color:color
    {
        return function (locals) {
            //console.log("Dot", x(), y(), color());
            ctx.fillStyle = color(locals);
            ctx.fillRect(x(locals), y(locals), 1, 1);
        }
    }

repeat_command
    = "repeat" whitespace variable:name whitespace start:number whitespace end:number whitespace "{" lines:lines "}"
    {
        return function (locals) {
            //console.log("Repeat var=", variable);
            for (locals[variable] = start(locals); locals[variable] < end(locals); locals[variable]++) {
                lines(locals);
            }
        }
    }

command_command
    = "command" whitespace name:name args:args whitespace "{" lines:lines "}"
    {
        return function (command_locals) {
            command_locals[name] = function (invokation_locals, values) {
                const locals = { 
                    ...command_locals,
                    ...invocation_locals
                };

                // Merge in actual parameters
                args.forEach(function (arg, i) {
                    locals[arg] = values[i];
                });
                lines(locals);
            }
        }
    }

invocation
    = name:name values:args whitespace "\n"
    {
        return function (locals) {
            if (!locals.hasOwnProperty(name)) {
                expected(`Command ${name} not defined`);
            }
            console.log("Cmd", name);

            return locals[name](locals, values);
        }
    }

args
    = arg:arg args:args
    {
        args.unshift(arg);
        return args;
    }
    / arg
    {
        return [ arg ];
    }

arg
    = whitespace name:name
    {
        return name;
    }

color
    = number:number
    {
        return function (locals) {
            let color = number();

            const unchecked = '_nocheck' in locals && locals['_nocheck'] == 1;
            //console.log("Color " + (unchecked ? '(unchecked)' : ''), color);

            if (!unchecked && (color < 0 || color > 100)) {
                expected('Color must be between 0 and 100');
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
            let coord = number();

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

