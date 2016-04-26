//sqlplus 'DB2016_G06/DB2016_G06@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=diassrv2.epfl.ch)(Port=1521))(CONNECT_DATA=(SID=orcldias)))'
var oracledb = require('oracledb');

var auth = {
    user          : "DB2016_G06",
    password      : "DB2016_G06",
    connectString : "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=diassrv2.epfl.ch)(Port=1521))(CONNECT_DATA=(SID=orcldias)))"
  }

oracledb.getConnection(auth, function (err, connection)
  {
    if (err) { console.error('Error: ' + err.message); return; }

    // change to a valid sql query
    connection.execute( 'SELECT DISTINCT EXTRACT(YEAR FROM P.public_date) AS Year, count(P.publication_id) AS Numb_Publication ' +
						'FROM Publication P, Publication_authors PA' +
													' WHERE P.publication_id=PA.publication_id'+
														' GROUP BY  EXTRACT(YEAR FROM P.public_date)',  // bind value for :id
                                                                              // there is no need to add ; or SQL command not properly ended

      function(err, result)
      { if (err) { console.error('Error: ' + err.message); return; }
        console.log(result.rows);
      });

  });
