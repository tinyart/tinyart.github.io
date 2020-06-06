import { parse, SyntaxError } from "../build/dbn";

const code = document.getElementById('code');
code.innerHTML = `paper 90
repeat i 1 5
{
  pen (i*10)
  line (i*20) 0 0 (i*20)
}`;

const output = document.getElementById('output');

const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');

function setup() {
    ctx.clearRect(0, 0, 100, 100);
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
    console.log("Code:", code.value);
    setup();

    try {
        output.innerHTML = '';
        const program = parse(code.value);
        program(ctx);
    }
    catch (e) {
        output.innerHTML = e;
    }
}

code.addEventListener('keyup', run);

run();