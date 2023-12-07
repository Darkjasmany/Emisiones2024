-- Total predios
SELECT "count"("id") FROM predio WHERE estado = 1;

-- Predios por definir 
select * from predio where id_cliente = 170200 and estado = 1;

-- REVISION DE PREDIOS CON Uso area = 0
select * from uso where "areaConConstruccion" + "areaSinConstruccion" = 0;
select * from claveclientevw  where idpredio in (select id_predio from uso where "areaConConstruccion" + "areaSinConstruccion" = 0);

--REVISION DE PREDIOS QUE NO TIENEN DEFINIDOS ISOPRECIOS
--QUERY PARA REVISAR EL VALOR DE ISOPRECIO Y HACERLE UPDATE A LOS PREDIOS QUE ESTAN EN ESE POLIGONO

select "id" from tipo_isoprecios where codigo in (SELECT CONCAT( parroquia.codigo, trim(zona.codigo), trim(sector.codigo), trim(poligono.codigo)) as "Clave Predial(P C P Z S P)" FROM cliente, predio, tipo_personeria_juridica, poligono, sector, zona, parroquia, canton, provincia
																																																			WHERE predio.id_poligono =   '2686' AND predio.id_cliente = cliente.id AND predio.id_poligono = poligono.id AND poligono.id_sector = sector.id AND sector.id_zona = zona.id AND zona.id_parroquia = parroquia.id AND parroquia.id_canton = canton.id AND canton.id_provincia = provincia.id AND tipo_personeria_juridica.id = predio.id_tipo_personeria_juridica AND predio.estado = 1);
select * from caracteristicas_lote where "id" in (select "id" from predio where estado = 1 and id_poligono  = '2686') ;

--QUERY PARA VERIFICAR QUE ISOPRECIO NO ESTA DEFINIDO EN EL PREDIO, CONSIDERANDO EL ID POLIGONO
select "count"("id"),id_poligono from predio where
"id" in (select "id" from caracteristicas_lote where"id" in (select "id" from predio where estado = 1)  and id_tipo_isoprecios is NULL)
and estado = 1 GROUP BY id_poligono ORDER BY id_poligono;

--QUERY PARA INDICAR CUALES SON LOS PREDIOS QUE NO TIENEN ISOPRECIO
select p."id", p.id_poligono , cl.clave, cl.nombres
from predio p , claveclientevw cl
where
p."id" in (select "id" from caracteristicas_lote where"id" in (select "id" from predio where estado = 1)  and id_tipo_isoprecios is NULL)
and p.estado = 1
and p."id"= cl.idpredio
ORDER BY cl.clave

--QUERY PARA SOLVENTAR USOS DUPLICADOS
select * from uso where id_predio in (
(select id_predio
from uso 
where id_predio in (select "id" from predio where estado = 1 ) 
GROUP BY id_predio
HAVING "count"(id_predio) >= 2))
ORDER BY id_predio 

--QUERYS PARA REVISAR LOS PREDIOS QUE NO TIENEN DEFINIDOS EL AREA EN LA TABLA USO
select * from uso where id_predio in (SELECT "id" FROM predio where estado = 1) and "areaSinConstruccion" + "areaConConstruccion" = 0 ORDER BY id_predio;
select cl.clave,cl.nombres,u.id_predio,u."areaSinConstruccion",u."areaConConstruccion" 
from uso u, claveclientevw cl where u.id_predio in (SELECT "id" FROM predio where estado = 1) 
and u.id_predio = cl.idpredio
and u."areaSinConstruccion" + u."areaConConstruccion" = 0  ORDER BY u.id_predio;

--QUERY PARA ACTUALIZAR EL AREA
--PRIMERO COPIAR EL AREA DE LA TABLA_CARACTERISTICA LOTE EN EL CAMPO AREASINCONTRUCCION DE LA TABLA USO
select * from predio where estado = 1 ORDER BY "id";
select * from caracteristicas_lote where "id" in (select "id" from predio where estado = 1 )ORDER BY "id";
select * from uso where id_predio in (select "id" from predio where estado = 1 ) ORDER BY id_predio;

--QUERY PARA REVISAR LOS REGISTROS DE LIQUIDACIONES
--NO TIENEN LIQUIDACION DEL AÑO A CONSULTAR
select * from predio where "id" not in (select id_predio  from liquidacion_avaluo where id_predio in (SELECT "id" FROM predio where estado = 1) and estado = 1 and ano = 2021) and estado = 1 ORDER BY "id" ;

--PARA REVISAR QUE TODOS TENGAN LIQUIDACION
select * from liquidacion_avaluo where id_predio in (SELECT "id" FROM predio where estado = 1) and estado = 1 and ano = 2021;
select * from factura where id 	in (select id_factura from liquidacion_avaluo where id_predio in (SELECT "id" FROM predio where estado = 1) and estado = 1 and ano = 2021);
select * from factura_detalle where id_factura 	in (select id_factura from liquidacion_avaluo where id_predio in (SELECT "id" FROM predio where estado = 1) and estado = 1 and ano = 2021);
