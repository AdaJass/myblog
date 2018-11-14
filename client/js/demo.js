/* GitHub: https://github.com/peet86/Ratyli */

$(function() {
	// Default
	$("#demo1 .ratyli").ratyli();

	// Configure with Datasets
	$("#demo2 .ratyli").ratyli();

	// Configure with JS
	$("#demo3 .ratyli").ratyli({rate:3,max:7});

	// Custom Signs
	$("#demo4 .ratyli").ratyli();

	// Font Awesome Signs
	$("#kline .ratyli").ratyli({
		full:"<i class='fa fa-thumbs-up'></i>",
		empty:"<i class='fa fa-thumbs-o-up'></i>",
		onRated:function(value,init){
			// rating callback
			if(!init) $('#ratekline').val(value);  // prevent run at init
		},
	});

	$("#direction .ratyli").ratyli({
		full:"<i class='fa fa-thumbs-up'></i>",
		empty:"<i class='fa fa-thumbs-o-up'></i>",
		onRated:function(value,init){
			// rating callback
			if(!init) $('#ratedirection').val(value);  // prevent run at init
		},
	});

	$("#risk .ratyli").ratyli({
		full:"<i class='fa fa-thumbs-up'></i>",
		empty:"<i class='fa fa-thumbs-o-up'></i>",
		onRated:function(value,init){
			// rating callback
			if(!init) $('#raterisk').val(value);  // prevent run at init
		},
	});

	$("#profitability .ratyli").ratyli({
		full:"<i class='fa fa-thumbs-up'></i>",
		empty:"<i class='fa fa-thumbs-o-up'></i>",
		onRated:function(value,init){
			// rating callback
			if(!init) $('#rateprofitable').val(value);  // prevent run at init
		},
	});

	// Rated Callback
	$("#demo6 .ratyli").ratyli({
		onRated:function(value,init){
			// rating callback
			if(!init) alert(value);  // prevent run at init
		},
	});

	// Sign Callbacks:
	$("#demo7 .ratyli").ratyli({
		onSignClick:function(value,target){
			// sign click event callback
			alert("clicked: "+target);
		},
		onSignEnter:function(value,target){
			// sign mouseenter event callback
			console.log("enter : "+value);
		},
		onSignLeave:function(value,target){
			// sign mouseleave event callback
			console.log("leave : "+target);
		},
	});

	// Custom cursor
	$("#demo8 .ratyli").ratyli({cursor:"crosshair"});

	// Disabled
	$("#demo9 .ratyli").ratyli({disable:true});

	// Unrateable
	$("#demo10 .ratyli").ratyli({unrateable:true});


});

[{"equitywhenstart": 0.0, "symbol": "AUDUSD", "tolerancestoloss": "", "previousordertime": "2018-11-14 13:11:08", 
"isinrange": "", "rate_kline": "2", "previousorderid": 0, "duration": "", 
"price": "", "isthinkover": "", "threenoreason": "", "orderid": 1, "rate_profitable": "1", 
"thebigthing": "", "tolerancestotime": "", "threeyesreason": "", "rate_risk": "1", "profit": "", 
"isworking": "", "maxstoploss": "", "rate_direction": "5"}]