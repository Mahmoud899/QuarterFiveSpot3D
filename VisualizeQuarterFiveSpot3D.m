%% Visualize Rock
figure(1);
clf(figure(1));
pargs = {'EdgeAlpha',.1,'EdgeColor','k'};
subplot(2, 2, 1);
hs2 = plotCellData(G,rock.poro(:, 1),pargs{:});
axis tight
set(hs2,'FaceAlpha',.35);
% zoom(1.4); 
set(gca,'dataasp',[2 2 1]); 
colormap jet; colorbar('horiz');
title('Porosity Distribution')

subplot(2, 2, 2);
hs2 = plotCellData(G, convertTo(rock.perm(:, 1), milli*darcy), pargs{:});
axis tight;
set(hs2, 'FaceAlpha', 0.35);
set(gca,'dataasp',[2 2 1]); 
colormap jet; colorbar('horiz');
title('Permeability Distribution,Kx mD');

subplot(2, 2, 3);
hs2 = plotCellData(G, convertTo(rock.perm(:, 2), milli*darcy), pargs{:});
axis tight;
set(hs2, 'FaceAlpha', 0.35);
set(gca,'dataasp',[2 2 1]); 
colormap jet; colorbar('horiz');
title('Permeability Distribution,Ky mD');

subplot(2, 2, 4);
hs2 = plotCellData(G, convertTo(rock.perm(:, 3), milli*darcy), pargs{:});
axis tight;
set(hs2, 'FaceAlpha', 0.35);
set(gca,'dataasp',[2 2 1]); 
colormap jet; colorbar('horiz');
title('Permeability Distribution,Kz mD');

%%
clf(figure(1));
pargs = {'EdgeAlpha',.1,'EdgeColor','k'};

hs = plotCellData(G, convertTo(rock.perm(:, 3), milli*darcy), pargs{:});
axis tight
set(hs,'FaceAlpha',.35);
% zoom(1.4); 
set(gca,'dataasp',[2 2 1]); 
colormap jet; colorbar('horiz');
title('Permeability Distribution,Kz mD');
view(3)
%% Visualize Wells
figure(2); clf(figure(2));
plotWell(G, W);
plotGrid(G, 'facecolor', 'none', 'edgealpha', 0.2);
view(3), axis tight;
set(gca,'dataasp',[2 2 1]);

%% Dynamic Picture
figure(3);
clf(figure(3));
plotGrid(G, 'facecolor', 'none', pargs{:})
plotWell(G, W);
view(3), axis tight;
set(gca,'dataasp',[2 2 1]);
colormap(flipud(winter));
% colormap(flipud(.5*jet(10)+.5*ones(10,3)));
% gif_name = 'test.gif';
for j = 1:M
    delete(hs);
    sol = Rsols{j};
    hs = plotCellData(G, sol.s(:, 1), (sol.s(:, 1) > 0.01), pargs{:});
    title(sprintf('%0.2f years', convertTo(j/M * T, year)))
%     pause(0.05);

    drawnow
%     make_gif(gcf, j, gif_name);

end
%%
figure(3);
clf(figure(3));
plotGrid(G, 'facecolor', 'none', pargs{:})
plotWell(G, W);
view(3), axis tight;
set(gca,'dataasp',[2 2 1]);
colormap(flipud(winter));
% colormap(flipud(.5*jet(10)+.5*ones(10,3)));
gif_name = 'test.gif';
j = 97;
sol = Rsols{j};
hs = plotCellData(G, sol.s(:, 1), (sol.s(:, 1) > 0.01), pargs{:});
title(sprintf('%0.2f years: Water Breakthrough', convertTo(j/M * T, year)))

%%
cval = linspace(0,1,11); cval=.5*cval(1:end-1)+.5*cval(2:end);
lc = @(l) 1+(l-1)*nx*ny:l*nx*ny;
plotLayerData = @(x, l) ...
    contourf(reshape(G.cells.centroids(lc(l), 1), [nx, ny, 1]), ...
             reshape(G.cells.centroids(lc(l), 2), [nx, ny, 1]), ...
             reshape(x.s(lc(l), 1), [nx, ny, 1]), cval);


figure(5); clf(figure(5));
colormap(flipud(.5*jet(10)+.5*ones(10,3)));
layer = [3 6 9 12 15];
intervals = [50 150 200 250];
for i = 1:numel(intervals)
    for j = 1:numel(layer)
    subplot(numel(layer), numel(intervals), i+(j-1)*numel(intervals));
    plotLayerData(Rsols{intervals(i)}, layer(j));
    axis equal; axis([0 Lx 0 Ly]);
    set(gca,'XTick',[],'YTick',[]);
    title(sprintf('%0.0f years\n layer %d', convertTo(intervals(i)/M * T, year), layer(j)))
    end
end


%%


%% Plot a specific Layer
figure(6); clf(figure(6));
colormap(flipud(.5*jet(10)+.5*ones(10,3)));

plotLayerData(Rsols{97}, 5);
axis equal; axis([0 Lx 0 Ly]);
set(gca,'XTick',[],'YTick',[]);


%% Well Solutions
plotWellSols(wellSol, cumsum(dt));

%%
s = linspace(0, 1, 20);
kr = fluid.relperm(s');
figure(7); clf(figure(7));
plot(s,kr(:,1),'-s',s,kr(:,2),'-o');
legend('Sw', 'So')

%%
mu = fluid.properties();
fw = (kr(:, 1)/mu(1)) ./( kr(:, 1)/mu(1) + kr(:, 2)/mu(2));
figure(8); clf(figure(8));
plot(s, fw);
title('Fractional Flow Function');
