{ "signal": [
  { "name": "clk", "wave": "p......|.......|" },
  { "name": "wdata_fifo_ren",  "wave": "0..10..10..10..10..", node: '...ae..f' },
  { "name": "wdata_fifo_full", "wave": "1...01..01..01.01..", node: '....b' },
  { "name": "controller_ready", "wave": "0...10..10..10.10.." , node: '....c'}
], 
 edge: [
 	' a~->b ','b->c','e+f tCCD=4'
 ]

}


{ "signal": [
  { "name": "clk", "wave": "p......|............." },
  {"name":"ba_state","wave": "4....34..34.....34...",node: '.....s.........' , "data": ["STANDBY", "WR", "STANDBY", "WR", "STANDBY", "WR", "STANDBY"]},
  { "name": "wdata_fifo_ren",  "wave": "0..10..10.....10..10.", node: 'i..ae..f..h...o' },
  { "name": "wdata_fifo_full", "wave": "1...01..01.....01..01", node: '.....' },
  { "name": "controller_ready", "wave": "0...10..10.....10..10" , node: '....cd'}
], 
 edge: [
 	' a~->c ','e+f tWL=4','c~->s','i+a tWL=4','h+o tWL=4'
 ]
}

