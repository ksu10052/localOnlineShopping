<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tag" uri="/WEB-INF/tld/custom_tag.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 목록</title>
<link rel="stylesheet" type="text/css" href="/resources/include/css/common.css" />
<link rel="stylesheet" type="text/css" href="/resources/include/css/member.css" />

<script type="text/javascript" src="/resources/include/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="/resources/include/js/common.js"></script>
<script type="text/javascript">
	$(function() {
		/* 검색 후 검색 대상과 검색 단어 출력 */
		var word = "<c:out value='${data.keyword}' />";
		var value = "";
		if (word != "") {
			$("#keyword").val("<c:out value='${data.keyword}' />");
			$("#search").val("<c:out value='${data.search}' />");

				//:contains()는 특정 텍스트를 포함한 요소반환
				if ($("#search").val() == 'id')
					value = "#list tr td.goDetail";
				else if ($("#search").val() == 'name')
					value = "#list tr td.name";
				$(value + ":contains('" + word + "')").each(
						function() {
							var regex = new RegExp(word, 'gi');
							$(this).html($(this).text().replace(regex,
								"<span class='required'>" + word + "</span>"));
						});
			
		}
		
		/* 한페이지에 보여줄 레코드 수 조회 후 선택한 값 그대로 유지하기 위한 설정 */
		if ("<c:out value='${data.pageSize}' />" != "") {
			$("#pageSize").val("<c:out value='${data.pageSize}' />");
		}

		/* 검색 대상이 변경될 때마다 처리 이벤트 */
		$("#search").change(function() {
			if ($("#search").val() == "all") {
				$("#keyword").val("전체 데이터 조회합니다.");
			} else if ($("#search").val() != "all") {
				$("#keyword").val("");
				$("#keyword").focus();
			}
		});

		/* 검색 버튼 클릭 시 처리 이벤트 */
		$("#searchData").click(function() {
			if ($("#search").val() != "all") {
				if (!chkSubmit($('#keyword'), "검색어를"))
					return;
			}
			goPage(1);
		});


		/* 한 페이지에 보여줄 레코드 수 변경될 때마다 처리 이벤트 */
		$("#pageSize").change(function() {
			goPage(1);
		});

		/* 회원ID 클릭시 상세 페이지 이동을 위한 처리 이벤트 */
		$(".goDetail").click(function() {
			var id = $(this).parents("tr").attr("data-name");
			$("#id").val(id);
			console.log("회원ID : " + id);
			//상세 페이지로 이동하기 위해 form추가 (id : detailForm)
			$("#detailForm").attr({
				"method" : "get",
				"action" : "/admin/member/memberDetail.do"
			});
			$("#detailForm").submit();
		});
	});

	/* 검색과 한 페이지에 보여줄 레코드 수 처리 및 페이징을 위한 실질적인 처리 함수 */
	function goPage(page) {
		if ($("#search").val() == "all") {
			$("#keyword").val("");
		}
		$("#page").val(page);
		$("#m_search").attr({
			"method" : "get",
			"action" : "/admin/member/memberList.do"
		});
		$("#m_search").submit();
	}
</script>
</head>
<body>
	<div class="contentContainer">
		<div class="contentTit">
			<h3>회원 리스트</h3>
		</div>

		<%-- 상세 페이지 이동을 위한 FORM --%>
		<form name="detailForm" id="detailForm">
			<input type="hidden" name="id" id="id"> 
			<input type="hidden" name="page" value="${data.page}"> 
			<input type="hidden" name="pageSize" value="${data.pageSize}">
		</form>

		<%-- 검색기능 시작 --%>
		<div id="memberSearch">
			<form id="m_search" name="m_search">
				<input type="hidden" id="page" name="page" value="${data.page}" />
				<table summary="검색">
					<colgroup>
						<col width="70%"></col>
						<col width="30%"></col>
					</colgroup>
					<tr>
						<td id="btd1">
							<label>검색조건</label> 
							<select id="search" name="search">
								<option value="all">전체</option>
								<option value="name">회원명</option>
								<option value="ID">회원 ID</option>
							</select> 
							<input type="text" name="keyword" id="keyword" value="검색어를 입력하세요." /> 
							<input type="button" value="검색" id="searchData" />
						</td>
						<td id="btd2">한페이지에 <select id="pageSize" name="pageSize">
								<option value="1">1줄</option>
								<option value="2">2줄</option>
								<option value="3">3줄</option>
								<option value="5">5줄</option>
								<option value="7">7줄</option>
								<option value="10">10줄</option>
						</select>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<%-- 검색기능 종료 --%>

		<%-- 리스트 시작 --%>
		<div id="memberList" >
			<table summary="회원 리스트" >
				<colgroup>
					<col width="10%" />
					<col width="20%" />
					<col width="30%" />
					<col width="20%" />
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>아이디</th>
						<th>회원명</th>
						<th>가입일</th>
					</tr>
				</thead>
				<tbody id="list">
					<!-- 데이터 출력 -->
					<c:choose>
						<c:when test="${not empty memberList}">
							<c:forEach var="member" items="${memberList}"
								varStatus="status">
								<tr class="tac" data-name="${member.id}">
									<td class="goDetail">${count - status.index}</td>
									<td class="goDetail">${member.id}</td>
									<td class="goDetail">${member.name}</td>
									<td class="goDetail"><fmt:formatDate value="${member.join_date}" pattern="yyyy.MM.dd"/></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="6" class="tac">회원이 존재하지 않습니다.</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
		<%-- 리스트 종료 --%>
		<%-- 페이지 네비게이션 시작 --%>
		<div id="memberPage">
			<tag:paging page="${param.page}" total="${total}"
				list_size="${data.pageSize}" />
		</div>
		<%-- 페이지 네이게이션 종료 --%>
	</div>
</body>
</html>