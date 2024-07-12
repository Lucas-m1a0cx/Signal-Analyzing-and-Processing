function dtw_distance = dtw_m(matrix1, matrix2)
    % matrix1: 第一个矩阵，大小为 M x N
    % matrix2: 第二个矩阵，大小为 P x N

    % dtw_distance: DTW距离

    [M, N] = size(matrix1);
    [P, ~] = size(matrix2);

    % 计算距离矩阵
    distance_matrix = zeros(M, P);
    for i = 1:M
        for j = 1:P
            distance_matrix(i, j) = norm(matrix1(i, :) - matrix2(j, :));
        end
    end

    % 初始化累积距离矩阵
    acc_distance = zeros(M, P);
    acc_distance(1, 1) = distance_matrix(1, 1);

    % 计算累积距离矩阵
    for i = 2:M
        acc_distance(i, 1) = distance_matrix(i, 1) + acc_distance(i-1, 1);
    end
    for j = 2:P
        acc_distance(1, j) = distance_matrix(1, j) + acc_distance(1, j-1);
    end
    for i = 2:M
        for j = 2:P
            acc_distance(i, j) = distance_matrix(i, j) + min([acc_distance(i-1, j), acc_distance(i, j-1), acc_distance(i-1, j-1)]);
        end
    end

    dtw_distance = acc_distance(M, P);
end