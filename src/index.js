import { parse, SyntaxError } from "../build/dbn";

const code = document.getElementById('code');
code.innerHTML = 'paper 50';

const output = document.getElementById('output');

const canvas = document.getElementById('canvas');

let state = {
    ctx: canvas.getContext('2d'),
    timer: null,
    mousex: 0,
    mousey: 0
};

function setup() {
    if (state.timer) {
        console.log("Stopped");
        clearInterval(state.timer);
        state.timer = null;
    }

    state.ctx.clearRect(0, 0, 100, 100);
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
    setup();

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

code.addEventListener('keyup', run);
window.addEventListener('hashchange', hashchange, false);
canvas.addEventListener('mousemove', function (e) {
    const rect = canvas.getBoundingClientRect();
    const scalex = 100 / (rect.right - rect.left);
    const scaley = 100/ (rect.bottom - rect.top);
    state.mousex = Math.round((e.clientX - rect.left) * scalex);
    state.mousey = Math.round((e.clientY - rect.top) * scaley);
    //console.log("Mousemove", state.mousex, state.mousey);
}, false);

run();