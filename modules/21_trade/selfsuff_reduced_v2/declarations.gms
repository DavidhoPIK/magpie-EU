*** |  (C) 2008-2023 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

parameters
 i21_trade_bal_reduction(t_all,k_trade)         Trade balance reduction (1)
 i21_trade_margin(h,k_trade)                    Trade margins (USD05MER per tDM)
 i21_trade_tariff(h,k_trade)                    Trade tariffs (USD05MER per tDM)
 p21_timber_trade_glo(k_trade_timber)
;

positive variables
 v21_excess_dem(k_trade)                 Global excess demand (mio. tDM per yr)
 v21_excess_prod(h,k_trade)              Superregional excess production (mio. tDM per yr)
 vm_cost_trade(i)                        Regional  trade costs (mio. USD05MER per yr)
 v21_cost_trade_reg(h,k_trade)           Superregional trade costs for each tradable commodity (mio. USD05MER per yr)
 v21_timber_import(i,k_trade_timber)
 v21_timber_export(i,k_trade_timber)
;

equations
 q21_trade_glo(k_trade)                  Global production constraint (mio. tDM per yr)
 q21_notrade(h,k_notrade)                Superregional production constraint of non-tradable commodities (mio. tDM per yr)
 q21_trade_reg(h,k_trade)                Superregional trade balances i.e. minimum self-sufficiency ratio (1)
 q21_trade_reg_up(h,k_trade)             Superregional trade balances i.e. maximum self-sufficiency ratio (1)
 q21_excess_dem(k_trade)                 Global excess demand (mio. tDM per yr)
 q21_excess_supply(h,k_trade)            Superregional excess production (mio. tDM per yr)
 q21_cost_trade(h)                       Superregional  trade costs (mio. USD05MER per yr)
 q21_cost_trade_reg(h,k_trade)           Superregional trade costs for each tradable commodity (mio. USD05MER per yr)
 q21_timber_prod(i,k_trade_timber)
 q21_timber_import(k_trade_timber)
 q21_timber_export(k_trade_timber)
;

*#################### R SECTION START (OUTPUT DECLARATIONS) ####################
parameters
 ov21_excess_dem(t,k_trade,type)             Global excess demand (mio. tDM per yr)
 ov21_excess_prod(t,h,k_trade,type)          Superregional excess production (mio. tDM per yr)
 ov_cost_trade(t,i,type)                     Regional  trade costs (mio. USD05MER per yr)
 ov21_cost_trade_reg(t,h,k_trade,type)       Superregional trade costs for each tradable commodity (mio. USD05MER per yr)
 ov21_timber_import(t,i,k_trade_timber,type) 
 ov21_timber_export(t,i,k_trade_timber,type) 
 oq21_trade_glo(t,k_trade,type)              Global production constraint (mio. tDM per yr)
 oq21_notrade(t,h,k_notrade,type)            Superregional production constraint of non-tradable commodities (mio. tDM per yr)
 oq21_trade_reg(t,h,k_trade,type)            Superregional trade balances i.e. minimum self-sufficiency ratio (1)
 oq21_trade_reg_up(t,h,k_trade,type)         Superregional trade balances i.e. maximum self-sufficiency ratio (1)
 oq21_excess_dem(t,k_trade,type)             Global excess demand (mio. tDM per yr)
 oq21_excess_supply(t,h,k_trade,type)        Superregional excess production (mio. tDM per yr)
 oq21_cost_trade(t,h,type)                   Superregional  trade costs (mio. USD05MER per yr)
 oq21_cost_trade_reg(t,h,k_trade,type)       Superregional trade costs for each tradable commodity (mio. USD05MER per yr)
 oq21_timber_prod(t,i,k_trade_timber,type)   
 oq21_timber_import(t,k_trade_timber,type)   
 oq21_timber_export(t,k_trade_timber,type)   
;
*##################### R SECTION END (OUTPUT DECLARATIONS) #####################
