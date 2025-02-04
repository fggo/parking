package com.parking.board.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class QnaBoardWriteServlet
 */
@WebServlet("/board/qnaboardWrite")
public class QnaBoardWriteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QnaBoardWriteServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//	  qna_no NUMBER(5) NOT NULL,
//	  qna_title VARCHAR2(50) NOT NULL,
//	  qna_user_code CHAR(6) NOT NULL,
//	  qna_content VARCHAR2(300) NOT NULL,
//	  qna_original_filename VARCHAR2(100),
//	  qna_renamed_filename VARCHAR2(100),
//	  qna_created_date DATE DEFAULT SYSDATE,
//	  qna_readcount NUMBER DEFAULT 0

	  request.getRequestDispatcher("/views/board/qnaBoardWrite.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
