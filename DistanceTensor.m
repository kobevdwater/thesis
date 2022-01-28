%DISTANCETENSOR class representing a distance tensor. Using this class
%   allows us to calculate values when they are needed.
classdef DistanceTensor < handle
    properties
        Sz
        Data
        Iset
        Slice
        Accesed
    end
    methods
        
        function obj = DistanceTensor()
            obj.Sz = [100,100,75];
            obj.Data = NaN(obj.Sz(1),obj.Sz(2),obj.Sz(3));
            obj.Accesed = zeros(obj.Sz(1),obj.Sz(2),obj.Sz(3));

            for i = 1:obj.Sz(1)
                obj.Data(i,i,:) = 0;
            end
            obj.Iset(obj.Sz(1)).data = [];
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
            for i = [I J]
                if isempty(obj.Iset(i).data)
                    item = sprintf('/skeleton_%d/block0_values',i);
                    obj.Iset(i).data = h5read('amie/amie-kinect-data.hdf',item);
                end
            end
            data = zeros(length(I),length(J),length(K));
            for i=1:length(I)
                for j=1:length(J)
                    for k=1:length(K)
                        if isnan(obj.Data(I(i),J(j),K(k)))
                            dis = prunedDTW(normalize(obj.Iset(I(i)).data(K(k),1:300)),normalize(obj.Iset(J(j)).data(K(k),1:300)));
                            data(i,j,k) = dis;
                            obj.Data(I(i),J(j),K(k)) = dis;
                            obj.Data(J(j),I(i),K(k)) = dis;

                        else
                            data(i,j,k) = obj.Data(I(i),J(j),K(k));
                        end

                    end
                end
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