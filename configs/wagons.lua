Wagons = {                                          -- Gold to Dollar Ratio Based on 1899 Gold Price / sellPrice is 60% of cashPrice
    {
        name  = 'Buggies',
        types = { -- Only Players with Specified Job will See that Wagon to Purchase in the Menu
            ['buggy01'] = { label = 'Buggy 1', cashPrice = 1500, goldPrice = 0,  invLimit = 50, job = {} }, -- Job Example: {'police', 'doctor'}
            ['buggy02'] = { label = 'Buggy 2', cashPrice = 1500, goldPrice = 0, invLimit = 50, job = {} },
            ['buggy03'] = { label = 'Buggy 3', cashPrice = 1500, goldPrice = 0, invLimit = 50, job = {} },
        }
    },
    {
        name = 'Coaches',
        types = {
            ['coach3'] = { label = 'Coach 3', cashPrice = 600, goldPrice = false, invLimit = 100, job = {} },
            ['coach4'] = { label = 'Coach 4', cashPrice = 500, goldPrice = false, invLimit = 100, job = {} },
            ['coach5'] = { label = 'Coach 5', cashPrice = 500, goldPrice = false, invLimit = 100, job = {} },
            ['coach6'] = { label = 'Coach 6', cashPrice = 600, goldPrice = false, invLimit = 100, job = {} },
        }
    },
    {
        name = 'Carts',
        types = {
            ['cart01']       = { label = 'Cart 1',      cashPrice = 400, goldPrice = false, invLimit = 200, job = {} },
            ['cart02']       = { label = 'Cart 2',      cashPrice = 400, goldPrice = false,  invLimit = 200, job = {} },
            ['cart03']       = { label = 'Cart 3',      cashPrice = 400, goldPrice = false, invLimit = 200, job = {} },
            ['cart04']       = { label = 'Cart 4',      cashPrice = 450, goldPrice = false, invLimit = 200, job = {} },
            ['cart06']       = { label = 'Cart 6',      cashPrice = 650, goldPrice = false, invLimit = 200, job = {} },
            ['cart07']       = { label = 'Cart 7',      cashPrice = 400, goldPrice = false, invLimit = 200, job = {} },
            ['cart08']       = { label = 'Cart 8',      cashPrice = 400, goldPrice = false, invLimit = 200, job = {} },
            ['huntercart01'] = { label = 'Hunter Cart', cashPrice = 3000, goldPrice = false, invLimit = 200, job = {} },
        }
    },
    {
        name = 'Wagons',
        types = {
            ['supplywagon']       = { label = 'Supply Wagon',  cashPrice = 1500,  goldPrice = false, invLimit = 400, job = {} },
            ['wagontraveller01x'] = { label = 'Travel Wagon',  cashPrice = 2000, goldPrice = false, invLimit = 400, job = {} },
            ['wagon02x']          = { label = 'Large Storage Wagon',       cashPrice = 10000, goldPrice = false, invLimit = 2450, job = {} },
            ['wagon03x']          = { label = 'Wagon 3',       cashPrice = 2050, goldPrice = false, invLimit = 400, job = {} },
            ['wagon04x']          = { label = 'Wagon 4',       cashPrice = 2050, goldPrice = false, invLimit = 400, job = {} },
            ['wagon05x']          = { label = 'Small Storage Wagon',       cashPrice = 6000, goldPrice = false, invLimit = 1250, job = {} },
            ['wagon06x']          = { label = 'Wagon 6',       cashPrice = 600, goldPrice = false, invLimit = 200, job = {} },
            ['chuckwagon000x']    = { label = 'Chuck Wagon 1', cashPrice = 2000, goldPrice = false, invLimit = 400, job = {} },
            ['chuckwagon002x']    = { label = 'Chuck Wagon 2', cashPrice = 2000, goldPrice = false, invLimit = 400, job = {} },
        }
    }
}

LoadoutCapacity = {	-- List to load animals, npcs and skins to the carts.
    [`ArmySupplyWagon`] = 15,
    [`bountywagon01x`] = 5, 
    [`buggy01`] = 3,
    [`buggy02`] = 3,
    [`buggy03`] = 3,
    [`cart01`] = 3,  
    [`cart02`] = 3,  
    [`cart03`] = 5,
    [`cart04`] = 5,
    [`cart05`] = 3,  
    [`cart06`] = 7,
    [`cart07`] = 5,
    [`cart08`] = 5,
    [`chuckwagon000x`] = 15, 
    [`chuckwagon002x`] = 15, 
    [`coach2`] = 7,         
    [`coach3_cutscene`] = 7,
    [`coach3`] = 7,
    [`coach4`] = 5,
    [`coach5`] = 5,
    [`coach6`] = 5,
    [`coal_wagon`] = 5,   
    [`gatchuck`] = 15, 
    [`huntercart01`] = 15,
    [`logwagon`] = 5,
    [`oilWagon01x`] = 7,    
    [`oilWagon02x`] = 7,    
    [`policewagon01x`] = 7, 
    [`policeWagongatling01x`] = 7, 
    [`gatchuck_2`] = 7, 
    [`stagecoach001x`] = 7, 
    [`stagecoach002x`] = 7, 
    [`stagecoach003x`] = 7, 
    [`stagecoach004_2x`] = 7,
    [`stagecoach004x`] = 7, 
    [`stagecoach005x`] = 7, 
    [`stagecoach006x`] = 7, 
    [`supplywagon`] = 15,    
    [`utilliwag`] = 5,    
    [`wagon02x`] = 15,       
    [`wagon03x`] = 7,       
    [`wagon04x`] = 15,       
    [`wagon05x`] = 15,       
    [`wagon06x`] = 5,     
    [`wagonarmoured01x`] = 15,
    [`wagonCircus01x`] = 7, 
    [`wagonCircus02x`] = 7, 
    [`wagondairy01x`] = 5,
    [`wagondoc01x`] = 7,    
    [`wagonPrison01x`] = 7,            
    [`wagontraveller01x`] = 5,
    [`wagonwork01x`] = 5,
    [`warwagon2`] = 8,
    [`hotAirBalloon01`] = 7,
}

Lanterns = {
    [`buggy01`] = false,
    [`buggy02`] = false,
    [`buggy03`] = false,

    [`coach3`] = false,
    [`coach4`] = false,
    [`coach5`] = false,
    [`coach6`] = false,

    [`cart01`] = false,
    [`cart02`] = false,
    [`cart03`] = false,
    [`cart04`] = false,
    [`cart06`] = false,
    [`cart07`] = false,
    [`cart08`] = false,

    [`huntercart01`] = `pg_veh_cart06_lanterns01`,

    [`supplywagon`] = false,
    [`wagontraveller01x`] = false,
    [`wagon02x`] = `pg_veh_wagon02x_lanterns01`,
    [`wagon03x`] =  false,
    [`wagon04x`] =  `pg_veh_wagon04x_lanterns01`,
    [`wagon05x`] =  `pg_veh_wagon05x_lanterns02`,
    [`wagon06x`] =  `pg_teamster_wagon06x_lightupgrade3`,
    [`chuckwagon000x`] = `pg_veh_chuckwagon000x_lanterns`,
    [`chuckwagon002x`] = `pg_veh_chuckwagon002x_lanterns01`
}