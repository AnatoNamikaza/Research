execute Timelimit {
		cplex.tilim=3600;
				 }				 

main {
	//Model for first macroperiod
	var Modelt1Source = new IloOplModelSource("Model t-1.mod");
	var Modelt1Def = new IloOplModelDefinition(Modelt1Source);
  	var oplmodel1 = new IloOplModel(Modelt1Def, cplex);
  	var Modelt1data = new IloOplDataSource("Model t-1 (Data).dat");
  	oplmodel1.addDataSource(Modelt1data);
  	oplmodel1.generate();
	cplex.solve();
	var obj = cplex.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex.getCplexTime()); 
	//oplmodel1.postProcess(); 
	var cplex2=new IloCplex(); 
	//Model for second macroperiod
	var Modelt2Source = new IloOplModelSource("Model t-2.mod");
	var Modelt2Def = new IloOplModelDefinition(Modelt2Source);
  	var oplmodel2 = new IloOplModel(Modelt2Def, cplex2);
  	var Modelt2data = new IloOplDataSource("Model t-2 (Data).dat");
  	oplmodel2.addDataSource(Modelt2data);
  	oplmodel2.generate();
  	writeln("cplex solve gives",cplex2.solve()); //...
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from SSt Model"); 
    writeln(); 
	for(var j in oplmodel2.products)
	  for(var l in oplmodel2.productionstages)
	    for(var s in oplmodel1.microperiods) {
		  //writeln("And then we freeze Stagesetup Upper bound [",j,"][",l,"][",s,"]=",oplmodel1.stagesetup[j][l][s].solutionValue); 		    		  
		  oplmodel2.stagesetup[j][l][s].UB = oplmodel1.stagesetup[j][l][s].solutionValue; 
		  oplmodel2.stagesetup[j][l][s].LB = oplmodel1.stagesetup[j][l][s].solutionValue;		    		  		   
  		} 						  
		cplex2.solve();	
		var obj = cplex2.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex2.getCplexTime()); 
		//oplmodel2.postProcess();
	var cplex3=new IloCplex();
	//Model for third macroperiod
	var Modelt3Source = new IloOplModelSource("Model t-3.mod");
	var Modelt3Def = new IloOplModelDefinition(Modelt3Source);
  	var oplmodel3 = new IloOplModel(Modelt3Def, cplex3);
  	var Modelt3data = new IloOplDataSource("Model t-3 (Data).dat");
  	oplmodel3.addDataSource(Modelt3data);
  	oplmodel3.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from SSt Model"); 
    writeln(); 	
	for(var j in oplmodel3.products)
	  for(var l in oplmodel3.productionstages)
	    for(var s in oplmodel2.microperiods) {
		 // writeln("And then we freeze Stagesetup Upper bound [",j,"][",l,"][",s,"]=",oplmodel2.stagesetup[j][l][s].solutionValue); 
		  oplmodel3.stagesetup[j][l][s].UB = oplmodel2.stagesetup[j][l][s].solutionValue;
		  oplmodel3.stagesetup[j][l][s].LB = oplmodel2.stagesetup[j][l][s].solutionValue         
  		} 	  			
		cplex3.solve();	
		var obj = cplex3.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex3.getCplexTime()); 
		//oplmodel3.postProcess();
	var cplex4=new IloCplex();			
	//Model for fourth macroperiod
	var Modelt4Source = new IloOplModelSource("Model t-4.mod");
	var Modelt4Def = new IloOplModelDefinition(Modelt4Source);
  	var oplmodel4 = new IloOplModel(Modelt4Def, cplex4);
  	var Modelt4data = new IloOplDataSource("Model t-4 (Data).dat");
  	oplmodel4.addDataSource(Modelt4data);
  	oplmodel4.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from SSt Model"); 
    writeln(); 
	for(var j in oplmodel4.products)
	  for(var l in oplmodel4.productionstages)
	    for(var s in oplmodel3.microperiods) {
		  //writeln("And then we freeze Stagesetup Upper bound [",j,"][",l,"][",s,"]=",oplmodel3.stagesetup[j][l][s].solutionValue); 
		  oplmodel4.stagesetup[j][l][s].UB = oplmodel3.stagesetup[j][l][s].solutionValue; 	
		  oplmodel4.stagesetup[j][l][s].LB = oplmodel3.stagesetup[j][l][s].solutionValue; 	     
  		} 	  			
		cplex4.solve();	
		var obj = cplex4.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex4.getCplexTime());
		oplmodel4.postProcess();
		
		var ofile = new IloOplOutputFile("E:/2. Research Work (PhD-MS&E)/0. My Research Work/2. MGLSPMS with forecast updates/2. Paper (Data & Code)/Results (Problem B & D)/Heuristic-1 Results (B & D)/P-B (General) Setup Profile-II/TGS2C5D9.txt");
  		ofile.writeln(oplmodel4.printSolution());		
  		ofile.close();

}