
mrstModule add mrst-gui spe10 incomp ad-core deckformat book
%% Molde Parameters
T           = 25*year;
[nx, ny, nz] = deal(40, 40, 15);
% dims = [20, 10, 2];
[Lx, Ly, Lz] = deal(700, 700, 100);

G = cartGrid([nx,ny,nz],[Lx, Ly Lz]);
G.nodes.coords(:,3) = G.nodes.coords(:,3)+2050;
G = computeGeometry(G);

% Setup a rock with gaussian porosity, isotropic with Carman Kozeny Perm
% rng(40);
% p = gaussianField(nx*ny, [0.2, 0.45], [3, 3], 2.5);
% K = p.^3.*(1e-5)^2./(0.81*72*(1-p).^2);
% poro = max(repmat(p, nz, 1), 0.0005); 
% K = repmat(K, nz, 1);
% rock = makeRock(G, K, poro);

% Setup a rock with porosity, perm sampled from spe10 dataset (all layers
% are identical)
% sperock = getSPE10rock((1:nx), (1:ny)+60, 1);
% p = sperock.poro; K = sperock.perm;
% poro = max(repmat(p, nz, 1), 0.0005); 
% K = repmat(K, nz, 1);
% rock = makeRock(G, K, poro);

sperock = getSPE10rock((1:nx), (1:ny)+60, (1:nz));
rock = sperock;
rock.poro = max(rock.poro,.0005);
pv = sum(poreVolume(G ,rock));
bbl = 1/6.28981;
hT = computeTrans(G,rock);
gravity reset on;
%% Setup Wells
rate = pv/((T-2));
Cellinx1 = 1+[0:nz-1]*nx*ny;
Cellinx2 = [1:nz]*nx*ny;
W = addWell([], G, rock, Cellinx1, 'Type', 'rate', ...
            'Val', -rate, 'name', 'P', 'radius', 0.1, 'Comp_i', [0 1]);
W = addWell(W, G, rock, Cellinx2, 'Type', 'rate', ...
            'Val', rate, 'name', 'I', 'radius', 0.1, 'Comp_i', [1 0]);

%% Fluid
x0 = initState(G,W,300*barsa, [0 1]);

fluid = initSimpleFluid('mu' , [  2.5,   1] .* centi*poise     , ...
                        'rho', [ 1014,700] .* kilogram/meter^3, ...
                        'n'  , [   2,   2]);

% fluid = initSimpleFluidJfunc('mu' , [  2.5,   1] .* centi*poise     , ...
%                             'rho' , [ 1014,700] .* kilogram/meter^3, ...
%                             'n'   , [   3,   2.5], ...
%                             'sr'  , [0.2, 0.15], ...
%                             'kwm' , [1, 0.85], ...
%                             'rock', rock, ...
%                             'surf_tension', 30*dyne/(centi*meter));
%%
M       = T/year * 10;
[dt,dT] = deal(zeros(M,1), T/M);
Rsols   = cell(M, 1);
wellSol = cell(M, 1);
oip     = zeros(M,1);
x       = x0;
step    = 0;
t       = 0;
for i=1:M
    step = step+1;
    t = t+dT;

    if mod(step, 10) == 0
        fprintf('\nTime step %d: Time %.0f years\n', step, convertTo(t, year));
    end

    x = incompTPFA(x, G, hT, fluid, 'wells', W);
    x = implicitTransport(x, G, dT, rock, fluid, 'wells', W);
    dt(i) = dT;
    oip(i, 1) = sum(x.s(:, 2).*poreVolume(G, rock));
    Rsols{i, 1} = x;
    wellSol{i, 1} = getWellSol(W, x, fluid);

end

%%














