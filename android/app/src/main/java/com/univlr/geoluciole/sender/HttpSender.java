package com.univlr.geoluciole.sender;

import android.content.Context;
import android.util.Log;

import com.univlr.geoluciole.database.LocationTable;
import com.univlr.geoluciole.model.FormModel;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

/**
 * Classe permettant d'envoyer des données via le protocol HTTP
 */
public class HttpSender {

    public static final String METHOD_POST = "POST";
    public static final String METHOD_GET = "GET";

    public static final String TYPE_JSON_APPLICATION = "application/json";

    // Attributes
    private String method;
    private Callback callback;
    private String data;
    private String url;
    private String type;

    /**
     * Constructor
     */
    public HttpSender() {
        this.method = HttpSender.METHOD_POST;
        this.url = "";
        this.type = HttpSender.TYPE_JSON_APPLICATION;
        this.callback = new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                e.printStackTrace();
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                Log.d("debug http", response.body().string());
                Log.d("debug http", response.message());
                Log.d("debug http", response.toString());
            }
        };
    }

    /**
     * Fixe le content-type de la requête
     * @param type content type de la requête
     * @return L'objet HttpSender
     */
    public HttpSender setType(String type) {
        this.type = type;
        return this;
    }

    /**
     * Fixe l'url de la requête
     * @param url url de la requête
     * @return L'objet HttpSender
     */
    public HttpSender setUrl(String url) {
        this.url = url;
        return this;
    }

    /**
     * Fixe les données à envoyer
     * @param data les données
     * @return L'objet HttpSender
     */
    public HttpSender setData(String data) {
        this.data = data;
        return this;
    }

    /**
     * Fixe la méthode de la requête : GET | POST
     * @param method la méthode
     * @return L'objet HttpSender
     */
    public HttpSender setMethod(String method) {
        this.method = method;
        return this;
    }

    /**
     * Fixe le callback pour la requête
     * @param callback le callback
     * @return L'objet HttpSender
     */
    public HttpSender setCallback(Callback callback) {
        this.callback = callback;
        return this;
    }

    /**
     * Permet d'envoyer la requête en fonction des données fourni
     */
    public void send() {
        OkHttpClient client = new OkHttpClient().newBuilder().build();
        RequestBody body = RequestBody.create(MediaType.parse("application/json"), this.data);
        Request.Builder reqBuilder = new Request.Builder();
        reqBuilder.url(this.url);
        if (this.type != null) {
            reqBuilder.addHeader("content-type", this.type);
        }
        reqBuilder.method(this.method, body);

        okhttp3.Request request = reqBuilder.build();
        try {
            client.newCall(request).enqueue(this.callback);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * Parse la donnée sous format bulk : json\n json\n
     */
    public static String parseDataInBulk(BulkObject bulkObject) {
        List<BulkObject> bulkObjects = new ArrayList<>();
        bulkObjects.add(bulkObject);
        return parseDataInBulk(bulkObjects);
    }

    /**
     * Parse la donnée sous format bulk : json\n json\n
     */
    public static String parseDataInBulk(List<BulkObject> bulkObjects) {
        StringBuilder result = new StringBuilder();
        String index = "{\"index\":{}}\n";
        for(BulkObject bulk : bulkObjects) {
            if (bulk.hasMultipleObject()) {
                List<String> parsed_data = bulk.jsonFormatObject();
                for (String data : parsed_data) {
                    result.append(index);
                    result.append(data);
                    result.append("\n");
                }
            } else {
              result.append(index);
              result.append(bulk.jsonFormat());
              result.append("\n");
            }
        }

        return result.toString();
    }

    public static void test(Context context) {
        //String url = "http://86.233.189.163:9200/geolucioles/data/_bulk";
        String url = "http://datamuseum.univ-lr.fr/geolucioles/data/_bulk";
        // String content = "{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\r\n{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\r\n{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\r\n{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\r\n{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\r\n{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\r\n{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\n";
        String content = HttpSender.parseDataInBulk(new LocationTable(context).getAll());
        new HttpSender()
                .setUrl(url)
                .setData(content)
                .send();
    }

    public static void testForm(FormModel form) {
        //String url = "http://86.233.189.163:9200/geolucioles/data/_bulk";
        String url = "http://datamuseum.univ-lr.fr:80/da3t_formulaire/_doc/_bulk";
        String content = HttpSender.parseDataInBulk(form);
        new HttpSender()
                .setUrl(url)
                .setData(content)
                .send();
    }
}
