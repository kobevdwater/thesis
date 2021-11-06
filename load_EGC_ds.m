%LOAD_EGC_DS Load part of the ECG 5000 dataset and create a distance
%matrix.
function D = load_EGC_ds()
    ds = readmatrix("C:\Users\kobev\Documents\school\Thesis\ECG\ECG5000\ECG5000_TEST.txt");
    D = zeros(500);
    tic;
    for i = 1:500
        i
        if i==50
            toc;
        end
        a1 = ds(i,:);
        for j = 1:i
            a2 = ds(j,:);
            dis = prunedDTW(a1,a2,200);
            D(i,j) = dis;
            D(j,i) = dis;
        end
    end