--- lpfm_load_final.sql
--mike byrne
--loads the final lpfm tables from shape to postgres
--there are two output shape files from the arcgis; there are two because a single is larger than the 2 gig limit
--the two are the result of the union with every channel and a final intersect w/ the US

DROP TABLE if exists lpfm.lpfm_union_w2nd;

CREATE TABLE lpfm.lpfm_union_w2nd
(
  c201 numeric,
  c202 numeric,
  c203 numeric,
  c204 numeric,
  c205 numeric,
  c206 numeric,
  c207 numeric,
  c208 numeric,
  c209 numeric,
  c210 numeric,
  c211 numeric,
  c212 numeric,
  c213 numeric,
  c214 numeric,
  c215 numeric,
  c216 numeric,
  c217 numeric,
  c218 numeric,
  c219 numeric,
  c220 numeric,
  c221 numeric,
  c222 numeric,
  c223 numeric,
  c224 numeric,
  c225 numeric,
  c226 numeric,
  c227 numeric,
  c228 numeric,
  c229 numeric,
  c230 numeric,
  c231 numeric,
  c232 numeric,
  c233 numeric,
  c234 numeric,
  c235 numeric,
  c236 numeric,
  c237 numeric,
  c238 numeric,
  c239 numeric,
  c240 numeric,
  c241 numeric,
  c242 numeric,
  c243 numeric,
  c244 numeric,
  c245 numeric,
  c246 numeric,
  c247 numeric,
  c248 numeric,
  c249 numeric,
  c250 numeric,
  c251 numeric,
  c252 numeric,
  c253 numeric,
  c254 numeric,
  c255 numeric,
  c256 numeric,
  c257 numeric,
  c258 numeric,
  c259 numeric,
  c260 numeric,
  c261 numeric,
  c262 numeric,
  c263 numeric,
  c264 numeric,
  c265 numeric,
  c266 numeric,
  c267 numeric,
  c268 numeric,
  c269 numeric,
  c270 numeric,
  c271 numeric,
  c272 numeric,
  c273 numeric,
  c274 numeric,
  c275 numeric,
  c276 numeric,
  c277 numeric,
  c278 numeric,
  c279 numeric,
  c280 numeric,
  c281 numeric,
  c282 numeric,
  c283 numeric,
  c284 numeric,
  c285 numeric,
  c286 numeric,
  c287 numeric,
  c288 numeric,
  c289 numeric,
  c290 numeric,
  c291 numeric,
  c292 numeric,
  c293 numeric,
  c294 numeric,
  c295 numeric,
  c296 numeric,
  c297 numeric,
  c298 numeric,
  c299 numeric,
  c300 numeric,
  usa numeric,
  gid serial NOT NULL,
  geom geometry,
  total numeric,
  opportunity numeric,
  CONSTRAINT lpfm_union_w2nd_pkey PRIMARY KEY (gid),
  CONSTRAINT enforce_dims_geom CHECK (st_ndims(geom) = 2),
  CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 4326)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE lpfm.lpfm_union_w2nd OWNER TO postgres;

-- Index: lpfm.lpfm_geom_gist_lpfm
-- DROP INDEX lpfm.lpfm_geom_gist_lpfm;
CREATE INDEX lpfm_geom_union_w2nd_gist_lpfm
  ON lpfm.lpfm_union_w2nd
  USING gist
  (geom);

--combine the two tables
--insert lpfm.lpfm_lt_750
INSERT INTO lpfm.lpfm_union_w2nd ( 
c201, c202, C203, C204, C205, C206, C207, C208, C209, 
c210, c211, c212, C213, C214, C215, C216, C217, C218, C219, 
c220, c221, c222, C223, C224, C225, C226, C227, C228, C229, 
c230, c231, c232, C233, C234, C235, C236, C237, C238, C239, 
c240, c241, c242, C243, C244, C245, C246, C247, C248, C249, 
c250, c251, c252, C253, C254, C255, C256, C257, C258, C259, 
c260, c261, c262, C263, C264, C265, C266, C267, C268, C269, 
c270, c271, c272, C273, C274, C275, C276, C277, C278, C279, 
c280, c281, c282, C283, C284, C285, C286, C287, C288, C289, 
c290, c291, c292, C293, C294, C295, C296, C297, C298, C299, c300, usa, geom 
)
select  
	lpfm_lt_750.c201, lpfm_lt_750.c202, lpfm_lt_750.C203, lpfm_lt_750.C204, lpfm_lt_750.C205, lpfm_lt_750.C206, lpfm_lt_750.C207, lpfm_lt_750.C208, lpfm_lt_750.C209, 
	lpfm_lt_750.c210, lpfm_lt_750.c211, lpfm_lt_750.c212, lpfm_lt_750.C213, lpfm_lt_750.C214, lpfm_lt_750.C215, lpfm_lt_750.C216, lpfm_lt_750.C217, lpfm_lt_750.C218, lpfm_lt_750.C219, 
	lpfm_lt_750.c220, lpfm_lt_750.c221, lpfm_lt_750.c222, lpfm_lt_750.C223, lpfm_lt_750.C224, lpfm_lt_750.C225, lpfm_lt_750.C226, lpfm_lt_750.C227, lpfm_lt_750.C228, lpfm_lt_750.C229, 
	lpfm_lt_750.c230, lpfm_lt_750.c231, lpfm_lt_750.c232, lpfm_lt_750.C233, lpfm_lt_750.C234, lpfm_lt_750.C235, lpfm_lt_750.C236, lpfm_lt_750.C237, lpfm_lt_750.C238, lpfm_lt_750.C239, 
	lpfm_lt_750.c240, lpfm_lt_750.c241, lpfm_lt_750.c242, lpfm_lt_750.C243, lpfm_lt_750.C244, lpfm_lt_750.C245, lpfm_lt_750.C246, lpfm_lt_750.C247, lpfm_lt_750.C248, lpfm_lt_750.C249, 
	lpfm_lt_750.c250, lpfm_lt_750.c251, lpfm_lt_750.c252, lpfm_lt_750.C253, lpfm_lt_750.C254, lpfm_lt_750.C255, lpfm_lt_750.C256, lpfm_lt_750.C257, lpfm_lt_750.C258, lpfm_lt_750.C259, 
	lpfm_lt_750.c260, lpfm_lt_750.c261, lpfm_lt_750.c262, lpfm_lt_750.C263, lpfm_lt_750.C264, lpfm_lt_750.C265, lpfm_lt_750.C266, lpfm_lt_750.C267, lpfm_lt_750.C268, lpfm_lt_750.C269, 
	lpfm_lt_750.c270, lpfm_lt_750.c271, lpfm_lt_750.c272, lpfm_lt_750.C273, lpfm_lt_750.C274, lpfm_lt_750.C275, lpfm_lt_750.C276, lpfm_lt_750.C277, lpfm_lt_750.C278, lpfm_lt_750.C279, 
	lpfm_lt_750.c280, lpfm_lt_750.c281, lpfm_lt_750.c282, lpfm_lt_750.C283, lpfm_lt_750.C284, lpfm_lt_750.C285, lpfm_lt_750.C286, lpfm_lt_750.C287, lpfm_lt_750.C288, lpfm_lt_750.C289, 
	lpfm_lt_750.c290, lpfm_lt_750.c291, lpfm_lt_750.c292, lpfm_lt_750.C293, lpfm_lt_750.C294, lpfm_lt_750.C295, lpfm_lt_750.C296, lpfm_lt_750.C297, lpfm_lt_750.C298, lpfm_lt_750.C299, lpfm_lt_750.c300, 
	lpfm_lt_750.usa, lpfm_lt_750.geom 
from lpfm.lpfm_lt_750;

--insert lpfm.lpfm_gt_750
INSERT INTO lpfm.lpfm_union_w2nd ( 
c201, c202, C203, C204, C205, C206, C207, C208, C209, 
c210, c211, c212, C213, C214, C215, C216, C217, C218, C219, 
c220, c221, c222, C223, C224, C225, C226, C227, C228, C229, 
c230, c231, c232, C233, C234, C235, C236, C237, C238, C239, 
c240, c241, c242, C243, C244, C245, C246, C247, C248, C249, 
c250, c251, c252, C253, C254, C255, C256, C257, C258, C259, 
c260, c261, c262, C263, C264, C265, C266, C267, C268, C269, 
c270, c271, c272, C273, C274, C275, C276, C277, C278, C279, 
c280, c281, c282, C283, C284, C285, C286, C287, C288, C289, 
c290, c291, c292, C293, C294, C295, C296, C297, C298, C299, c300, usa, geom 
)
select  
	lpfm_gt_750.c201, lpfm_gt_750.c202, lpfm_gt_750.C203, lpfm_gt_750.C204, lpfm_gt_750.C205, lpfm_gt_750.C206, lpfm_gt_750.C207, lpfm_gt_750.C208, lpfm_gt_750.C209, 
	lpfm_gt_750.c210, lpfm_gt_750.c211, lpfm_gt_750.c212, lpfm_gt_750.C213, lpfm_gt_750.C214, lpfm_gt_750.C215, lpfm_gt_750.C216, lpfm_gt_750.C217, lpfm_gt_750.C218, lpfm_gt_750.C219, 
	lpfm_gt_750.c220, lpfm_gt_750.c221, lpfm_gt_750.c222, lpfm_gt_750.C223, lpfm_gt_750.C224, lpfm_gt_750.C225, lpfm_gt_750.C226, lpfm_gt_750.C227, lpfm_gt_750.C228, lpfm_gt_750.C229, 
	lpfm_gt_750.c230, lpfm_gt_750.c231, lpfm_gt_750.c232, lpfm_gt_750.C233, lpfm_gt_750.C234, lpfm_gt_750.C235, lpfm_gt_750.C236, lpfm_gt_750.C237, lpfm_gt_750.C238, lpfm_gt_750.C239, 
	lpfm_gt_750.c240, lpfm_gt_750.c241, lpfm_gt_750.c242, lpfm_gt_750.C243, lpfm_gt_750.C244, lpfm_gt_750.C245, lpfm_gt_750.C246, lpfm_gt_750.C247, lpfm_gt_750.C248, lpfm_gt_750.C249, 
	lpfm_gt_750.c250, lpfm_gt_750.c251, lpfm_gt_750.c252, lpfm_gt_750.C253, lpfm_gt_750.C254, lpfm_gt_750.C255, lpfm_gt_750.C256, lpfm_gt_750.C257, lpfm_gt_750.C258, lpfm_gt_750.C259, 
	lpfm_gt_750.c260, lpfm_gt_750.c261, lpfm_gt_750.c262, lpfm_gt_750.C263, lpfm_gt_750.C264, lpfm_gt_750.C265, lpfm_gt_750.C266, lpfm_gt_750.C267, lpfm_gt_750.C268, lpfm_gt_750.C269, 
	lpfm_gt_750.c270, lpfm_gt_750.c271, lpfm_gt_750.c272, lpfm_gt_750.C273, lpfm_gt_750.C274, lpfm_gt_750.C275, lpfm_gt_750.C276, lpfm_gt_750.C277, lpfm_gt_750.C278, lpfm_gt_750.C279, 
	lpfm_gt_750.c280, lpfm_gt_750.c281, lpfm_gt_750.c282, lpfm_gt_750.C283, lpfm_gt_750.C284, lpfm_gt_750.C285, lpfm_gt_750.C286, lpfm_gt_750.C287, lpfm_gt_750.C288, lpfm_gt_750.C289, 
	lpfm_gt_750.c290, lpfm_gt_750.c291, lpfm_gt_750.c292, lpfm_gt_750.C293, lpfm_gt_750.C294, lpfm_gt_750.C295, lpfm_gt_750.C296, lpfm_gt_750.C297, lpfm_gt_750.C298, lpfm_gt_750.C299, lpfm_gt_750.c300, 
	lpfm_gt_750.usa, lpfm_gt_750.geom 
from lpfm.lpfm_gt_750;

--example update - select gid, c201, c202, total from lpfm.lpfm_union where gid < 10;
--update the total column
update lpfm.lpfm_union_w2nd set total = 
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
update lpfm.lpfm_union_w2nd set opportunity = 100 - total;

commit;