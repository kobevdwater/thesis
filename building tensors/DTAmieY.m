%DTAmieY class representing a 3D distance tensor of the Amie dataset.
%Y(i,j,k) = distance between persons i and j based on sensor k.
%The data in the tensor can be accesed via normal indexing. 
%   e.g. Y(:,1,1) will result in a fiber.
%The percentage of the elements that are calculated can be calculated via 
%   Y.getSampleRate()
%   Indexing can be used to find the samplerate of that part of the tensor.
%   e.g. Y.getSampleRate(:,:,1) will give the sampling in the first slice.
classdef DTAmieY < handle
    properties
        Sz
        Data
        Iset
        Slice
        Accesed
        indexset
        amieLoc
    end
    methods
        
        function obj = DTAmieY(amieLoc)
            obj.Sz = [180,180,75];
            obj.Data = NaN(obj.Sz);
            obj.Accesed = zeros(obj.Sz);
            obj.amieLoc = amieLoc;
            for i = 1:obj.Sz(1)
                obj.Data(i,i,:) = 0;
            end
            obj.Iset(obj.Sz(1)).data = [];
            obj.indexset = 1:185; 
            %Removing bad data: containing less than 8 repetitions.
            obj.indexset(152) = []; %6
            obj.indexset(151) = []; %1
            obj.indexset(71) = []; %6
            obj.indexset(36) = []; %6
            obj.indexset(7) = [];    
        end

        function sref = subsref(obj,s)
            switch s(1).type
                case '()'
                    sref = obj.calcData(s.subs);
                case '.'
                     sref = builtin('subsref',obj,s);
                otherwise
                    error('Not a valid indexing expression (yet)')
            end
        end

        function varargout = size(this,varargin)
            [varargout{1:nargout}] = builtin('size',this.Data,varargin{:});
        end

        %Transform the indices given in to a form that can be used to
        %calculate data.
        function [I,J,K] = parseIndices(obj,indices)
            IJK = {};
            for i = 1:length(indices)
                if strcmp(indices{1,i},':')
                    IJK{i} = [1:obj.Sz(i)];
                else
                    IJK{i} = indices{1,i};
                end
            end
            I = IJK{1};J=IJK{2};K=IJK{3};
        end
        
        function data = calcData(obj,indices)
            [I,J,K] = obj.parseIndices(indices);
            obj.Accesed(I,J,K) = 1;
            %load the needed data
            for i = [I J]
                if isempty(obj.Iset(i).data)
                    item = sprintf('/skeleton_%d/block0_values',obj.indexset(i));
                    obj.Iset(i).data = h5read(obj.amieLoc+"amie-kinect-data.hdf",item);
                end
            end
 
            toCalc = {};
            toWrite = {};
            data = zeros(length(I),length(J),length(K));
            n = 0;
            m = 0;
            %Find all indices that have to be calculated. If the data has
            %been calculated before, it will be copied and not calculated
            %again.
            for i=1:length(I)
                for j=1:length(J)
                    for k=1:length(K)
                        if isnan(obj.Data(I(i),J(j),K(k)))
                            %element has to be calculated.
                            n = n+1;
                            toCalc(n).a1 = obj.Iset(I(i)).data(K(k),:);
                            toCalc(n).a2 = obj.Iset(J(j)).data(K(k),:);
                            toCalc(n).ijk = [i,j,k];
                            obj.Data(J(j),I(i),K(k)) = -1;
                        elseif obj.Data(I(i),J(j),K(k)) == -1
                            %element is not calculated yet, but the
                            %symetric ellement will be calculated.
                            m=m+1;
                            toWrite(m).ijk = [i,j,k];
                        else
                            data(i,j,k) = obj.Data(I(i),J(j),K(k));
                        end
                    end
                end
            end
            %Calculate the data that has to be calculated.
            newData = zeros(n,1);
            parfor i=1:n
                a1 = toCalc(i).a1(1:4:end);
                a1 = normalize(a1);
                a2 = toCalc(i).a2(1:4:end);
                a2 = normalize(a2);
                dis = dtw(a1,a2);
                newData(i) = dis;
            end
            %Place the newly calculated data in output structure and in the
            %internal datastructure used to remember calculated data.
            for p=1:n
                ijk = toCalc(p).ijk;
                i=ijk(1);j=ijk(2);k=ijk(3);
                data(i,j,k) = newData(p);
                obj.Data(I(i),J(j),K(k)) = newData(p);
                obj.Data(J(j),I(i),K(k)) = newData(p);
            end
            %Place the previously calculated data in the output structure.
            for p=1:m
                ijk = toWrite(p).ijk;
                i=ijk(1);j=ijk(2);k=ijk(3);
                data(i,j,k) = obj.Data(I(i),J(j),K(k));
            end
        end
        
        %Check how many data elements are accessed.
        % Only the indices given will be counted. If no indices are given,
        % the whole matrix will be concidered.
        function sr = getSampleRate(obj,varargin)
            if isempty(varargin)
                sr = sum(obj.Accesed,'all')/(prod(obj.Sz));
            else
                [I,J,K] = obj.parseIndices(varargin);
                totalSum = sum(obj.Accesed(I,J,K),'all');
                sr = totalSum/(length(I)*length(J)*length(K));
            end
        end
        
        function zr = resetSamplingRate(obj)
            obj.Accesed = zeros(obj.Sz(1),obj.Sz(2),obj.Sz(3));
            zr = 0;
        end
    end
end