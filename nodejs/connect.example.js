//sqlplus 'DB2016_G06/DB2016_G06@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=diassrv2.epfl.ch)(Port=1521))(CONNECT_DATA=(SID=orcldias)))'

var auth = {
    user          : "DB2016_G06",
    password      : "DB2016_G06",
    connectString : "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=diassrv2.epfl.ch)(Port=1521))(CONNECT_DATA=(SID=orcldias)))"
  }

function callback(err, connection)
  {
    if (err) { console.error('Error: ' + err.message); return; }

    // change to a valid sql query
    connection.execute(
      "SELECT AUTHOR_NAME " +
        "FROM AUTHOR " +
        "WHERE AUTHOR_ID = :id",
      [1],  // bind value for :id
      function(err, result)
      {
        if (err) { console.error('Error: ' + err.message); return; }
        console.log(result.rows);
      });

  }

oracledb.getConnection(auth, callback);
