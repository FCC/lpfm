--combine the two tables
INSERT INTO lpfm.lpfm_union ( 
c201, c202, C203, C204, C205, C206, C207, C208, C209, 
c210, c211, c212, C213, C214, C215, C216, C217, C218, C219, 
c220, c221, c222, C223, C224, C225, C226, C227, C228, C229, 
c230, c231, c232, C233, C234, C235, C236, C237, C238, C239, 
c240, c241, c242, C243, C244, C245, C246, C247, C248, C249, 
c250, c251, c252, C253, C254, C255, C256, C257, C258, C259, 
c260, c261, c262, C263, C264, C265, C266, C267, C268, C269, 
c270, c271, c272, C273, C274, C275, C276, C277, C278, C279, 
c280, c281, c282, C283, C284, C285, C286, C287, C288, C289, 
c290, c291, c292, C293, C294, C295, C296, C297, C298, C299, c300,
shape_leng, shape_area, geom 
)
select  
	lpfm_gt750.c201, lpfm_gt750.c202, lpfm_gt750.C203, lpfm_gt750.C204, lpfm_gt750.C205, lpfm_gt750.C206, lpfm_gt750.C207, lpfm_gt750.C208, lpfm_gt750.C209, 
	lpfm_gt750.c210, lpfm_gt750.c211, lpfm_gt750.c212, lpfm_gt750.C213, lpfm_gt750.C214, lpfm_gt750.C215, lpfm_gt750.C216, lpfm_gt750.C217, lpfm_gt750.C218, lpfm_gt750.C219, 
	lpfm_gt750.c220, lpfm_gt750.c221, lpfm_gt750.c222, lpfm_gt750.C223, lpfm_gt750.C224, lpfm_gt750.C225, lpfm_gt750.C226, lpfm_gt750.C227, lpfm_gt750.C228, lpfm_gt750.C229, 
	lpfm_gt750.c230, lpfm_gt750.c231, lpfm_gt750.c232, lpfm_gt750.C233, lpfm_gt750.C234, lpfm_gt750.C235, lpfm_gt750.C236, lpfm_gt750.C237, lpfm_gt750.C238, lpfm_gt750.C239, 
	lpfm_gt750.c240, lpfm_gt750.c241, lpfm_gt750.c242, lpfm_gt750.C243, lpfm_gt750.C244, lpfm_gt750.C245, lpfm_gt750.C246, lpfm_gt750.C247, lpfm_gt750.C248, lpfm_gt750.C249, 
	lpfm_gt750.c250, lpfm_gt750.c251, lpfm_gt750.c252, lpfm_gt750.C253, lpfm_gt750.C254, lpfm_gt750.C255, lpfm_gt750.C256, lpfm_gt750.C257, lpfm_gt750.C258, lpfm_gt750.C259, 
	lpfm_gt750.c260, lpfm_gt750.c261, lpfm_gt750.c262, lpfm_gt750.C263, lpfm_gt750.C264, lpfm_gt750.C265, lpfm_gt750.C266, lpfm_gt750.C267, lpfm_gt750.C268, lpfm_gt750.C269, 
	lpfm_gt750.c270, lpfm_gt750.c271, lpfm_gt750.c272, lpfm_gt750.C273, lpfm_gt750.C274, lpfm_gt750.C275, lpfm_gt750.C276, lpfm_gt750.C277, lpfm_gt750.C278, lpfm_gt750.C279, 
	lpfm_gt750.c280, lpfm_gt750.c281, lpfm_gt750.c282, lpfm_gt750.C283, lpfm_gt750.C284, lpfm_gt750.C285, lpfm_gt750.C286, lpfm_gt750.C287, lpfm_gt750.C288, lpfm_gt750.C289, 
	lpfm_gt750.c290, lpfm_gt750.c291, lpfm_gt750.c292, lpfm_gt750.C293, lpfm_gt750.C294, lpfm_gt750.C295, lpfm_gt750.C296, lpfm_gt750.C297, lpfm_gt750.C298, lpfm_gt750.C299, lpfm_gt750.c300, 
	lpfm_gt750.shape_leng, lpfm_gt750.shape_area, lpfm_gt750.geom 
from lpfm.lpfm_gt750;

--add the total column on to the lpfm.lpfm_union table
alter table lpfm.lpfm_union add column total numeric;

--example update - select gid, c201, c202, total from lpfm.lpfm_union where gid < 10;
--update the total column
update lpfm.lpfm_union set total = 
	c201 +  c202 +  C203 +  C204 +  C205 +  C206 +  C207 +  C208 +  C209 +  
	c210 +  c211 +  c212 +  C213 +  C214 +  C215 +  C216 +  C217 +  C218 +  C219 +  
	c220 +  c221 +  c222 +  C223 +  C224 +  C225 +  C226 +  C227 +  C228 +  C229 +  
	c230 +  c231 +  c232 +  C233 +  C234 +  C235 +  C236 +  C237 +  C238 +  C239 +  
	c240 +  c241 +  c242 +  C243 +  C244 +  C245 +  C246 +  C247 +  C248 +  C249 +  
	c250 +  c251 +  c252 +  C253 +  C254 +  C255 +  C256 +  C257 +  C258 +  C259 +  
	c260 +  c261 +  c262 +  C263 +  C264 +  C265 +  C266 +  C267 +  C268 +  C269 +  
	c270 +  c271 +  c272 +  C273 +  C274 +  C275 +  C276 +  C277 +  C278 +  C279 +  
	c280 +  c281 +  c282 +  C283 +  C284 +  C285 +  C286 +  C287 +  C288 +  C289 +  
	c290 +  c291 +  c292 +  C293 +  C294 +  C295 +  C296 +  C297 +  C298 +  C299 +  c300;

select total, count(*) from lpfm.lpfm_union group by total order by total;

