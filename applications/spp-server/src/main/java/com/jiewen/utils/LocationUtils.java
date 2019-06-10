package com.jiewen.utils;

public class LocationUtils {
	
	    private static final Double PI = Math.PI;  
	  
	    private static final Double PK = 180 / PI;  
	      
	    /** 
	     * @param lat_a 
	     * @param lng_a 
	     * @param lat_b 
	     * @param lng_b 
	     * @param @return    
	     * @return double 
	     */  
	    public static double getDistance(double lat_a, double lng_a, double lat_b, double lng_b) {  
	        double t1 = Math.cos(lat_a / PK) * Math.cos(lng_a / PK) * Math.cos(lat_b / PK) * Math.cos(lng_b / PK);  
	        double t2 = Math.cos(lat_a / PK) * Math.sin(lng_a / PK) * Math.cos(lat_b / PK) * Math.sin(lng_b / PK);  
	        double t3 = Math.sin(lat_a / PK) * Math.sin(lat_b / PK);  
	  
	        double tt = Math.acos(t1 + t2 + t3);  
	        return 6366000 * tt;  
	    }  
    
}

