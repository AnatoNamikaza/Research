/*********************************************
 * OPL 12.6.0.0 Model
 * Author: Hakeem-ur-Rehman
 * Creation Date: May 29, 2017 at 11:41:06 PM
 *********************************************/
// Define and Initialize INDICES & PARAMETERS DATA
   int FP=...;		range Final_Products=1..FP;
   int RP=...;		range Remaining_Products=7..RP;
   int J=...; 		range products=1..J; 			// Represents All the products
   int L=...; 		range productionstages=1..L;	
   int S=...; 		range microperiods=1..S;
   int T=...; 		range macroperiods=1..T;

// Define & Initialize Sets
	{int} allproductsonstage1 = ...; // All products at Stage One
	{int} allproductsonstage2 = ...;
	{int} allproductsonstage3 = ...;
	{int} allproductsonstage4 = ...;
	{int} allproductsonstage5_1 = ...;
	{int} allproductsonstage5_2 = ...;
	{int} family1stage1 = ...;		 // Family-1 who has same successor in the following stage
	{int} family2stage1 = ...;
	{int} family3stage1 = ...;
	{int} family4stage1 = ...;
	{int} family5stage1 = ...;
	{int} family6stage1 = ...;
	{int} family7stage1 = ...;
	{int} family8stage1 = ...;
	{int} family9stage1 = ...;
	{int} family1stage2 = ...;
	{int} family2stage2 = ...;
	{int} family3stage2 = ...;
	{int} family4stage2 = ...;
	{int} family5stage2 = ...;
	{int} family6stage2 = ...;
	{int} family7stage2 = ...;
	{int} family8stage2 = ...;
	{int} family9stage2 = ...;
	{int} family10stage2 = ...;
	{int} family11stage2 = ...;
	{int} family12stage2 = ...;
	{int} family1stage3 = ...;
	{int} family2stage3 = ...;
	{int} family3stage3 = ...;
	{int} family4stage3 = ...;
	{int} family5stage3 = ...;
	{int} family6stage3 = ...;
	{int} family7stage3 = ...;
	{int} family8stage3 = ...;
	{int} family9stage3 = ...;
	{int} family10stage3 = ...;
	{int} family11stage3 = ...;
	{int} family12stage3 = ...;
	{int} family1stage4 = ...;
	{int} family2stage4 = ...;
	{int} family3stage4 = ...;
	{int} family4stage4 = ...;
	{int} family5stage4 = ...;
	{int} family6stage4 = ...;
	{int} family1stage5_1 = ...;
	{int} family1stage5_2 = ...;
	{int} family2stage5_2 = ...;

	{int} microperiods1tomacroperiod = ...;
	{int} microperiods2tomacroperiod = ...;
	{int} microperiods3tomacroperiod = ...;
	{int} microperiods4tomacroperiod = ...;
	{int} microperiods5tomacroperiod = ...;
	{int} microperiods6tomacroperiod = ...;
	{int} microperiods7tomacroperiod = ...;
	{int} microperiods8tomacroperiod = ...;
	{int} microperiods9tomacroperiod = ...;
	{int} microperiods10tomacroperiod = ...;
	{int} microperiods11tomacroperiod = ...;
	{int} microperiods12tomacroperiod = ...;
	{int} microperiods13tomacroperiod = ...;
	{int} microperiods14tomacroperiod = ...;
	
// Declare & Initialize CONSTANT DATA    
   // Initial Inventory of all the products
  		//int initial_inv=...; 	
   // Maximum inventory level of the jth product
  		//int max_inv=...; 		
   // Minimum Lotsize of the jth product
   		int min_lotsize=...; 	
   // Production cost per unit
   		int production_cost=...;	 
   // production time per unit
   		int production_time=...; 
   // Idle time (i.e. Stand by) cost
   		int standby_cost=...;	
   /* Pijl --> Number of units of product 'i' required to produce 
      one unit of product 'j' on production stage 'l'*/
   		int BOM = ...;
   		int BigM = ...;
   		
// Arrays Delcarations through indicies 	
   // Capacity of the Production Stages 
   		float productstagecapacity[productionstages]=...;	
   // Product Holding Cost 
   		int holdingcost[products]=...;						
   // Products Changeover Cost
   		float setupcost[products]=...;				
   // Products Changeover Time
   		int setuptime[products]=...;				
   // Products Demand 
   		float primary_demand[Final_Products][macroperiods]=...;	
   		float secondary_demand[Remaining_Products][macroperiods]=...;
   
// Defining Decision Variables
	// Inventory Level of jth Product on Lth production stage in Tth macroperiod
		dvar float+ inventory[products][0..T]; 		
	// Total Production Quality of the products on machines'm' in 't'				 
		dvar float+ productionquantity[products][productionstages][microperiods]; 
	// Product Changeover in Microperiod 's'
		dvar float+ Pchangeover[products][products][productionstages][microperiods];
	// Fractional setup time for changeover at the begining of microperiod 's' 	 
		dvar float+ B_setuptime[productionstages][microperiods]; 	 
	// Fractional setup time for changeover at the end of microperiod 's'
		dvar float+ E_setuptime[productionstages][microperiods];
	// Standby (idle) time on machine 'l' in microperiod 's' 	 
		dvar float+ sb[productionstages][microperiods]; 	
		//dvar float+ sb[allproductstage][micro_macroperiods]; 	
	// Lth Machine setup for jth Product in sth Microperiod  					
		dvar boolean stagesetup[products][productionstages][microperiods]; 	

// Computing the objective function value
	dexpr float TotalProductionCost = sum(j in products, l in productionstages, s in microperiods) 
												production_cost*productionquantity[j][l][s]; 
	dexpr float TotalHoldingCost = sum(j in products, t in macroperiods) 
												holdingcost[j]*inventory[j][t];
	dexpr float TotalSetupCost = sum(i,j in products, l in productionstages, s in microperiods) 
												setupcost[j]*Pchangeover[i][j][l][s]; 
	dexpr float TotalStandbyCost = sum(l in productionstages, s in microperiods) 
												standby_cost*sb[l][s];
	// Total Value of the Objective Function
	dexpr float TOTAL_COST = TotalProductionCost + TotalHoldingCost + TotalSetupCost + TotalStandbyCost; 		

// The Model
minimize TOTAL_COST;
subject to 
	{  		
	// Inventory Balancing constraints for final_products on final_stage
  	forall (j in Final_Products, l in productionstages:l>=5, t in macroperiods)
	 Inventory_Balancing: {
	 if(t==1 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods1tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t];
	 if(t==2 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods2tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==3 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods3tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==4 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods4tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==5 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods5tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t];
	 if(t==6 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods6tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t];
	 if(t==7 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods7tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t];
	 if(t==8 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods8tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t];
	 if(t==9 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods9tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t];
	 if(t==10 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods10tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==11 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods11tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==12 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods12tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==13 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods13tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==14 && j in allproductsonstage5_1 && l==5) 
	 	inventory[j][t-1] + sum(s in microperiods14tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	  if(t==1 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods1tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t];
	 if(t==2 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods2tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==3 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods3tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==4 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods4tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==5 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods5tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t];
	 if(t==6 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods6tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t];
	 if(t==7 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods7tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t];
	 if(t==8 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods8tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t];
	 if(t==9 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods9tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t];
	 if(t==10 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods10tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==11 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods11tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==12 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods12tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==13 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods13tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 
	 if(t==14 && j in allproductsonstage5_2 && l==6) 
	 	inventory[j][t-1] + sum(s in microperiods14tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + primary_demand[j][t]; 					 	 	 	 	 
	 }
	 
	 // WIP Balancing constraints 
  	forall (j in Remaining_Products, l in productionstages:l<=L-1, t in macroperiods)
	 WIPInventory_Balancing: {
	 if(t==1 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods1tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];	
 	 if(t==2 && j in allproductsonstage1 && l==1) 
 	 	inventory[j][t-1] + sum(s in microperiods2tomacroperiod) productionquantity[j][l][s] 
 	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==3 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods3tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==4 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods4tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==5 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods5tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==6 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods6tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==7 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods7tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==8 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods8tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==9 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods9tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==10 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods10tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==11 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods11tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==12 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods12tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];	
	 if(t==13 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods13tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==14 && j in allproductsonstage1 && l==1) 
	 	inventory[j][t-1] + sum(s in microperiods14tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];										
 	 if(t==1 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods1tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];	
 	 if(t==2 && j in allproductsonstage2 && l==2) 
 	 	inventory[j][t-1] + sum(s in microperiods2tomacroperiod) productionquantity[j][l][s] 
 	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==3 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods3tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==4 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods4tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==5 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods5tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==6 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods6tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==7 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods7tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==8 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods8tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==9 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods9tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==10 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods10tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==11 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods11tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==12 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods12tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];	
	 if(t==13 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods13tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==14 && j in allproductsonstage2 && l==2) 
	 	inventory[j][t-1] + sum(s in microperiods14tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==1 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods1tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];	
 	 if(t==2 && j in allproductsonstage3 && l==3) 
 	 	inventory[j][t-1] + sum(s in microperiods2tomacroperiod) productionquantity[j][l][s] 
 	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==3 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods3tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==4 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods4tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==5 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods5tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==6 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods6tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==7 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods7tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==8 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods8tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==9 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods9tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==10 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods10tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==11 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods11tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==12 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods12tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];	
	 if(t==13 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods13tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==14 && j in allproductsonstage3 && l==3) 
	 	inventory[j][t-1] + sum(s in microperiods14tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==1 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods1tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];	
 	 if(t==2 && j in allproductsonstage4 && l==4) 
 	 	inventory[j][t-1] + sum(s in microperiods2tomacroperiod) productionquantity[j][l][s] 
 	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==3 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods3tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==4 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods4tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==5 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods5tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==6 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods6tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==7 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods7tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==8 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods8tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==9 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods9tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==10 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods10tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==11 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods11tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==12 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods12tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];	
	 if(t==13 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods13tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
	 if(t==14 && j in allproductsonstage4 && l==4) 
	 	inventory[j][t-1] + sum(s in microperiods14tomacroperiod) productionquantity[j][l][s] 
	 	== inventory[j][t] + BOM * secondary_demand[j][t];
 }	 			
	//Capacity Constraints
	   forall (l in productionstages, t in macroperiods)
	    Capacity_Stage: { 
	     if(l==1 && t==1) 
	     	sum(j in allproductsonstage1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==2) 
	     	sum(j in allproductsonstage1, s in microperiods2tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods2tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods2tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==3) 
	     	sum(j in allproductsonstage1, s in microperiods3tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods3tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods3tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==4) 
	     	sum(j in allproductsonstage1, s in microperiods4tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods4tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods4tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==5) 
	     	sum(j in allproductsonstage1, s in microperiods5tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods5tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods5tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==6) 
	     	sum(j in allproductsonstage1, s in microperiods6tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods6tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods6tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==7) 
	     	sum(j in allproductsonstage1, s in microperiods7tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods7tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods7tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==8) 
	     	sum(j in allproductsonstage1, s in microperiods8tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods8tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods8tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==9) 
	     	sum(j in allproductsonstage1, s in microperiods9tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods9tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods9tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==10) 
	     	sum(j in allproductsonstage1, s in microperiods10tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods10tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods10tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==11) 
	     	sum(j in allproductsonstage1, s in microperiods11tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods11tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods11tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==12) 
	     	sum(j in allproductsonstage1, s in microperiods12tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods12tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods12tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==13) 
	     	sum(j in allproductsonstage1, s in microperiods13tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods13tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods13tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==1 && t==14) 
	     	sum(j in allproductsonstage1, s in microperiods14tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage1, s in microperiods14tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods14tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==2 && t==1) 
	     	sum(j in allproductsonstage2, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==2 && t==2) 
	     	sum(j in allproductsonstage2, s in microperiods2tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods2tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods2tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==2 && t==3) 
	     	sum(j in allproductsonstage2, s in microperiods3tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods3tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods3tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==2 && t==4) 
	     	sum(j in allproductsonstage2, s in microperiods4tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods4tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods4tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==2 && t==5) 
	     	sum(j in allproductsonstage2, s in microperiods5tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods5tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods5tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==2 && t==6) 
	     	sum(j in allproductsonstage2, s in microperiods6tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods6tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods6tomacroperiod) sb[l][s] <= productstagecapacity[l];
	    if(l==2 && t==7) 
	     	sum(j in allproductsonstage2, s in microperiods7tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods7tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods7tomacroperiod) sb[l][s] <= productstagecapacity[l];
	    if(l==2 && t==8) 
	     	sum(j in allproductsonstage2, s in microperiods8tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods8tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods8tomacroperiod) sb[l][s] <= productstagecapacity[l];
	    if(l==2 && t==9) 
	     	sum(j in allproductsonstage2, s in microperiods9tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods9tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods9tomacroperiod) sb[l][s] <= productstagecapacity[l];
	    if(l==2 && t==10) 
	     	sum(j in allproductsonstage2, s in microperiods10tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods10tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods10tomacroperiod) sb[l][s] <= productstagecapacity[l];
	    if(l==2 && t==11) 
	     	sum(j in allproductsonstage2, s in microperiods11tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods11tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods11tomacroperiod) sb[l][s] <= productstagecapacity[l];
	    if(l==2 && t==12) 
	     	sum(j in allproductsonstage2, s in microperiods12tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods12tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods12tomacroperiod) sb[l][s] <= productstagecapacity[l];
	    if(l==2 && t==13) 
	     	sum(j in allproductsonstage2, s in microperiods13tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods13tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods13tomacroperiod) sb[l][s] <= productstagecapacity[l];
	    if(l==2 && t==14) 
	     	sum(j in allproductsonstage2, s in microperiods14tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage2, s in microperiods14tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods14tomacroperiod) sb[l][s] <= productstagecapacity[l];
	    if(l==3 && t==1) 
	     	sum(j in allproductsonstage3, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==2) 
	     	sum(j in allproductsonstage3, s in microperiods2tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods2tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods2tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==3) 
	     	sum(j in allproductsonstage3, s in microperiods3tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods3tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods3tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==4) 
	     	sum(j in allproductsonstage3, s in microperiods4tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods4tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods4tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==5) 
	     	sum(j in allproductsonstage3, s in microperiods5tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods5tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods5tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==6) 
	     	sum(j in allproductsonstage3, s in microperiods6tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods6tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods6tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==7) 
	     	sum(j in allproductsonstage3, s in microperiods7tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods7tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods7tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==8) 
	     	sum(j in allproductsonstage3, s in microperiods8tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods8tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods8tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==9) 
	     	sum(j in allproductsonstage3, s in microperiods9tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods9tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods9tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==10) 
	     	sum(j in allproductsonstage3, s in microperiods10tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods10tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods10tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==11) 
	     	sum(j in allproductsonstage3, s in microperiods11tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods11tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods11tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==12) 
	     	sum(j in allproductsonstage3, s in microperiods12tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods12tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods12tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==13) 
	     	sum(j in allproductsonstage3, s in microperiods13tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods13tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods13tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==3 && t==14) 
	     	sum(j in allproductsonstage3, s in microperiods14tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage3, s in microperiods14tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods14tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==4 && t==1) 
	     	sum(j in allproductsonstage4, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==4 && t==2) 
	     	sum(j in allproductsonstage4, s in microperiods2tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods2tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods2tomacroperiod) sb[l][s] <= productstagecapacity[l];		
	     if(l==4 && t==3) 
	     	sum(j in allproductsonstage4, s in microperiods3tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods3tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods3tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==4 && t==4) 
	     	sum(j in allproductsonstage4, s in microperiods4tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods4tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods4tomacroperiod) sb[l][s] <= productstagecapacity[l];		
	     if(l==4 && t==5) 
	     	sum(j in allproductsonstage4, s in microperiods5tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods5tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods5tomacroperiod) sb[l][s] <= productstagecapacity[l];		
	     if(l==4 && t==6) 
	     	sum(j in allproductsonstage4, s in microperiods6tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods6tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods6tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==4 && t==7) 
	     	sum(j in allproductsonstage4, s in microperiods7tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods7tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods7tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==4 && t==8) 
	     	sum(j in allproductsonstage4, s in microperiods8tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods8tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods8tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==4 && t==9) 
	     	sum(j in allproductsonstage4, s in microperiods9tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods9tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods9tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==4 && t==10) 
	     	sum(j in allproductsonstage4, s in microperiods10tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods10tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods10tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==4 && t==11) 
	     	sum(j in allproductsonstage4, s in microperiods11tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods11tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods11tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==4 && t==12) 
	     	sum(j in allproductsonstage4, s in microperiods12tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods12tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods12tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==4 && t==13) 
	     	sum(j in allproductsonstage4, s in microperiods13tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods13tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods13tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==4 && t==14) 
	     	sum(j in allproductsonstage4, s in microperiods14tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage4, s in microperiods14tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods14tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==1) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==2) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==3) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==4) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==5) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==6) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==7) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==8) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==9) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==10) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==11) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==12) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==13) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==5 && t==14) 
	     	sum(j in allproductsonstage5_1, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_1, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==6 && t==1) 
	     	sum(j in allproductsonstage5_2, s in microperiods1tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods1tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods1tomacroperiod) sb[l][s] <= productstagecapacity[l];																												
	     if(l==6 && t==2) 
	     	sum(j in allproductsonstage5_2, s in microperiods2tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods2tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods2tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==6 && t==3) 
	     	sum(j in allproductsonstage5_2, s in microperiods3tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods3tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods3tomacroperiod) sb[l][s] <= productstagecapacity[l];	
	     if(l==6 && t==4) 
	     	sum(j in allproductsonstage5_2, s in microperiods4tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods4tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods4tomacroperiod) sb[l][s] <= productstagecapacity[l];																												
	     if(l==6 && t==5) 
	     	sum(j in allproductsonstage5_2, s in microperiods5tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods5tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods5tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==6 && t==6) 
	     	sum(j in allproductsonstage5_2, s in microperiods6tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods6tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods6tomacroperiod) sb[l][s] <= productstagecapacity[l];	
	     if(l==6 && t==7) 
	     	sum(j in allproductsonstage5_2, s in microperiods7tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods7tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods7tomacroperiod) sb[l][s] <= productstagecapacity[l];	
	     if(l==6 && t==8) 
	     	sum(j in allproductsonstage5_2, s in microperiods8tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods8tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods8tomacroperiod) sb[l][s] <= productstagecapacity[l];																												
	     if(l==6 && t==9) 
	     	sum(j in allproductsonstage5_2, s in microperiods9tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods9tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods9tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==6 && t==10) 
	     	sum(j in allproductsonstage5_2, s in microperiods10tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods10tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods10tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==6 && t==11) 
	     	sum(j in allproductsonstage5_2, s in microperiods11tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods11tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods11tomacroperiod) sb[l][s] <= productstagecapacity[l];	
	     if(l==6 && t==12) 
	     	sum(j in allproductsonstage5_2, s in microperiods12tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods12tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods12tomacroperiod) sb[l][s] <= productstagecapacity[l];																												
	     if(l==6 && t==13) 
	     	sum(j in allproductsonstage5_2, s in microperiods13tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods13tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods13tomacroperiod) sb[l][s] <= productstagecapacity[l];
	     if(l==6 && t==14) 
	     	sum(j in allproductsonstage5_2, s in microperiods14tomacroperiod) production_time*
	     	productionquantity[j][l][s] + sum(i,j in allproductsonstage5_2, s in microperiods14tomacroperiod) 
	     	setuptime[j]*Pchangeover[i][j][l][s] + sum(s in microperiods14tomacroperiod) sb[l][s] <= productstagecapacity[l];						
	     } 

	//Production Flow between Stages (Sequence & Position) Constraints 
	 forall (j in allproductsonstage1, p in allproductsonstage2, l in productionstages:l<=L-1, s in microperiods)
	   Position_Sequence1:{
	   if (j in family1stage1 && p in family1stage2 && l==1)
	   		BigM * (stagesetup[j][l][s]-1) + sb[l][s] + E_setuptime[l][s]<= BigM*(1-stagesetup[p][l+1][s])+
	   		sb[l+1][s] + E_setuptime[l+1][s];
	   if (j in family2stage1 && p in family2stage2 && l==1)
	   		BigM * (stagesetup[j][l][s]-1) + sb[l][s] + E_setuptime[l][s]<= BigM*(1-stagesetup[p][l+1][s])+
	   		sb[l+1][s] + E_setuptime[l+1][s];	
	   if (j in family3stage1 && p in family3stage2 && l==1)
	   		BigM * (stagesetup[j][l][s]-1) + sb[l][s] + E_setuptime[l][s]<= BigM*(1-stagesetup[p][l+1][s])+
	   		sb[l+1][s] + E_setuptime[l+1][s];	
	   if (j in family4stage1 && p in family4stage2 && l==1)
	   		BigM * (stagesetup[j][l][s]-1) + sb[l][s] + E_setuptime[l][s]<= BigM*(1-stagesetup[p][l+1][s])+
	   		sb[l+1][s] + E_setuptime[l+1][s];	
	   if (j in family5stage1 && p in family5stage2 && l==1)
	   		BigM * (stagesetup[j][l][s]-1) + sb[l][s] + E_setuptime[l][s]<= BigM*(1-stagesetup[p][l+1][s])+
	   		sb[l+1][s] + E_setuptime[l+1][s];	
	   if (j in family6stage1 && p in family6stage2 && l==1)
	   		BigM * (stagesetup[j][l][s]-1) + sb[l][s] + E_setuptime[l][s]<= BigM*(1-stagesetup[p][l+1][s])+
	   		sb[l+1][s] + E_setuptime[l+1][s];
	   if (j in family7stage1 && p in family7stage2 && l==1)
	   		BigM * (stagesetup[j][l][s]-1) + sb[l][s] + E_setuptime[l][s]<= BigM*(1-stagesetup[p][l+1][s])+
	   		sb[l+1][s] + E_setuptime[l+1][s];
	   if (j in family8stage1 && p in family8stage2 && l==1)
	   		BigM * (stagesetup[j][l][s]-1) + sb[l][s] + E_setuptime[l][s]<= BigM*(1-stagesetup[p][l+1][s])+
	   		sb[l+1][s] + E_setuptime[l+1][s];
	   if (j in family9stage1 && p in family9stage2 && l==1)
	   		BigM * (stagesetup[j][l][s]-1) + sb[l][s] + E_setuptime[l][s]<= BigM*(1-stagesetup[p][l+1][s])+
	   		sb[l+1][s] + E_setuptime[l+1][s];																		  		
	   }  
	forall (j in allproductsonstage2, p in allproductsonstage3, l in productionstages:l<=L-1, s in microperiods)
	   Position_Sequence2:{
	   if (j in family10stage2 && p in family1stage3 && l==2)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+1][s])+ B_setuptime[l+1][s] + production_time*productionquantity[p][l+1][s];
	   if (j in family11stage2 && p in family2stage3 && l==2)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+1][s])+ B_setuptime[l+1][s] + production_time*productionquantity[p][l+1][s];  
	   if (j in family3stage2 && p in family3stage3 && l==2)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+1][s])+ B_setuptime[l+1][s] + production_time*productionquantity[p][l+1][s];
	   if (j in family4stage2 && p in family4stage3 && l==2)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+1][s])+ B_setuptime[l+1][s] + production_time*productionquantity[p][l+1][s];	
	   if (j in family5stage2 && p in family5stage3 && l==2)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+1][s])+ B_setuptime[l+1][s] + production_time*productionquantity[p][l+1][s];	
	   if (j in family6stage2 && p in family6stage3 && l==2)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+1][s])+ B_setuptime[l+1][s] + production_time*productionquantity[p][l+1][s];	
	   if (j in family7stage2 && p in family7stage3 && l==2)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+1][s])+ B_setuptime[l+1][s] + production_time*productionquantity[p][l+1][s];	
	   if (j in family12stage2 && p in family8stage3 && l==2)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+1][s])+ B_setuptime[l+1][s] + production_time*productionquantity[p][l+1][s];																		
	   }  
	forall (j in allproductsonstage3, p in allproductsonstage4, l in productionstages:l<=L-1, s in microperiods)
	   Position_Sequence3:{
	   if (j in family9stage3 && p in family1stage4 && l==3)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+2][s])+ B_setuptime[l+2][s] + production_time*productionquantity[p][l+2][s];
	   if (j in family10stage3 && p in family2stage4 && l==3)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+2][s])+ B_setuptime[l+2][s] + production_time*productionquantity[p][l+2][s];
	   if (j in family11stage3 && p in family3stage4 && l==3)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+2][s])+ B_setuptime[l+2][s] + production_time*productionquantity[p][l+2][s];
	   if (j in family12stage3 && p in family4stage4 && l==3)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+2][s])+ B_setuptime[l+2][s] + production_time*productionquantity[p][l+2][s];					
	   }  
	forall (j in allproductsonstage4, p in allproductsonstage5_1, l in productionstages:l<=L-1, s in microperiods)
	   Position_Sequence4:{
	   if (j in family5stage4 && p in family1stage5_1 && l==4)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+1][s])+ B_setuptime[l+1][s] + production_time*productionquantity[p][l+1][s];
	   }     
	forall (j in allproductsonstage4, p in allproductsonstage5_2, l in productionstages:l<=L-1, s in microperiods)
	   Position_Sequence5:{
	   if (j in family5stage4 && p in family1stage5_2 && l==4)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+2][s])+ B_setuptime[l+2][s] + production_time*productionquantity[p][l+2][s];
	   if (j in family6stage4 && p in family2stage5_2 && l==4)
	   		BigM * (stagesetup[j][l][s]-1) + B_setuptime[l][s] + production_time*productionquantity[j][l][s]
	   		<= BigM*(1-stagesetup[p][l+2][s])+ B_setuptime[l+2][s] + production_time*productionquantity[p][l+2][s];		
	   }        

//Upper bound on production quantities
	  forall (j in products, l in productionstages, s in microperiods)  
	       UB_ProductionQTY:{ 
	        if(j in allproductsonstage1 && l==1) 
	        	productionquantity[j][l][s] <= (productstagecapacity[l]/production_time) * stagesetup[j][l][s]; 
 		    if(j in allproductsonstage2 && l==2) 
 		    	productionquantity[j][l][s] <= (productstagecapacity[l]/production_time) * stagesetup[j][l][s];
 		    if(j in allproductsonstage3 && l==3) 
 		    	productionquantity[j][l][s] <= (productstagecapacity[l]/production_time) * stagesetup[j][l][s];
 		    if(j in allproductsonstage4 && l==4) 
 		    	productionquantity[j][l][s] <= (productstagecapacity[l]/production_time) * stagesetup[j][l][s];
 		    if(j in allproductsonstage5_1 && l==5) 
 		    	productionquantity[j][l][s] <= (productstagecapacity[l]/production_time) * stagesetup[j][l][s];	
 		    if(j in allproductsonstage5_2 && l==6) 
 		    	productionquantity[j][l][s] <= (productstagecapacity[l]/production_time) * stagesetup[j][l][s];		 
 			}			
	
	//Lower bound on production quantities - Minimum Lot-size needed / Triangle inequality not always true    
  	  forall (j in products, l in productionstages, s in microperiods)
  		  min_litsizes:{
  		  if(s==1){		  
  		    if(j in allproductsonstage1 && l==1) 
  		    	productionquantity[j][l][s] >= min_lotsize* (stagesetup[j][l][s]);
  		    if(j in allproductsonstage2 && l==2)
  		    	productionquantity[j][l][s] >= min_lotsize* (stagesetup[j][l][s]);
  		    if(j in allproductsonstage3 && l==3) 
  		    	productionquantity[j][l][s] >= min_lotsize* (stagesetup[j][l][s]);
  		    if(j in allproductsonstage4 && l==4) 
  		    	productionquantity[j][l][s] >= min_lotsize* (stagesetup[j][l][s]);
  		    if(j in allproductsonstage5_1 && l==5) 
  		    	productionquantity[j][l][s] >= min_lotsize* (stagesetup[j][l][s]);
  		    if(j in allproductsonstage5_2 && l==6) 
  		    	productionquantity[j][l][s] >= min_lotsize* (stagesetup[j][l][s]);			
   			}
   		  if(s>1){		  
  		    if(j in allproductsonstage1 && l==1) 
  		    	productionquantity[j][l][s] >= min_lotsize* (stagesetup[j][l][s]-stagesetup[j][l][s-1]);
  		    if(j in allproductsonstage2 && l==2)
  		    	productionquantity[j][l][s] >= min_lotsize* (stagesetup[j][l][s]-stagesetup[j][l][s-1]);
  		    if(j in allproductsonstage3 && l==3) 
  		    	productionquantity[j][l][s] >= min_lotsize* (stagesetup[j][l][s]-stagesetup[j][l][s-1]);
  		    if(j in allproductsonstage4 && l==4) 
  		    	productionquantity[j][l][s] >= min_lotsize* (stagesetup[j][l][s]-stagesetup[j][l][s-1]);
  		    if(j in allproductsonstage5_1 && l==5) 
  		    	productionquantity[j][l][s] >= min_lotsize* (stagesetup[j][l][s]-stagesetup[j][l][s-1]);
  		    if(j in allproductsonstage5_2 && l==6) 
  		    	productionquantity[j][l][s] >= min_lotsize* (stagesetup[j][l][s]-stagesetup[j][l][s-1]);			
   			}  	  	  	
    }   			  
  	
  	//Only one production stage setup allowed in each microperiod
	  forall (l in productionstages, s in microperiods)
	         {
	         if(l==1)	
	         	sum(j in allproductsonstage1) 
	         		stagesetup[j][l][s]==1;
 			if(l==2)	
	         	sum(j in allproductsonstage2) 
	         		stagesetup[j][l][s]==1;
	         if(l==3)	
	         	sum(j in allproductsonstage3) 
	         		stagesetup[j][l][s]==1;		
	         if(l==4)	
	         	sum(j in allproductsonstage4) 
	         		stagesetup[j][l][s]==1;
 			if(l==5)	
	         	sum(j in allproductsonstage5_1) 
	         		stagesetup[j][l][s]==1;
	         if(l==6)	
	         	sum(j in allproductsonstage5_2) 
	         		stagesetup[j][l][s]==1;		
 			}							

	//Only one product changeover allowed in each microperiod
	  forall (l in productionstages, s in microperiods:s>=2)     
	        Onlyone_Changeover: {
	        if (l==1) 
	        	sum (i,j in allproductsonstage1) 
	        		Pchangeover[i][j][l][s]==1;  
	        if (l==2) 
	        	sum (i,j in allproductsonstage2) 
	        		Pchangeover[i][j][l][s]==1;
	        if (l==3) 
	        	sum (i,j in allproductsonstage3) 
	        		Pchangeover[i][j][l][s]==1; 
	        if (l==4) 
	        	sum (i,j in allproductsonstage4) 
	        		Pchangeover[i][j][l][s]==1;
	        if (l==5) 
	        	sum (i,j in allproductsonstage5_1) 
	        		Pchangeover[i][j][l][s]==1;
	        if (l==6) 
	        	sum (i,j in allproductsonstage5_2) 
	        		Pchangeover[i][j][l][s]==1; 		 		 		     	        
	        }
	
	 //Setup Spliting idea constrinats
	   forall (l in productionstages, s in microperiods:s>=2) 
	   Setup_Splitting: 
	   {
	   if (l==1) 
	   		E_setuptime[l][s-1] + B_setuptime[l][s] == 
	   		sum (i,j in allproductsonstage1) setuptime[j]*Pchangeover[i][j][l][s]; 
	   if (l==2) 
	   		E_setuptime[l][s-1] + B_setuptime[l][s] == 
	   		sum (i,j in allproductsonstage2) setuptime[j]*Pchangeover[i][j][l][s]; 
	   if (l==3) 
	   		E_setuptime[l][s-1] + B_setuptime[l][s] == 
	   		sum (i,j in allproductsonstage3) setuptime[j]*Pchangeover[i][j][l][s]; 
	   if (l==4) 
	   		E_setuptime[l][s-1] + B_setuptime[l][s] == 
	   		sum (i,j in allproductsonstage4) setuptime[j]*Pchangeover[i][j][l][s]; 
	   	if (l==5) 
	   		E_setuptime[l][s-1] + B_setuptime[l][s] == 
	   		sum (i,j in allproductsonstage5_1) setuptime[j]*Pchangeover[i][j][l][s];
	   	if (l==6) 
	   		E_setuptime[l][s-1] + B_setuptime[l][s] == 
	   		sum (i,j in allproductsonstage5_2) setuptime[j]*Pchangeover[i][j][l][s]; 	 			
	   }      
      
      //Linking between product changeover and machine setup constrinats
		forall (i,j in products, l in productionstages, s in microperiods:s>=2) 
		Changeover_setup: 
		{
	    if(l==1) 
	    	Pchangeover[i][j][l][s] >= stagesetup[i][l][s-1]+ stagesetup[j][l][s]-1;  
	   	if(l==2) 
	   		Pchangeover[i][j][l][s] >= stagesetup[i][l][s-1]+ stagesetup[j][l][s]-1;
	   	if(l==3) 
	   		Pchangeover[i][j][l][s] >= stagesetup[i][l][s-1]+ stagesetup[j][l][s]-1;
	   	if(l==4) 
	   		Pchangeover[i][j][l][s] >= stagesetup[i][l][s-1]+ stagesetup[j][l][s]-1;
	   	if(l==5) 
	   		Pchangeover[i][j][l][s] >= stagesetup[i][l][s-1]+ stagesetup[j][l][s]-1;	
	   	if(l==6) 
	   		Pchangeover[i][j][l][s] >= stagesetup[i][l][s-1]+ stagesetup[j][l][s]-1;		     
		}   
}	  