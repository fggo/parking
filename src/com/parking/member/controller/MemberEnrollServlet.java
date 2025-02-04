package com.parking.member.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class MemberEnrollServlet
 */
@WebServlet("/memberEnroll")
public class MemberEnrollServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberEnrollServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("userEmail");
		String snsAccount = request.getParameter("snsAccount");
//		  System.out.println("userEmail : "+email);
		  
		  if(email !=null)
		  {
			  request.setAttribute("userEmail", email);
			  request.setAttribute("snsAccount", snsAccount);
			  request.getRequestDispatcher("/views/member/memberEnroll.jsp").forward(request, response);
//			  System.out.println("userEmail : "+email);
//			  System.out.println("snsAccount : "+snsAccount);
		  }else
		  {
			  response.sendRedirect(request.getContextPath() + "/views/member/memberEnroll.jsp");	  
		  }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
