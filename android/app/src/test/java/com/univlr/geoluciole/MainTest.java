package com.univlr.geoluciole;

import com.univlr.geoluciole.model.Location;

import org.json.JSONException;
import org.junit.Test;
import org.skyscreamer.jsonassert.JSONAssert;

import static org.junit.Assert.*;

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
public class MainTest {
    @Test
    public void addition_isCorrect() {
        assertEquals(4, 2 + 2);
    }

    @Test
    public void checkJSONFormat() throws JSONException {
        Location l = new Location(55.55, 44.77, 12345, 99.88, 0);
        String expected = "{\"latitude\":55.55,\"longitude\":44.77,\"timestamp\":12345,\"altitude\":99.88,\"isSync\":0}";
        JSONAssert.assertEquals(expected, l.parseToJson(),false);
    }

}