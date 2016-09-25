function [iae] = iae(y1, y2)

iae = sum(abs(y1-y2));