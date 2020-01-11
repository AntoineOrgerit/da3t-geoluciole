package com.univlr.geoluciole.sender;

import android.util.Log;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class HttpSender {

    public static final String METHOD_POST = "POST";
    public static final String METHOD_GET = "GET";

    public static final String TYPE_JSON_APPLICATION = "application/json";

    private String method;
    private Callback callback;
    private String data;
    private String url;
    private String type;

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

    public HttpSender setType(String type) {
        this.type = type;
        return this;
    }

    public HttpSender setUrl(String url) {
        this.url = url;
        return this;
    }

    public HttpSender setData(String data) {
        this.data = data;
        return this;
    }

    public HttpSender setMethod(String method) {
        this.method = method;
        return this;
    }

    public HttpSender setCallback(Callback callback) {
        this.callback = callback;
        return this;
    }

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

    public static void test() {
        String url = "https://86.233.189.163:9200/geolucioles/data/_bulk";
        // String content = "{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\r\n{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\r\n{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\r\n{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\r\n{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\r\n{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\r\n{\"index\": {}}\t\r\n{\"x\": 100,\"y\": 300}\r\n{\"index\": {}}\r\n{\"x\": 300,\"y\": 100}\n";
        String content = "{\"index\": {}}\n{\"x\": 100,\"y\": 300}\n";
        new HttpSender()
                .setUrl(url)
                .setData(content)
                .send();
    }
}
