{
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    const vars = {};
}

start
    = lines:lines
    {
        return function () {
            console.log("Run");
            ctx.clearRect(0, 0, 100, 100);
            lines();
        }
    }

lines
    = line:line "\n" lines:lines
    {
        return function () {
            line();
            lines();
        }
    }
    / line

line
    = paper_command
    / pen_command
    / line_command
    / set_command

number
    = number:[0-9]+
    {
        return parseInt(number.join(''), 10);
    }
    / "(" calculation:calculation ")"
    {
        return calculation;
    }
    / name:name
    {
        if (!vars.hasOwnProperty(name)) {
            expected("Variable not defined");
        }
        console.log("Var", name, value);
        return vars[name];
    }

calculation
    = left:additive "+" right:calculation
    {
        return left + right; 
    }
    / minuend:additive "-" subtrahend:calculation
    {
        return minuend - subtrahend;
    }
    / number

additive
    = left:number "*" right:additive
    {
        return left * right;
    }
    / dividend:number "/" divisor:additive
    {
        return dividend / divisor;
    }
    / number

whitespace
    = [ \t]*

paper_command
    = "paper" whitespace color:color
    {
        return function () {
            console.log("Paper", color);

            ctx.fillStyle = color;
            ctx.fillRect(0, 0, 100, 100);
        }
    }

pen_command
    = "pen" whitespace color:color
    {
        return function () {
            console.log("Pen", color);

            ctx.fillStyle = color;
        }
    }

line_command
    = "line" whitespace x1:coord whitespace y1:coord whitespace x2:coord whitespace y2:coord
    {
        return function () {
            console.log("Line", x1, y1, x2, y2);

            ctx.moveTo(x1, y1);
            ctx.lineTo(x2, y2);
            ctx.stroke();
        }
    }

color
    = number:number
    {
        console.log("Color", number);

        let color = parseInt(number.join(''), 10);
        if (color < 0 || color > 100) {
            expected('Color must be between 0 and 100');
        }
        color *= 2.55;
        let hex = Math.round(color).toString(16);
        if (hex.length < 2) hex = '0' + hex;

        return '#' + hex.repeat(3);
    }

coord
    = number:number
    {
        console.log("Coord", number);

        if (number < 0 || number > 100) {
            expected('Coordinate must be between 0 and 100');
        }
        return number;
    }

set_command
    = "set" whitespace name:name whitespace value:number
    {
        console.log("Set", name, value);
        vars[name] = value;
    }
    / "set" whitespace "[" whitespace coord whitespace coord whitespace "]" color

name
    = [_a-zA-Z][_a-zA-Z0-9]*