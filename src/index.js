import { parse, SyntaxError } from "../build/dbn";

const scale = 5;
const code = document.getElementById('code');
code.innerHTML = 'paper 50';

const output = document.getElementById('output');
const canvas = document.getElementById('canvas');

let state = {
    ctx: canvas.getContext('2d'),
    timer: null,
    mousex: 0,
    mousey: 0,
    paper: function (color) {
        console.log("Paper", color);
        state.ctx.fillStyle = color;
        state.ctx.fillRect(0, 0, 100 * scale, 100 * scale);
    },
    pen: function (color) {
        //console.log("Pen", color());
        state.ctx.strokeStyle = color;
    },
    line: function (x1, y1, x2, y2) {
        //console.log("Line", x1(), y1(), x2(), y2());
        state.ctx.lineWidth = scale;
        state.ctx.moveTo(x1 * scale, y1 * scale);
        state.ctx.lineTo(x2 * scale, y2 * scale);
        state.ctx.stroke();
    },
    dot: function (x, y, color) {
        //console.log("Dot", x(), y(), color());
        state.ctx.fillStyle = color;
        state.ctx.fillRect(x * scale, y * scale, 1 * scale, 1 * scale);
    },
    getdot: function (x, y) {
        const data = state.ctx.getImageData(x, y, 1, 1).data;
        // data.0..2 is r/g/b. As we are only dealing with gray values, one channel suffices
        return Math.round(data[0] / 2.55);
    }
};

function setup() {
    if (state.timer) {
        console.log("Stopped");
        clearInterval(state.timer);
        state.timer = null;
    }

    //console.log("SETUP", canvas.width, canvas.height);
    state.ctx.clearRect(0, 0, canvas.width, canvas.height);
    //state.ctx.fillStyle = '#fff';
    //state.ctx.fillRect(0, 0, canvas.width, canvas.height);
/*
    ctx.font = "8px Arial";
    ctx.strokeStyle = "#DDD";
    
    for (let i = 10; i < 100; i += 10) {
        ctx.moveTo(0, i);
        ctx.lineTo(4, i);
        ctx.stroke();
    
        ctx.moveTo(i, 0);
        ctx.lineTo(i, 4);
        ctx.stroke();

        if (i % 20 == 0) {
            ctx.strokeText(i.toString(), 5, i+2); 
            ctx.strokeText(i.toString(), i-4, 11); 
        }
    }
*/
}

function run() {
    //console.log("Code:", code.value);
    try {
        output.innerHTML = '';
        const program = parse(code.value);
        program(state);
    }
    catch (e) {
        if (e.name == 'SyntaxError') {
            output.innerHTML = `${e.location.end.line}:${e.location.end.column}: ${e.message}`;
        }
        else {
            output.innerHTML = e;
        }
    }
}

function hashchange() {
    setup();

    const url = location.hash.substr(1);
    if (url.length == 0) {
        console.log("Clear");
        code.value = '';
        run();
    }
    else
    if (url.startsWith('https:')) {
        console.log("Fetch:", url);
        fetch('https://cors-anywhere.herokuapp.com/' + url)
            .then(response => response.text())
            .then(data => {
                console.log("Code:", data);
                code.value = data;
                run();
            });
    }
    else {
        console.log("Code:", url);
        code.value = decodeURI(url);
        run();
    }
}

code.addEventListener('keyup', function () {
    setup();
    run();
}, false);
window.addEventListener('hashchange', hashchange, false);
canvas.addEventListener('mousemove', function (e) {
    const rect = canvas.getBoundingClientRect();
    const scalex = 100 / (rect.right - rect.left);
    const scaley = 100/ (rect.bottom - rect.top);
    state.mousex = Math.round((e.clientX - rect.left) * scalex);
    state.mousey = Math.round((e.clientY - rect.top) * scaley);
    //console.log("Mousemove", state.mousex, state.mousey);
}, false);

setup();
run();