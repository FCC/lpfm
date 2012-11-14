@land: #727272;
@water: #DEEDEF;
@waterline: #4D8FB4;

Map {
  background-color: @water;
}

#countries {
  ::outline {
    line-color: #85c5d3;
    line-width: 2;
    line-join: round;
  }
}

#countries::fill {
  polygon-fill:@land;
  polygon-gamma:0.35;
  [ADM0_A3='USA'] { polygon-fill:lighten(@land, 85); }
}

#islands::fill {
  polygon-fill:@white;
}

#country-border::glow {
  [zoom>2] {
    line-color:#4D8FB4;
    line-opacity:0.2;
    line-width:1;
  }
}

#country-border {
  [zoom>2] {
    line-width:0.2;
  }
}

#state-line::glow[ADM0_A3='USA'] {
  [zoom<8] {
    line-color:#F6FAFB;
    line-opacity:0.5;
    line-width:0.8;
  }
}

#state-line[ADM0_A3='USA'] {
  [zoom<8] {  
    line-color: fadeout(#222c31, 45%); 
    line-width:0.8;
  }
} 

#coastline::glow_outer {
  [zoom<8]{
   line-color: #4D8FB4;
   line-opacity: 0.4;
   line-width: 1;
   }
}

#lake[zoom>=0][ScaleRank<=1],
#lake[zoom>=1][ScaleRank=1],
#lake[zoom>=2][ScaleRank=1],
#lake[zoom>=3][ScaleRank=1],
#lake[zoom>=4][ScaleRank=1],
#lake[zoom>=5][ScaleRank=1],
#lake[zoom>=6][ScaleRank=8],
#lake[zoom>=7][ScaleRank=9] {
  ::outline { line-color:@waterline; }
  ::fill { polygon-fill:@water; }
}
