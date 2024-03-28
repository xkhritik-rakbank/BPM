package com.newgen.iforms.user;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;

import org.joda.time.LocalDateTime;

public class test {

	public static void main(String[] args) throws ParseException {
		// TODO Auto-generated method stub
		String dateString = "13/03/2024 14:23";
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		Date date = sdf.parse(dateString);
		LocalDate local = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
		System.out.println(local);
		
		LocalDate yesterdayDate = LocalDate.now().minusDays(1);
		LocalDate currentDate = LocalDate.now();
		
		System.out.println(yesterdayDate);
		System.out.println(currentDate);
	
		if(yesterdayDate.compareTo(local)==0){
			System.out.println("true");
		}
		
		
	}

}
