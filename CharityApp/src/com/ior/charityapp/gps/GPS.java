package com.ior.charityapp.gps;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.location.GpsStatus.Listener;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import static com.ior.charityappior.Utils.log;

import com.ior.charityappior.Request;

public class GPS extends Service implements Listener, LocationListener {

	private long lastUpdated = 0;
	private LocationManager lm;

	@Override
	public void onCreate() {
		super.onCreate();

		lm = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
		lm.addGpsStatusListener(this);

		lm.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, this);
		lm.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0,
				this);
	}

	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}

	@Override
	public void onGpsStatusChanged(int event) {
	}

	@Override
	public void onLocationChanged(final Location location) {
		
		log("Latitude === ", String.valueOf(location.getLatitude()));
		log("Longitude ==== ", String.valueOf(location.getLongitude()));
		
		if (location.getTime() >= lastUpdated) {
			lastUpdated = location.getTime();

			// handle new location
			final double lat = location.getLatitude();
			final double lng = location.getLongitude();

			Thread th = new Thread() {
				public void run() {
					try {
						Request.updateCoordinates(GPS.this, location);
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				}
			};
			th.start();
		}
		
	}

	@Override
	public void onProviderDisabled(String provider) {
	}

	@Override
	public void onProviderEnabled(String provider) {
	}

	@Override
	public void onStatusChanged(String provider, int status, Bundle extras) {
	}

	@Override
	public void onDestroy() {
		super.onDestroy();
		try {
			lm.removeUpdates(this);

			// recall this service
			startService(new Intent(this, GPS.class));
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}
