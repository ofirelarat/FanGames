
var context, canvas;
var canvasWidth = 600;
var canvasHeigth = 600;
var turn = 1;

window.onload = function(){
    canvas = document.getElementById("canvas");
    context = canvas.getContext("2d");

    draw();
}

var moves = [];

window.onclick = function(e){
    if(e.pageX < canvasWidth && e.pageY < canvasHeigth && document.getElementById("endGameBlock").style.visibility != "visible"){
        var contextX = Math.floor(e.pageX / (canvasWidth/3));
        var contextY = Math.floor(e.pageY / (canvasHeigth/3));
        
        var alreadyClicked = false;

        for(i in moves){
            if(moves[i][0] == contextX && moves[i][1] == contextY){
                alreadyClicked = true;
            }
        }

        if(alreadyClicked == false){
            moves[moves.length] =  [contextX,contextY,turn];
            draw();
            checkWin();
            turn = turn*(-1);
        }
    }
}

function checkWin(){
    for(i in moves){
        var vertical = 0;
        var horizontal = 0;
        var leftDiag = 0;
        var rightDiag = 0;

        for(j in moves){
            if(moves[j][2] == moves[i][2]){
                if((moves[j][0] == moves[i][0]+1 || moves[j][0] == moves[i][0]-1) && moves[j][1] == moves[i][1]){
                    horizontal++;
                }
                if((moves[j][1] == moves[i][1]+1 || moves[j][1] == moves[i][1]-1) && moves[j][0] == moves[i][0]){
                    vertical++;
                }
                if((moves[j][0] == moves[i][0]-1 && moves[j][1] == moves[i][1]-1) || (moves[j][0] == moves[i][0]+1 && moves[j][1] == moves[i][1]+1)){
                    leftDiag++;
                }
                 if((moves[j][0] == moves[i][0]-1 && moves[j][1] == moves[i][1]+1) || (moves[j][0] == moves[i][0]+1 && moves[j][1] == moves[i][1]-1)){
                    rightDiag++;
                }
            }

            if(horizontal == 2 || vertical == 2 || leftDiag == 2 || rightDiag == 2){
                document.getElementById("endGameBlock").style.visibility = "visible";
                document.getElementById("winnerTitle").innerHTML = "You Win!";
            }
        }
    }
    
    if(moves.length == 9 && document.getElementById("endGameBlock").style.visibility != "visible"){
            document.getElementById("endGameBlock").style.visibility = "visible";
            document.getElementById("winnerTitle").innerHTML = "It's a tie!";
    }
}

function remuch(){
    moves = [];
    draw();

    document.getElementById("endGameBlock").style.visibility = "hidden";
}

var backgroundImg = new Image();
var xImg = new Image();
var oImg = new Image();
backgroundImg.src = "images/ttt_bg.png";
xImg.src = "images/ttt_x.png";
oImg.src = "images/ttt_o.png"; 

function draw(){
    context.clearRect(0,0,canvasWidth,canvasHeigth);

    context.drawImage(backgroundImg,0,0);

    for(i in moves){
        var moveXPlace = Math.floor(moves[i][0]*(canvasWidth/3)) + 35;
        var moveOPlace = Math.floor(moves[i][1]*(canvasHeigth/3)) + 35;
        if(moves[i][2] == 1){
            context.drawImage(xImg,moveXPlace,moveOPlace);
        }
        else{
            context.drawImage(oImg,moveXPlace,moveOPlace);
        }
    }
}

