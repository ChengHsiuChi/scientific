function [beginTime, endTime, pitch]=Pv2NoteByDP(pv)
segment=SegmentFind(pv.pitch);
for l = 1:length(segment)
    segmentPv = pv.pitch(segment(l).begin:segment(l).end);
    n = ceil(length(segment(l))/2);
    errorTable = zeros(length(segmentPv), n);
    pathStart = zeros(length(segmentPv), n);
    for i = 1:length(segmentPv)
        errorTable(i,1) = sum(abs(segmentPv(1:i)-median(segmentPv(1:i))));
        pathStart(i,1) = 1;
    end
    note = [];
    if n==1
        note(1).index = 1:length(segmentPv);
        segment(l).noteNum = 1;
    else
        for j=2:n
            errorTable(j,j) = 0;
            pathStart(j,j) = j;
            pvInNote2 = segmentPv(j);
            for i=j+1:length(segmentPv)
                pvInNote2=[pvInNote2, segmentPv(i)];	
                pitchError=sum(abs(pvInNote2-median(pvInNote2)));
                [errorTable(i,j),arrow] = min([errorTable(i-1,j-1),pitchError]);
                if arrow == 1 % 45 degree
                    pathStart(i,j) = i;
                elseif arrow == 2 % 0 degree
                    pathStart(i,j) = pathStart(i-1,j);
                end
            end
        end
        [minError, notenum] = min(errorTable(end,:));
        segment(l).noteNum = notenum;
        stop = length(segmentPv);
        start = stop;
        for k = notenum:-1:1
            start = pathStart(stop,k);
            note(k).index = start:stop;
            stop = start-1;
        end
    end
    segment(l).note=note;
end

for j = 1:length(segment)
    for k = 1:segment(j).noteNum
        segment(j).note(k).index = segment(j).note(k).index+segment(j).begin-1;
        segment(j).note(k).pitch = round(median(pv.pitch(segment(j).note(k).index)));
        segment(j).note(k).beginTime = pv.time(segment(j).note(k).index(1));
        segment(j).note(k).endTime = pv.time(segment(j).note(k).index(end));
    end
end
note=[segment.note];
beginTime=[note.beginTime];
endTime=[note.endTime];
pitch = [note.pitch];
