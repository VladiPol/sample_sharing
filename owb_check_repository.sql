--
-- In welchem Projekt/Modul befindet sich ein bestimmtes Mapping
--
exec owbsys.wb_workspace_management.set_workspace('OWB_PARIS','OWB_PARIS');  -- auszuführen als OWBSYS auf der Zieldatenbank
select       ISY.PROJECT_NAME as owb_projekt
            ,M.INFORMATION_SYSTEM_NAME as owb_modul
            ,M.MAP_NAME
   from     owbsys.ALL_IV_XFORM_MAPS m
            ,owbsys.all_iv_information_systems isy
   where    m.map_name = 'MPS_DARLEHEN' and
            M.INFORMATION_SYSTEM_ID = ISy.INFORMATION_SYSTEM_ID
