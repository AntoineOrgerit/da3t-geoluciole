package com.univlr.geoluciole;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

import androidx.test.core.app.ApplicationProvider;
import androidx.test.platform.app.InstrumentationRegistry;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import com.univlr.geoluciole.db.dao.LocationDAO;
import com.univlr.geoluciole.model.Location;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.io.IOException;
import java.util.List;

import static org.junit.Assert.*;

/**
 * Instrumented test, which will execute on an Android device.
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
@RunWith(AndroidJUnit4.class)
public class DatabaseTest {
    private LocationDAO ldao;

    @Test
    public void useAppContext() {
        // Context of the app under test.
        Context appContext = InstrumentationRegistry.getInstrumentation().getTargetContext();
        assertEquals("com.univlr.geoluciole", appContext.getPackageName());
    }

    @Before
    public void createDb() {
        ldao = new LocationDAO(InstrumentationRegistry.getInstrumentation().getTargetContext());
        ldao.open();
        ldao.removeAll();
    }

    @After
    public void closeDb() throws IOException {
        ldao.close();
    }

    @Test
    public void writeLocationAndReadInList() throws Exception {
        Location location = new Location(1.1,2.1,123,1.1,0);
        ldao.addLocation(location);
        List<Location> list = ldao.getAll();
        assertEquals(list.get(0).toString(),location.toString());
    }

    @Test
    public void deleteAllLocation() throws Exception{
        Location location = new Location(1.1,2.1,123,1.1,0);
        ldao.addLocation(location);
        ldao.removeAll();
        List<Location> list = ldao.getAll();
        assertEquals(list.isEmpty(), true);
    }

}
