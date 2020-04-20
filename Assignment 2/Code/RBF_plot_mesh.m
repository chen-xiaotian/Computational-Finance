function [] = RBF_plot_mesh(X, Y, Z)
    figure;
    F = TriScatteredInterp(X, Y, Z);
    rx = (max(X) - min(X)) / 30;
    ry = (max(Y) - min(Y)) / 30;
    [qx,qy] = meshgrid(min(X):rx:max(X), min(Y):ry:max(Y));
    qz = F(qx,qy);
    surf(qx,qy,qz);
end
