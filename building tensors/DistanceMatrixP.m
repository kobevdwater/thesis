%DISTANCEMATRIXP class representing a distance matrix. Using this class
%   allows us to calculate values when they are needed. Uses a parfor loop
%   to speed up calculation. Requires parallel computing toolbox.
% Depricated: to big to fit in memory.
classdef DistanceMatrixP < handle
    properties
        Sz
        Data
        Iset
        Slice
        Accesed
    end
    methods
        
        %The matrix is internaly represented as a 4D Tensor with 
        % size [a,a,b,b]. The output will be a matrix of size [a*b,a*b]
        function obj = DistanceMatrixP()
            obj.Sz = [180,180,20,20];
            obj.Data = NaN(obj.Sz(1),obj.Sz(2),obj.Sz(3),obj.Sz(4));
            obj.Accesed = zeros(obj.Sz(1),obj.Sz(2),obj.Sz(3),obj.Sz(4));
            for i = 1:obj.Sz(1)
                for j = 1:obj.Sz(3)
                    obj.Data(i,i,j,j) = 0;
                end
            end
            obj.Iset(obj.Sz(1)).data = [];
        end

        function varargout = subsref(obj,s)
            switch s(1).type
                case '()'
                    [varargout{1:nargout}] = obj.calcData(s.subs);
                case '.'
                     [varargout{1:nargout}] = builtin('subsref',obj,s);
                otherwise
                    error('Not a valid indexing expression (yet)')
            end
        end

        function varargout = size(obj,varargin)
            [varargout{1:nargout}] = deal(obj.Sz(1)*obj.Sz(3),obj.Sz(2)*obj.Sz(4));
        end

        %Transform 2d coordinates to 4d coordinates of internal representation.
        % Given idices [a,b]
        % Result will be [i,j,k,l]
        %   where a = i*k and b = k*l
        % also works with ranges.
        function [I,J,K,L] = parseIndices(obj,indices)
            IJ = {};
            for i = 1:length(indices)
                if strcmp(indices{1,i},':')
                    IJ{i} = 1:obj.Sz(i);
                    IJ{i+2} = 1:obj.Sz(i+2);
                else
                    IJ{i} = ceil(indices{1,i}/obj.Sz(i+2));
                    IJ{i+2} = mod(indices{1,i}-1,obj.Sz(i+2))+1;
                end
            end
            I = IJ{1};J=IJ{2};K=IJ{3};L=IJ{4};
        end
        
        function data = calcData(obj,indices)
            [I,J,K,L] = obj.parseIndices(indices);
            obj.Accesed(I,J,K,L) = 1;
            %load the needed data
            for i = [I J]
                if isempty(obj.Iset(i).data)
                    item = sprintf('/skeleton_%d/block0_values',i);
                    obj.Iset(i).data = h5read('amie/amie-kinect-data.hdf',item);
                end
            end
 
            toCalc = {};
            toWrite = {};
            data = zeros(length(I),length(J),length(K),length(L));
            size(data)
            n = 0;
            m = 0;
            %Find all indices that have to be calculated. If the data has
            %been calculated before, it will be copied and not calculated
            %again.
            for i=1:length(I)
                for j=1:length(J)
                    for k=1:length(K)
                        for l=1:length(L)
                            if isnan(obj.Data(I(i),J(j),K(k),L(l)))
                                n = n+1;
                                toCalc(n).a1 = obj.Iset(I(i)).data(K(k),:);
                                toCalc(n).a2 = obj.Iset(J(j)).data(L(l),:);
                                toCalc(n).ijk = [i,j,k,l];
                                obj.Data(J(j),I(i),L(l),K(k)) = -1;
                            elseif obj.Data(I(i),J(j),K(k),L(l)) == -1
                                m=m+1;
                                toWrite(m).ijk = [i,j,k,l];
                            else
                                data(i,j,k,l) = obj.Data(I(i),J(j),K(k),L(l));
                            end
                        end
                    end
                end
            end
            %Calculate the data that has to be calculated.
            newData = zeros(n,1);
            parfor i=1:n
                dis = prunedDTW(normalize(toCalc(i).a1(1:200)),normalize(toCalc(i).a2(1:200)));
                newData(i) = dis;
            end
            %Place the newly calculated data in output structure and in the
            %internal datastructure used to remember calculated data.
            for p=1:n
                ijk = toCalc(p).ijk;
                i=ijk(1);j=ijk(2);k=ijk(3);l=ijk(4);
                data(i,j,k,l) = newData(p);
                obj.Data(I(i),J(j),K(k),L(l)) = newData(p);
                obj.Data(J(j),I(i),L(l),K(k)) = newData(p);
            end

            %Place the previously calculated data in the output structure.
            for p=1:m
                ijk = toWrite(p).ijk;
                i=ijk(1);j=ijk(2);k=ijk(3);l=ijk(4);
                data(i,j,k,l) = obj.Data(I(i),J(j),K(k),L(l));
            end
            data = tens2mat(data,[3,1],[4,2]);
        end
        
        %Check how many data elements are accessed.
        % Only the indices given will be counted. If no indices are given,
        % the whole matrix will be concidered.
        function sr = getSampleRate(obj,indices)
            if isempty(indices)
                sr = sum(obj.Accesed,'all')/(prod(obj.Sz));
            else
                [I,J,K,L] = obj.parseIndices(indices);
                totalSum = sum(obj.Accesed(I,J,K,L),'all');
                sr = totalSum/(length(I)*length(J)*length(K)*length(L));
            end
        end
        
        %Set the sampling rate to zero. 
        function zr = resetSamplingRate(obj)
            obj.Accesed = zeros(obj.Sz(1),obj.Sz(2),obj.Sz(3),obj.Sz(4));
            zr = 0;
        end
    end
end