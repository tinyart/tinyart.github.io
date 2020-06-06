{
    let ctx;
    const vars = {};
}

start
    = lines:lines
    {
        return function (_ctx) {
            ctx = _ctx;
            //console.log("Run");
            lines();
        }
    }

lines
    = whitespace line:line lines:lines whitespace
    {
        return function () {
            line();
            lines();
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
        return function () {
            if (!vars.hasOwnProperty(name)) {
                expected("Variable not defined");
            }
            //console.log("Var", name);
            return vars[name];
        }
    }

calculation
    = left:additive whitespace "+" whitespace right:calculation
    {
        return function () {
            return left() + right(); 
        }
    }
    / minuend:additive whitespace "-" whitespace subtrahend:calculation
    {
        return function () {
            return minuend() - subtrahend();
        }
    }
    / additive
    / number

additive
    = left:number whitespace "*" whitespace right:additive
    {
        return function () {
            return left() * right();
        }
    }
    / dividend:number whitespace "/" whitespace divisor:additive
    {
        return function () {
            return dividend() / divisor();
        } 
    }
    / number

whitespace
    = [ \t\n]*

paper_command
    = "paper" whitespace color:color
    {
        return function () {
            //console.log("Paper", color());
            ctx.fillStyle = color();
            ctx.fillRect(0, 0, 100, 100);
        }
    }

pen_command
    = "pen" whitespace color:color
    {
        return function () {
            //console.log("Pen", color());
            ctx.strokeStyle = color();
        }
    }

line_command
    = "line" whitespace x1:coord whitespace y1:coord whitespace x2:coord whitespace y2:coord
    {
        return function () {
            //console.log("Line", x1(), y1(), x2(), y2());
            ctx.moveTo(x1(), y1());
            ctx.lineTo(x2(), y2());
            ctx.stroke();
        }
    }

set_command
    = "set" whitespace name:name whitespace value:number
    {
        return function () {
            //console.log("Set", name, value());
            vars[name] = value();
        }
    }
    / "set" whitespace "[" whitespace x:coord whitespace y:coord whitespace "]" whitespace color:color
    {
        return function () {
            //console.log("Dot", x(), y(), color());
            ctx.fillStyle = color();
            ctx.fillRect(x(), y(), 1, 1);
        }
    }

repeat_command
    = "repeat" whitespace variable:name whitespace start:number whitespace end:number whitespace "{" lines:lines "}"
    {
        return function () {
            //console.log("Repeat var=", variable);
            for (vars[variable] = start(); vars[variable] < end(); vars[variable]++) {
                lines();
            }
        }
    }

color
    = number:number
    {
        return function () {
            let color = number();

            const unchecked = '_nocheck' in vars && vars['_nocheck'] == 1;
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
        return function () {
            let coord = number();

            //console.log("Checked", '_nocheck' in vars, vars['_nocheck'], vars['_nocheck'] == 1);

            const unchecked = '_nocheck' in vars && vars['_nocheck'] == 1;
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

