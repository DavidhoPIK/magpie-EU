*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de
* get the scenario GDP & Populaiton data for iso countries
i09_gdp_ppp_iso(t,iso) = f09_gdp_ppp_iso(t,iso,"%c09_gdp_scenario%");
i09_gdp_mer_iso(t,iso) = f09_gdp_mer_iso(t,iso,"%c09_gdp_scenario%");
im_pop_iso(t,iso) = f09_pop_iso(t,iso,"%c09_pop_scenario%");
* get the scenario GDP & Populaiton data for MAgPIE regions
i09_gdp_mer(t,i) = sum(i_to_iso(i,iso),i09_gdp_mer_iso(t,iso));
i09_gdp_ppp(t,i) = sum(i_to_iso(i,iso),i09_gdp_ppp_iso(t,iso));
im_pop(t,i) = sum(i_to_iso(i,iso),im_pop_iso(t,iso));

* Status of countries' development
im_development_state(t,i) = f09_development_state(t,i,"%c09_gdp_scenario%");

* GPD per capita for MAgPIE regions
 im_gdp_pc_mer(t,i)$(
     sum(i_to_iso(i,iso),
       im_pop_iso(t,iso)
     ) >0 ) =
                             sum(i_to_iso(i,iso),
                               i09_gdp_mer_iso(t,iso)
                             ) / sum(i_to_iso(i,iso),
                                 im_pop_iso(t,iso)
                             );

 im_gdp_pc_ppp(t,i)$(
     sum(i_to_iso(i,iso),
       im_pop_iso(t,iso)
     ) >0 ) =
                             sum(i_to_iso(i,iso),
                                i09_gdp_ppp_iso(t,iso)
                             ) / sum(i_to_iso(i,iso),
                                 im_pop_iso(t,iso)
                             );

* GDP per capita for ISO countries
im_gdp_pc_ppp_iso(t,iso)=0;
im_gdp_pc_ppp_iso(t,iso)$(i09_gdp_ppp_iso(t,iso)*im_pop_iso(t,iso)>0)  = i09_gdp_ppp_iso(t,iso)/im_pop_iso(t,iso);
im_gdp_pc_ppp_iso(t,iso)$(im_gdp_pc_ppp_iso(t,iso)=0) = sum(i_to_iso(i,iso), im_gdp_pc_ppp(t,i));

