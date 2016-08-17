// 
// Created by the DataSnap proxy generator.
// 5/22/2016 2:32:44 AM
// 

package com.embarcadero.javaandroid;

import java.util.Date;

public class DSProxy {
  public static class TServerMethods1 extends DSAdmin {
    public TServerMethods1(DSRESTConnection Connection) {
      super(Connection);
    }
    
    
    private DSRESTParameterMetaData[] TServerMethods1_GetClients_Metadata;
    private DSRESTParameterMetaData[] get_TServerMethods1_GetClients_Metadata() {
      if (TServerMethods1_GetClients_Metadata == null) {
        TServerMethods1_GetClients_Metadata = new DSRESTParameterMetaData[]{
          new DSRESTParameterMetaData("", DSRESTParamDirection.ReturnValue, DBXDataTypes.JsonValueType, "TFDJSONDataSets"),
        };
      }
      return TServerMethods1_GetClients_Metadata;
    }

    /**
     * @return result - Type on server: TFDJSONDataSets
     */
    public TJSONObject GetClients() throws DBXException {
      DSRESTCommand cmd = getConnection().CreateCommand();
      cmd.setRequestType(DSHTTPRequestType.GET);
      cmd.setText("TServerMethods1.GetClients");
      cmd.prepare(get_TServerMethods1_GetClients_Metadata());
      getConnection().execute(cmd);
      return (TJSONObject) cmd.getParameter(0).getValue().GetAsJSONValue();
    }
  }

}
