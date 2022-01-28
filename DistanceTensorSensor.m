%DISTANCETENSOR class representing a distance tensor. Using this class
%   allows us to calculate values when they are needed.
classdef DistanceTensorSensor < handle
    properties
        Sz
        Data
        Iset
        Slice
        Accesed
    end
    methods
        
        function obj = DistanceTensorSensor()
            obj.Sz = [75,75,180];
            obj.Data = NaN(obj.Sz(1),obj.Sz(2),obj.Sz(3));
            obj.Accesed = zeros(obj.Sz(1),obj.Sz(2),obj.Sz(3));

            for i = 1:obj.Sz(1)
                obj.Data(i,i,:) = 0;
            end
            obj.Iset(obj.Sz(3)).data = [];
            obj.Slice = NaN;
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

        function sl = setSlice(obj,i)
            if i>obj.Sz(3)
                error('Not a valid slice. The nb of the slice should be smaller that the depth of the tensor.')
            end
            obj.Slice = i;
            sl = i;
        end

        function varargout = size(this,varargin)
            [varargout{1:nargout}] = builtin('size',this.Data,varargin{:});
        end

        function [I,J,K] = parseIndices(obj,indices)
            IJK = {};
            for i = 1:length(indices)
                if strcmp(indices{1,i},':')
                    IJK{i} = [1:obj.Sz(i)];
                else
                    IJK{i} = indices{1,i};
                end
            end
            if length(indices) == 2
                if isnan(obj.Slice)
                    error('Please set the slice before operating on it.')
                end
                IJK{3} = obj.Slice;
            end
            I = IJK{1};J=IJK{2};K=IJK{3};
        end
        
        function data = calcData(obj,indices)
            [I,J,K] = obj.parseIndices(indices);
            obj.Accesed(I,J,K) = 1;
            for k = K
                if isempty(obj.Iset(k).data)
                    item = sprintf('/skeleton_%d/block0_values',k);
                    obj.Iset(k).data = h5read('amie/amie-kinect-data.hdf',item);
                end
            end
 
            toCalc = {};
            toWrite = {};
            data = zeros(length(I),length(J),length(K));
            n = 0;
            m = 0;
            for i=1:length(I)
                for j=1:length(J)
                    for k=1:length(K)
                        if isnan(obj.Data(I(i),J(j),K(k)))
                            n = n+1;
                            toCalc(n).a1 = obj.Iset(K(k)).data(I(i),:);
                            toCalc(n).a2 = obj.Iset(K(k)).data(J(j),:);
                            toCalc(n).ijk = [i,j,k];
                            obj.Data(J(j),I(i),K(k)) = -1;
                        elseif obj.Data(I(i),J(j),K(k)) == -1
                            m=m+1;
                            toWrite(m).ijk = [i,j,k];
                        else
                            data(i,j,k) = obj.Data(I(i),J(j),K(k));
                        end
                    end
                end
            end
            newData = zeros(n,1);
            parfor i=1:n
                dis = prunedDTW(normalize(toCalc(i).a1(1:200)),normalize(toCalc(i).a2(1:200)));
                newData(i) = dis;
            end
            for p=1:n
                ijk = toCalc(p).ijk;
                i=ijk(1);j=ijk(2);k=ijk(3);
                data(i,j,k) = newData(p);
                obj.Data(I(i),J(j),K(k)) = newData(p);
                obj.Data(J(j),I(i),K(k)) = newData(p);
            end
            for p=1:m
                ijk = toWrite(p).ijk;
                i=ijk(1);j=ijk(2);k=ijk(3);
                data(i,j,k) = obj.Data(I(i),J(j),K(k));
            end
        end
        
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