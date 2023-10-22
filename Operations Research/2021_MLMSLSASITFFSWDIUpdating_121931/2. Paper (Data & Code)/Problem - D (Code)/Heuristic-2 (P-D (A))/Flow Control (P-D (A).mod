/*********************************************
 * OPL 12.6.0.0 Model
 * Author: Hakeem-ur-Rehman
 * Creation Date: May 29, 2017 at 4:57:16 PM
 *********************************************/
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
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the first period SSt Model"); 
    writeln(); 
	for(var j in oplmodel2.products)
	  for(var l in oplmodel2.productionstages)
	    for(var s in oplmodel1.microperiods) {   		  
		  oplmodel2.stagesetup[j][l][s].UB = oplmodel1.stagesetup[j][l][s].solutionValue; 
		  oplmodel2.stagesetup[j][l][s].LB = oplmodel1.stagesetup[j][l][s].solutionValue;
		  oplmodel2.productionquantity[j][l][s].UB = oplmodel1.productionquantity[j][l][s].solutionValue; 
		  oplmodel2.productionquantity[j][l][s].LB = oplmodel1.productionquantity[j][l][s].solutionValue;		    		  		   
  		}
  	writeln("After Freezing the Production Setup Variables: Solution of Second period SSt Model is");	 						  
		cplex2.solve();	
		var obj = cplex2.getObjValue();
		writeln("The Value of the Model-2 Objective Function Value is (Total Cost): ", obj);
		writeln("Model-2: Solving CPU Elapsed Time  in (Seconds): ", cplex2.getCplexTime()); 
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
    writeln("Freeze the Production Setup Variables which obtained from the 2nd period SSt Model"); 
    writeln(); 	
	for(var j in oplmodel3.products)
	  for(var l in oplmodel3.productionstages)
	    for(var s in oplmodel2.microperiods) { 
		  oplmodel3.stagesetup[j][l][s].UB = oplmodel2.stagesetup[j][l][s].solutionValue;
		  oplmodel3.stagesetup[j][l][s].LB = oplmodel2.stagesetup[j][l][s].solutionValue;
		  oplmodel3.productionquantity[j][l][s].UB = oplmodel2.productionquantity[j][l][s].solutionValue; 
		  oplmodel3.productionquantity[j][l][s].LB = oplmodel2.productionquantity[j][l][s].solutionValue;         
  		} 
  	writeln("After Freezing the Production Setup Variables: Solution of 3rd period SSt Model is");			  			
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
    writeln("Freeze the Production Setup Variables which obtained from the 3rd period SSt Model"); 
    writeln(); 
	for(var j in oplmodel4.products)
	  for(var l in oplmodel4.productionstages)
	    for(var s in oplmodel3.microperiods) { 
		  oplmodel4.stagesetup[j][l][s].UB = oplmodel3.stagesetup[j][l][s].solutionValue; 	
		  oplmodel4.stagesetup[j][l][s].LB = oplmodel3.stagesetup[j][l][s].solutionValue; 	
		  oplmodel4.productionquantity[j][l][s].UB = oplmodel3.productionquantity[j][l][s].solutionValue; 
		  oplmodel4.productionquantity[j][l][s].LB = oplmodel3.productionquantity[j][l][s].solutionValue;     
  		} 	  			
  	writeln("After Freezing the Production Setup Variables: Solution of the 4th period SSt Model is");	 	
		cplex4.solve();	
		var obj = cplex4.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex4.getCplexTime());
		//oplmodel4.postProcess();
	var cplex5=new IloCplex();			
	//Model for 5th macroperiod
	var Modelt5Source = new IloOplModelSource("Model t-5.mod");
	var Modelt5Def = new IloOplModelDefinition(Modelt5Source);
  	var oplmodel5 = new IloOplModel(Modelt5Def, cplex5);
  	var Modelt5data = new IloOplDataSource("Model t-5 (Data).dat");
  	oplmodel5.addDataSource(Modelt5data);
  	oplmodel5.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the 4th period SSt Model"); 
    writeln(); 
	for(var j in oplmodel5.products)
	  for(var l in oplmodel5.productionstages)
	    for(var s in oplmodel4.microperiods) {
		  oplmodel5.stagesetup[j][l][s].UB = oplmodel4.stagesetup[j][l][s].solutionValue; 	
		  oplmodel5.stagesetup[j][l][s].LB = oplmodel4.stagesetup[j][l][s].solutionValue; 	 
		  oplmodel5.productionquantity[j][l][s].UB = oplmodel4.productionquantity[j][l][s].solutionValue; 
		  oplmodel5.productionquantity[j][l][s].LB = oplmodel4.productionquantity[j][l][s].solutionValue;     
  		} 	
  	writeln("After Freezing the Production Setup Variables: Solution of the 5th period SSt Model is");		  			
		cplex5.solve();	
		var obj = cplex5.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex5.getCplexTime());
		//oplmodel5.postProcess();
	
	var cplex6=new IloCplex();			
	//Model for 6th macroperiod
	var Modelt6Source = new IloOplModelSource("Model t-6.mod");
	var Modelt6Def = new IloOplModelDefinition(Modelt6Source);
  	var oplmodel6 = new IloOplModel(Modelt6Def, cplex6);
  	var Modelt6data = new IloOplDataSource("Model t-6 (Data).dat");
  	oplmodel6.addDataSource(Modelt6data);
  	oplmodel6.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the 5th period SSt Model"); 
    writeln(); 
	for(var j in oplmodel6.products)
	  for(var l in oplmodel6.productionstages)
	    for(var s in oplmodel5.microperiods) {
		  oplmodel6.stagesetup[j][l][s].UB = oplmodel5.stagesetup[j][l][s].solutionValue; 	
		  oplmodel6.stagesetup[j][l][s].LB = oplmodel5.stagesetup[j][l][s].solutionValue; 
		  oplmodel6.productionquantity[j][l][s].UB = oplmodel5.productionquantity[j][l][s].solutionValue; 
		  oplmodel6.productionquantity[j][l][s].LB = oplmodel5.productionquantity[j][l][s].solutionValue;  	     
  		}
  	writeln("After Freezing the Production Setup Variables: Solution of the 6th period SSt Model is");		 	  			
		cplex6.solve();	
		var obj = cplex6.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex6.getCplexTime());
		//oplmodel6.postProcess();
	
	var cplex7=new IloCplex();			
	//Model for 7th macroperiod
	var Modelt7Source = new IloOplModelSource("Model t-7.mod");
	var Modelt7Def = new IloOplModelDefinition(Modelt7Source);
  	var oplmodel7 = new IloOplModel(Modelt7Def, cplex7);
  	var Modelt7data = new IloOplDataSource("Model t-7 (Data).dat");
  	oplmodel7.addDataSource(Modelt7data);
  	oplmodel7.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the 6th period SSt Model"); 
    writeln(); 
	for(var j in oplmodel7.products)
	  for(var l in oplmodel7.productionstages)
	    for(var s in oplmodel6.microperiods) { 
		  oplmodel7.stagesetup[j][l][s].UB = oplmodel6.stagesetup[j][l][s].solutionValue; 	
		  oplmodel7.stagesetup[j][l][s].LB = oplmodel6.stagesetup[j][l][s].solutionValue;
		  oplmodel7.productionquantity[j][l][s].UB = oplmodel6.productionquantity[j][l][s].solutionValue; 
		  oplmodel7.productionquantity[j][l][s].LB = oplmodel6.productionquantity[j][l][s].solutionValue; 	     
  		} 	
  	writeln("After Freezing the Production Setup Variables: Solution of the 7th period SSt Model is");		  			
		cplex7.solve();	
		var obj = cplex7.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex7.getCplexTime());
		//oplmodel7.postProcess();
		
	var cplex8=new IloCplex();			
	//Model for 8th macroperiod
	var Modelt8Source = new IloOplModelSource("Model t-8.mod");
	var Modelt8Def = new IloOplModelDefinition(Modelt8Source);
  	var oplmodel8 = new IloOplModel(Modelt8Def, cplex8);
  	var Modelt8data = new IloOplDataSource("Model t-8 (Data).dat");
  	oplmodel8.addDataSource(Modelt8data);
  	oplmodel8.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the 7th period SSt Model"); 
    writeln(); 
	for(var j in oplmodel8.products)
	  for(var l in oplmodel8.productionstages)
	    for(var s in oplmodel7.microperiods) { 
		  oplmodel8.stagesetup[j][l][s].UB = oplmodel7.stagesetup[j][l][s].solutionValue; 	
		  oplmodel8.stagesetup[j][l][s].LB = oplmodel7.stagesetup[j][l][s].solutionValue; 
		  oplmodel8.productionquantity[j][l][s].UB = oplmodel7.productionquantity[j][l][s].solutionValue; 
		  oplmodel8.productionquantity[j][l][s].LB = oplmodel7.productionquantity[j][l][s].solutionValue; 	     
  		} 	  	
  	writeln("After Freezing the Production Setup Variables: Solution of the 8th period SSt Model is");			
		cplex8.solve();	
		var obj = cplex8.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex8.getCplexTime());
		//oplmodel8.postProcess();	
		
	var cplex9=new IloCplex();			
	//Model for 9th macroperiod
	var Modelt9Source = new IloOplModelSource("Model t-9.mod");
	var Modelt9Def = new IloOplModelDefinition(Modelt9Source);
  	var oplmodel9 = new IloOplModel(Modelt9Def, cplex9);
  	var Modelt9data = new IloOplDataSource("Model t-9 (Data).dat");
  	oplmodel9.addDataSource(Modelt9data);
  	oplmodel9.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the 8th period SSt Model"); 
    writeln(); 
	for(var j in oplmodel9.products)
	  for(var l in oplmodel9.productionstages)
	    for(var s in oplmodel8.microperiods) { 
		  oplmodel9.stagesetup[j][l][s].UB = oplmodel8.stagesetup[j][l][s].solutionValue; 	
		  oplmodel9.stagesetup[j][l][s].LB = oplmodel8.stagesetup[j][l][s].solutionValue; 	
		  oplmodel9.productionquantity[j][l][s].UB = oplmodel8.productionquantity[j][l][s].solutionValue; 
		  oplmodel9.productionquantity[j][l][s].LB = oplmodel8.productionquantity[j][l][s].solutionValue; 	     
  		} 	  			
  	writeln("After Freezing the Production Setup Variables: Solution of the 9th period SSt Model is");	
		cplex9.solve();	
		var obj = cplex9.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex9.getCplexTime());
		//oplmodel9.postProcess();	
	
	var cplex10=new IloCplex();			
	//Model for 10th macroperiod
	var Modelt10Source = new IloOplModelSource("Model t-10.mod");
	var Modelt10Def = new IloOplModelDefinition(Modelt10Source);
  	var oplmodel10 = new IloOplModel(Modelt10Def, cplex10);
  	var Modelt10data = new IloOplDataSource("Model t-10 (Data).dat");
  	oplmodel10.addDataSource(Modelt10data);
  	oplmodel10.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the 9th period SSt Model"); 
    writeln(); 
	for(var j in oplmodel10.products)
	  for(var l in oplmodel10.productionstages)
	    for(var s in oplmodel9.microperiods) {
		  oplmodel10.stagesetup[j][l][s].UB = oplmodel9.stagesetup[j][l][s].solutionValue; 	
		  oplmodel10.stagesetup[j][l][s].LB = oplmodel9.stagesetup[j][l][s].solutionValue; 	
		  oplmodel10.productionquantity[j][l][s].UB = oplmodel9.productionquantity[j][l][s].solutionValue; 
		  oplmodel10.productionquantity[j][l][s].LB = oplmodel9.productionquantity[j][l][s].solutionValue;      
  		} 
  	writeln("After Freezing the Production Setup Variables: Solution of the 10th period SSt Model is");		  			
		cplex10.solve();	
		var obj = cplex10.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex10.getCplexTime());
		//oplmodel10.postProcess();	
	
	var cplex11=new IloCplex();			
	//Model for 11th macroperiod
	var Modelt11Source = new IloOplModelSource("Model t-11.mod");
	var Modelt11Def = new IloOplModelDefinition(Modelt11Source);
  	var oplmodel11 = new IloOplModel(Modelt11Def, cplex11);
  	var Modelt11data = new IloOplDataSource("Model t-11 (Data).dat");
  	oplmodel11.addDataSource(Modelt11data);
  	oplmodel11.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the 10th period SSt Model"); 
    writeln(); 
	for(var j in oplmodel11.products)
	  for(var l in oplmodel11.productionstages)
	    for(var s in oplmodel10.microperiods) {
		  oplmodel11.stagesetup[j][l][s].UB = oplmodel10.stagesetup[j][l][s].solutionValue; 	
		  oplmodel11.stagesetup[j][l][s].LB = oplmodel10.stagesetup[j][l][s].solutionValue; 
		  oplmodel11.productionquantity[j][l][s].UB = oplmodel10.productionquantity[j][l][s].solutionValue; 
		  oplmodel11.productionquantity[j][l][s].LB = oplmodel10.productionquantity[j][l][s].solutionValue;	     
  		} 
  	writeln("After Freezing the Production Setup Variables: Solution of the 11th period SSt Model is");		  			
		cplex11.solve();	
		var obj = cplex11.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex11.getCplexTime());
		//oplmodel11.postProcess();	
	
	var cplex12=new IloCplex();			
	//Model for 12th macroperiod
	var Modelt12Source = new IloOplModelSource("Model t-12.mod");
	var Modelt12Def = new IloOplModelDefinition(Modelt12Source);
  	var oplmodel12 = new IloOplModel(Modelt12Def, cplex12);
  	var Modelt12data = new IloOplDataSource("Model t-12 (Data).dat");
  	oplmodel12.addDataSource(Modelt12data);
  	oplmodel12.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the 11th period SSt Model"); 
    writeln(); 
	for(var j in oplmodel12.products)
	  for(var l in oplmodel12.productionstages)
	    for(var s in oplmodel11.microperiods) {
		  oplmodel12.stagesetup[j][l][s].UB = oplmodel11.stagesetup[j][l][s].solutionValue; 	
		  oplmodel12.stagesetup[j][l][s].LB = oplmodel11.stagesetup[j][l][s].solutionValue; 
		  oplmodel12.productionquantity[j][l][s].UB = oplmodel11.productionquantity[j][l][s].solutionValue; 
		  oplmodel12.productionquantity[j][l][s].LB = oplmodel11.productionquantity[j][l][s].solutionValue;	 	     
  		} 
  	writeln("After Freezing the Production Setup Variables: Solution of the 12th period SSt Model is");		  			
		cplex12.solve();	
		var obj = cplex12.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex12.getCplexTime());
		//oplmodel12.postProcess();	
	
	var cplex13=new IloCplex();			
	//Model for 13th macroperiod
	var Modelt13Source = new IloOplModelSource("Model t-13.mod");
	var Modelt13Def = new IloOplModelDefinition(Modelt13Source);
  	var oplmodel13 = new IloOplModel(Modelt13Def, cplex13);
  	var Modelt13data = new IloOplDataSource("Model t-13 (Data).dat");
  	oplmodel13.addDataSource(Modelt13data);
  	oplmodel13.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the 12th period SSt Model"); 
    writeln(); 
	for(var j in oplmodel13.products)
	  for(var l in oplmodel13.productionstages)
	    for(var s in oplmodel12.microperiods) {
		  oplmodel13.stagesetup[j][l][s].UB = oplmodel12.stagesetup[j][l][s].solutionValue; 	
		  oplmodel13.stagesetup[j][l][s].LB = oplmodel12.stagesetup[j][l][s].solutionValue; 
		  oplmodel13.productionquantity[j][l][s].UB = oplmodel12.productionquantity[j][l][s].solutionValue; 
		  oplmodel13.productionquantity[j][l][s].LB = oplmodel12.productionquantity[j][l][s].solutionValue;	 	     
  		}
  	writeln("After Freezing the Production Setup Variables: Solution of the 13th period SSt Model is");	 	  			
		cplex13.solve();	
		var obj = cplex13.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex13.getCplexTime());
		//oplmodel13.postProcess();	
	
	var cplex14=new IloCplex();			
	//Model for 14th macroperiod
	var Modelt14Source = new IloOplModelSource("Model t-14.mod");
	var Modelt14Def = new IloOplModelDefinition(Modelt14Source);
  	var oplmodel14 = new IloOplModel(Modelt14Def, cplex14);
  	var Modelt14data = new IloOplDataSource("Model t-14 (Data).dat");
  	oplmodel14.addDataSource(Modelt14data);
  	oplmodel14.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the 13th period SSt Model"); 
    writeln(); 
	for(var j in oplmodel14.products)
	  for(var l in oplmodel14.productionstages)
	    for(var s in oplmodel13.microperiods) {
		  oplmodel14.stagesetup[j][l][s].UB = oplmodel13.stagesetup[j][l][s].solutionValue; 	
		  oplmodel14.stagesetup[j][l][s].LB = oplmodel13.stagesetup[j][l][s].solutionValue;
		  oplmodel14.productionquantity[j][l][s].UB = oplmodel13.productionquantity[j][l][s].solutionValue; 
		  oplmodel14.productionquantity[j][l][s].LB = oplmodel13.productionquantity[j][l][s].solutionValue;	  	     
  		} 	
  	writeln("After Freezing the Production Setup Variables: Solution of the 14th period SSt Model is");	 	  			
		cplex14.solve();	
		var obj = cplex14.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex14.getCplexTime());
		//oplmodel14.postProcess();	
	
	var cplex15=new IloCplex();			
	//Model for 15th macroperiod
	var Modelt15Source = new IloOplModelSource("Model t-15.mod");
	var Modelt15Def = new IloOplModelDefinition(Modelt15Source);
  	var oplmodel15 = new IloOplModel(Modelt15Def, cplex15);
  	var Modelt15data = new IloOplDataSource("Model t-15 (Data).dat");
  	oplmodel15.addDataSource(Modelt15data);
  	oplmodel15.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the 14th period SSt Model"); 
    writeln(); 
	for(var j in oplmodel15.products)
	  for(var l in oplmodel15.productionstages)
	    for(var s in oplmodel14.microperiods) {
		  oplmodel15.stagesetup[j][l][s].UB = oplmodel14.stagesetup[j][l][s].solutionValue; 	
		  oplmodel15.stagesetup[j][l][s].LB = oplmodel14.stagesetup[j][l][s].solutionValue; 	
		  oplmodel15.productionquantity[j][l][s].UB = oplmodel14.productionquantity[j][l][s].solutionValue; 
		  oplmodel15.productionquantity[j][l][s].LB = oplmodel14.productionquantity[j][l][s].solutionValue;	     
  		} 	
  	writeln("After Freezing the Production Setup Variables: Solution of the 15th period SSt Model is");	  			
		cplex15.solve();	
		var obj = cplex15.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex15.getCplexTime());
		//oplmodel15.postProcess();	
	
	var cplex16=new IloCplex();			
	//Model for 16th macroperiod
	var Modelt16Source = new IloOplModelSource("Model t-16.mod");
	var Modelt16Def = new IloOplModelDefinition(Modelt16Source);
  	var oplmodel16 = new IloOplModel(Modelt16Def, cplex16);
  	var Modelt16data = new IloOplDataSource("Model t-16 (Data).dat");
  	oplmodel16.addDataSource(Modelt16data);
  	oplmodel16.generate();
	//Fixing Production Setup Variable 
	writeln(); 
    writeln("Freeze the Production Setup Variables which obtained from the 15th period SSt Model"); 
    writeln(); 
	for(var j in oplmodel16.products)
	  for(var l in oplmodel16.productionstages)
	    for(var s in oplmodel15.microperiods) {
		  oplmodel16.stagesetup[j][l][s].UB = oplmodel15.stagesetup[j][l][s].solutionValue; 	
		  oplmodel16.stagesetup[j][l][s].LB = oplmodel15.stagesetup[j][l][s].solutionValue; 
		  oplmodel16.productionquantity[j][l][s].UB = oplmodel15.productionquantity[j][l][s].solutionValue; 
		  oplmodel16.productionquantity[j][l][s].LB = oplmodel15.productionquantity[j][l][s].solutionValue;		     
  		} 
  	writeln("After Freezing the Production Setup Variables: Solution of the 16th period SSt Model is");		  			
		cplex16.solve();	
		var obj = cplex16.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Cost): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex16.getCplexTime());
		oplmodel16.postProcess();	
					
		var ofile = new IloOplOutputFile("E:/2. Research Work (PhD-MS&E)/0. My Research Work/2. MGLSPMS with forecast updates/2. Paper (Data & Code)/Results (Problem B & D)/Heuristic-1 Results (B & D)/Setup Profile-II/TAS2C5D9.txt");
  		ofile.writeln(oplmodel6.printSolution());		
  		ofile.close();

}