function [theta,thetaW,h,th,d] = shootingMethod3D(thetaguess1,thetaguess2,thetaguess1W,thetaguess2W,H,x)

% Input this: [a,b,c,d,e] = shootingMethod(10,80,-1,1,190000,5);
h = 0;
th = 0;
plotgraph = 0;
[~,~,h1,~,epsilonguess1W] = ivpSolver(0,1,1,1,thetaguess1,thetaguess1W,1,1,0);
epsilonguess1 = h1 - H;
[~,~,h2,~,epsilonguess2W] = ivpSolver(0,1,1,1,thetaguess2,thetaguess2W,1,1,0);
epsilonguess2 = h2 - H;
thetamain = thetaguess2 - ((thetaguess2 - thetaguess1)/(epsilonguess2 - epsilonguess1))*epsilonguess2;
thetamainW = thetaguess2W - ((thetaguess2W - thetaguess1W)/(epsilonguess2W - epsilonguess1W))*epsilonguess2W;
[~,~,h3,~,epsilonmainW] = ivpSolver(0,1,1,1,thetamain,thetamainW,1,1,0);
epsilonmain = h3 - H;
o1 = thetaguess1;
o2 = thetaguess2;
e1 = epsilonguess1;
e2 = epsilonguess2;
o1W = thetaguess1W;
o2W = thetaguess2W;
e1W = epsilonguess1W;
e2W = epsilonguess2W;
for n = (1:x)
    if e2 > e1
        epsilon1 = e1;
        theta1 = o1;
    else
        epsilon1 = e2;
        theta1 = o2;
    end
    if e2W > e1W
        epsilon1W = e1W;
        theta1W = o1W;
    else
        epsilon1W = e2W;
        theta1W = o2W;
    end
    
    if n == x
        plotgraph = 1;
    end

    epsilon2 = epsilonmain;
    epsilon2W = epsilonmainW;
    theta2 = thetamain;
    theta2W = thetamainW;
    thetanext = theta2 - ((theta2 - theta1)/(epsilon2 - epsilon1))*epsilon2;
    thetanextW = theta2W - ((theta2W - theta1W)/(epsilon2W - epsilon1W))*epsilon2W;
    [~,~,hnext,thnext,epsilonmainW] = ivpSolver(0,1,1,1,thetanext,thetanextW,1,1,plotgraph);
    thetamain = thetanext;
    thetamainW = thetanextW;
    epsilonmain = hnext - H;
    o1 = theta1;
    o2 = theta2;
    e1 = epsilon1;
    e2 = epsilon2;
    o1W = theta1W;
    o2W = theta2W;
    e1W = epsilon1W;
    e2W = epsilon2W;

    if n == x
        theta = thetanext;
        thetaW = thetanextW;
        h = hnext;
        th = thnext;
        d = epsilonmainW;
    end
end