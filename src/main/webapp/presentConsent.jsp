<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<fmt:setBundle basename="eu.eidas.node.package" var="i18n_eng"/>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>
<%@ taglib prefix="token" uri="https://eidas.europa.eu/" %>

<html lang="en">

<head>
    <jsp:include page="htmlHead.jsp"/>
    <title><fmt:message key="consent.page.title" bundle="${i18n_eng}"/></title>
</head>

<body>
<main>
    <div class="wrapper">
        <jsp:include page="centralSlider.jsp"/>
        <jsp:include page="leftColumn.jsp"/>
        <div class="col-right">
            <div class="col-right-inner">
                <div class="clearfix">
                    <div class="menu-top"> <a class="item text-minus" href="#"></a> <a class="item text-plus" href="#"></a> <a class="item contrast" href="#"></a> </div>
                </div>
                <div class="col-right-content">
                    <jsp:include page="content-security-header-deactivated.jsp"/>
                    <form id="consentSelector" name="consentSelector" method="post" action="${e:forHtml(citizenConsentUrl)}">
                        <token:token/>
                        <% /** Slider 1 */ %>
                        <div id="slider1">
                            <jsp:include page="titleWithAssurance.jsp"/>
                            <p class="step-status"><fmt:message key="common.step" bundle="${i18n_eng}"/><span>1</span> | 3</p>
                            <h2 class="sub-title"><fmt:message key="presentConsent.basicInformation" bundle="${i18n_eng}"/></h2>
                            <div class="row"><% /** Mandatory attributes are here */ %>
                                <% /** EIDAS */ %>
                                <c:if test="${eidasAttributes}">
                                    <div class="col-sm-6"> <% /** Natural person */ %>
                                        <c:set var="categoryIsDisplayed" value="false"/>
                                        <c:forEach items="${attrList}" var="attrItem">
                                            <c:if test="${attrItem.required && attrItem.eidasNaturalPersonAttr}">
                                                <c:if test="${categoryIsDisplayed=='false'}">
                                                    <h3><fmt:message key="presentConsent.natural" bundle="${i18n_eng}"/>
                                                        <span><fmt:message key="presentConsent.person" bundle="${i18n_eng}"/></span>
                                                    </h3>
                                                    <c:set var="categoryIsDisplayed" value="true"/>
                                                    <ul class="list-unstyled check">
                                                </c:if>
                                                <li>
                                                    <fmt:message var="displayAttr" key="${attrItem.name}.display" bundle="${i18n_eng}"/>
                                                    <c:if test="${!fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
                                                        <fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/>
                                                    </c:if>
                                                    <input id="consentSelector_${attrItem.name}" type="hidden" name="${attrItem.name}" value="${attrItem.name}"/>
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${categoryIsDisplayed=='true'}"></ul></c:if>
                                    </div>
                                    <div class="col-sm-6"> <% /** Legal person */ %>
                                        <c:set var="categoryIsDisplayed" value="false"/>
                                        <c:forEach items="${attrList}" var="attrItem">
                                            <c:if test="${attrItem.required && attrItem.eidasLegalPersonAttr}">
                                                <c:if test="${categoryIsDisplayed=='false'}">
                                                    <h3><fmt:message key="presentConsent.legal" bundle="${i18n_eng}"/>
                                                        <span><fmt:message key="presentConsent.person" bundle="${i18n_eng}"/></span>
                                                    </h3>
                                                    <c:set var="categoryIsDisplayed" value="true"/>
                                                    <ul class="list-unstyled check">
                                                </c:if>
                                                <li>
                                                    <fmt:message var="displayAttr" key="${attrItem.name}.display" bundle="${i18n_eng}"/>
                                                    <c:if test="${!fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
                                                        <fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/>
                                                        <%--<label class="checkboxLabel" for="consentSelector_${attrItem.name}"><fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/></label>--%>
                                                        <input id="consentSelector_${attrItem.name}" type="hidden" name="${attrItem.name}" value="${attrItem.name}"/>
                                                    </c:if>
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${categoryIsDisplayed=='true'}"></ul></c:if>
                                    </div>
                                </c:if>
                                <% /** STORK */ %>
                                <c:if test="${!eidasAttributes}">
                                    <div class="col-sm-6 one-column">
                                        <ul class="list-unstyled check">
                                            <c:forEach items="${attrList}" var="attrItem">
                                                <c:if test="${attrItem.required}">
													    <fmt:message var="displayAttr" key="${attrItem.name}.display" bundle="${i18n_eng}"/>
                                                        <c:if test="${!fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
														<li class="attr_stork_li_slider1">
                                                            <fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/>
														</li>
                                                        </c:if>
                                                        <input id="consentSelector_${attrItem.name}" type="hidden" name="${attrItem.name}" value="${attrItem.name}"/>
                                                </c:if>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                    <div id="noDataDiv_slider1" class="col-sm-6 one-column">
                                        <h3><fmt:message key="presentConsent.your" bundle="${i18n_eng}"/>
                                            <span><fmt:message key="presentConsent.serviceProvider" bundle="${i18n_eng}"/></span>
                                            <fmt:message key="presentConsent.doesntRequest" bundle="${i18n_eng}"/>
                                            <span><fmt:message key="presentConsent.mandatory" bundle="${i18n_eng}"/></span>
                                            <fmt:message key="presentConsent.information" bundle="${i18n_eng}"/>
                                        </h3>
                                    </div>
                                </c:if>
                            </div>
                            <p class="box-btn">
                                <button type="button" class="btn btn-opposite" id="buttonCancelSlide1" name="buttonCancelSlide1"><span><fmt:message key="common.cancel" bundle="${i18n_eng}"/></span></button>
                                <button type="button" class="btn btn-next" id="buttonNextSlide1" name="buttonNextSlide1"><span><fmt:message key="common.next" bundle="${i18n_eng}"/></span></button>
                            </p>
                            <jsp:include page="footer-img.jsp"/>
                        </div>
                        <% /** Slider 2 */ %>
                        <div id="slider2">
                            <jsp:include page="titleWithAssurance.jsp"/>
                            <p class="step-status"><fmt:message key="common.step" bundle="${i18n_eng}"/> <span>2</span> | 3</p>
                            <h2 class="sub-title"><fmt:message key="presentConsent.additionalInformation" bundle="${i18n_eng}"/></h2>
                            <div class="row"> <% /** optional  attributes are here */ %>
                                <% /** EIDAS */ %>
                                <c:if test="${eidasAttributes}">
                                    <div class="col-sm-6"> <% /** Natural person */ %>
                                        <c:set var="categoryIsDisplayed" value="false"/>
                                        <c:forEach items="${attrList}" var="attrItem">
                                            <c:if test="${!attrItem.required && attrItem.eidasNaturalPersonAttr}">
                                                <c:if test="${categoryIsDisplayed=='false'}">
                                                    <h3><fmt:message key="presentConsent.natural" bundle="${i18n_eng}"/>
                                                        <span><fmt:message key="presentConsent.person" bundle="${i18n_eng}"/></span>
                                                    </h3>
                                                    <c:set var="categoryIsDisplayed" value="true"/>
                                                    <ul class="toogle-switch list-unstyled">
                                                </c:if>
                                                <li>
                                                    <c:if test="${fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
                                                        <input id="consentSelector_${attrItem.name}" type="hidden" name="${attrItem.name}" value="${attrItem.name}"/>
                                                    </c:if>
                                                    <c:if test="${!fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
                                                        <p><fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/></p>
                                                        <input class="js-switch" id="consentSelector_${attrItem.name}" type="checkbox" name="${attrItem.name}" value="true"/>
                                                        <input id="__checkbox_consentSelector_${attrItem.name}" type="hidden" name="__checkbox_${attrItem.name}" value="true"/>
                                                    </c:if>
                                                </li>
                                            </c:if>
                                            </c:forEach>
                                            <c:if test="${categoryIsDisplayed=='true'}"></ul></c:if>
                                    </div>
                                    <div class="col-sm-6"> <% /** Legal person */ %>
                                        <c:set var="categoryIsDisplayed" value="false"/>
                                        <c:forEach items="${attrList}" var="attrItem">
                                            <c:if test="${!attrItem.required && attrItem.eidasLegalPersonAttr}">
                                                <c:if test="${categoryIsDisplayed=='false'}">
                                                    <h3><fmt:message key="presentConsent.legal" bundle="${i18n_eng}"/>
                                                        <span><fmt:message key="presentConsent.person" bundle="${i18n_eng}"/></span>
                                                    </h3>
                                                    <c:set var="categoryIsDisplayed" value="true"/>
                                                    <ul class="toogle-switch list-unstyled">
                                                </c:if>
                                                <li>
                                                    <c:if test="${fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
                                                        <input id="consentSelector_${attrItem.name}" type="hidden" name="${attrItem.name}" value="${attrItem.name}"/>
                                                    </c:if>
                                                    <c:if test="${!fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
                                                        <p><fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/></p>
                                                        <input class="js-switch" id="consentSelector_${attrItem.name}" type="checkbox" name="${attrItem.name}" value="true"/>
                                                        <input id="__checkbox_consentSelector_${attrItem.name}" type="hidden" name="__checkbox_${attrItem.name}" value="true"/>
                                                    </c:if>
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${categoryIsDisplayed=='true'}"></ul></c:if>
                                    </div>
                                </c:if>
                                <% /** STORK */ %>
                                <c:if test="${!eidasAttributes}">
                                    <div class="col-sm-6 one-column">
                                        <ul class="toogle-switch list-unstyled">
                                            <c:forEach items="${attrList}" var="attrItem">
												<fmt:message var="displayAttr" key="${attrItem.name}.display" bundle="${i18n_eng}"/>
                                                <c:if test="${!attrItem.required}">
													<c:if test="${fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
														<input id="consentSelector_${attrItem.name}" type="hidden" name="${attrItem.name}" value="${attrItem.name}"/>
													</c:if>
													<c:if test="${!fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
														<li class="attr_stork_li_slider2">
																<p><fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/></p>
																<input class="js-switch" id="consentSelector_${attrItem.name}" type="checkbox" name="${attrItem.name}" value="true"/>
																<input id="__checkbox_consentSelector_${attrItem.name}" type="hidden" name="__checkbox_${attrItem.name}" value="true"/>
														</li>
													</c:if>
                                                </c:if>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                    <div id="noDataDiv_slider2" class="col-sm-6 one-column">
                                        <h3><fmt:message key="presentConsent.your" bundle="${i18n_eng}"/>
                                            <span><fmt:message key="presentConsent.serviceProvider" bundle="${i18n_eng}"/></span>
                                            <fmt:message key="presentConsent.doesntRequest" bundle="${i18n_eng}"/>
                                            <span><fmt:message key="presentConsent.optional" bundle="${i18n_eng}"/></span>
                                            <fmt:message key="presentConsent.information" bundle="${i18n_eng}"/>
                                        </h3>
                                    </div>
                                </c:if>
                            </div>
                            <div id="checkbox_Confirmation_div"class="checkbox checkbox-custom">
                                <p class="information-message"><fmt:message key="presentConsent.deniedConfirmation" bundle="${i18n_eng}"/></p>
                            </div>
                            <p class="box-btn">
                                <button type="button" class="btn btn-opposite" id="buttonCancelSlide2" name="buttonCancelSlide2"><span><fmt:message key="common.cancel" bundle="${i18n_eng}"/></span></button>
                                <button type="button" class="btn btn-back" id="buttonBackSlide2" name="buttonBackSlide2"><span><fmt:message key="common.back" bundle="${i18n_eng}"/></span></button>
                                <button type="button" class="btn btn-next" id="buttonNextSlide2" name="buttonNextSlide2"><span><fmt:message key="common.next" bundle="${i18n_eng}"/></span></button>
                            </p>
                            <jsp:include page="footer-img.jsp"/>
                        </div>
                    </form>
                    <form id="cancelForm" name="cancelForm" method="post" action="${e:forHtml(redirectUrl)}">
                        <input type="hidden" id="SAMLResponse" name="SAMLResponse" value="<c:out value='${e:forHtml(samlTokenFail)}'/>"/>
                        <token:token/>
                    </form>
                    <noscript>
                        <span id="mergedSlider">
                            <div class="row">
								<form id="consentSelectornojs" name="consentSelectornojs" method="post" action="${e:forHtml(citizenConsentUrl)}">
									<token:token/>
									<div id="slider3">
                                        <h1 class="title">
                                            <c:out value="${e:forHtml(spId)}"/>
                                            <c:if test="${eidasAttributes}">
                                                 <span><fmt:message key="presentConsent.levelOfAssurance" bundle="${i18n_eng}"/>
                                                <c:out value="${e:forHtml(LoA)}"/></span>
                                            </c:if>
                                            <c:if test="${!eidasAttributes}">
                                                <span><fmt:message key="presentConsent.qualityOfAssurance" bundle="${i18n_eng}"/>
                                                <c:out value="${e:forHtml(qaaLevel)}"/></span>
                                            </c:if>
                                            <fmt:message key="presentConsent.isRequesting" bundle="${i18n_eng}"/>
                                        </h1>
										<div class="step-number">1</div>
										<h2 class="sub-title"><fmt:message key="presentConsent.basicInformation" bundle="${i18n_eng}"/></h2>
										<div class="row"><% /** Mandatory attributes are here */ %>
											<% /** EIDAS */ %>
											<c:if test="${eidasAttributes}">
												<div class="col-sm-6"> <% /** Natural person */ %>
													<c:set var="categoryIsDisplayed" value="false"/>
													<c:forEach items="${attrList}" var="attrItem">
														<c:if test="${attrItem.required && attrItem.eidasNaturalPersonAttr}">
															<c:if test="${categoryIsDisplayed=='false'}">
																<h3><fmt:message key="presentConsent.natural" bundle="${i18n_eng}"/>
																	<span><fmt:message key="presentConsent.person" bundle="${i18n_eng}"/></span>
																</h3>
																<c:set var="categoryIsDisplayed" value="true"/>
																<ul class="list-unstyled check">
															</c:if>
															<li>
																<fmt:message var="displayAttr" key="${attrItem.name}.display" bundle="${i18n_eng}"/>
																<c:if test="${!fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
                                                                    <fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/>
																</c:if>
																<input id="consentSelector_${attrItem.name}" type="hidden" name="${attrItem.name}" value="${attrItem.name}"/>
															</li>
														</c:if>
													</c:forEach>
													<c:if test="${categoryIsDisplayed=='true'}"></ul></c:if>
												</div>
												<div class="col-sm-6"> <% /** Legal person */ %>
													<c:set var="categoryIsDisplayed" value="false"/>
													<c:forEach items="${attrList}" var="attrItem">
														<c:if test="${attrItem.required && attrItem.eidasLegalPersonAttr}">
															<c:if test="${categoryIsDisplayed=='false'}">
																<h3><fmt:message key="presentConsent.legal" bundle="${i18n_eng}"/>
																	<span><fmt:message key="presentConsent.person" bundle="${i18n_eng}"/></span>
																</h3>
																<c:set var="categoryIsDisplayed" value="true"/>
																<ul class="list-unstyled check">
															</c:if>
															<li>
																<fmt:message var="displayAttr" key="${attrItem.name}.display" bundle="${i18n_eng}"/>
																<c:if test="${!fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
                                                                    <fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/>
																	<input id="consentSelector_${attrItem.name}" type="hidden" name="${attrItem.name}" value="${attrItem.name}"/>
																</c:if>
															</li>
														</c:if>
													</c:forEach>
													<c:if test="${categoryIsDisplayed=='true'}"></ul></c:if>
												</div>
											</c:if>
											<% /** STORK */ %>
											<c:if test="${!eidasAttributes}">
												<div class="col-sm-6 one-column">
													<ul class="list-unstyled check">
														<c:forEach items="${attrList}" var="attrItem">
															<c:if test="${attrItem.required}">
                                                                <fmt:message var="displayAttr" key="${attrItem.name}.display" bundle="${i18n_eng}"/>
                                                                <c:if test="${!fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
																<li class="attr_stork_li_slider1">
                                                                    <fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/>
                                                                    <%--<label class="checkboxLabel" for="consentSelector_${attrItem.name}"><fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/></label>--%>
																</li>
                                                                </c:if>
                                                                <input id="consentSelector_${attrItem.name}" type="hidden" name="${attrItem.name}" value="${attrItem.name}"/>
															</c:if>
														</c:forEach>
													</ul>
												</div>
											</c:if>
										</div>
									</div>
									<div id="slider4">
										<h2 class="sub-title"><fmt:message key="presentConsent.additionalInformation" bundle="${i18n_eng}"/></h2>
										<div class="row"> <% /** optional  attributes are here */ %>
											<% /** EIDAS */ %>
											<c:if test="${eidasAttributes}">
												<div class="col-sm-6"> <% /** Natural person */ %>
													<c:set var="categoryIsDisplayed" value="false"/>
													<c:forEach items="${attrList}" var="attrItem">
														<c:if test="${!attrItem.required && attrItem.eidasNaturalPersonAttr}">
															<c:if test="${categoryIsDisplayed=='false'}">
																<h3><fmt:message key="presentConsent.natural" bundle="${i18n_eng}"/>
																	<span><fmt:message key="presentConsent.person" bundle="${i18n_eng}"/></span>
																</h3>
																<c:set var="categoryIsDisplayed" value="true"/>
																<ul class="toogle-switch list-unstyled">
															</c:if>
															<li>
																<c:if test="${fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
																	<input id="consentSelector_${attrItem.name}" type="hidden" name="${attrItem.name}" value="${attrItem.name}"/>
																</c:if>
																<c:if test="${!fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
																	<p><fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/></p>
																	<input class="js-switch" id="consentSelector_${attrItem.name}" type="checkbox" name="${attrItem.name}" value="true"/>
																	<input id="__checkbox_consentSelector_${attrItem.name}" type="hidden" name="__checkbox_${attrItem.name}" value="true"/>
																</c:if>
															</li>
														</c:if>
														</c:forEach>
														<c:if test="${categoryIsDisplayed=='true'}"></ul></c:if>
												</div>
												<div class="col-sm-6"> <% /** Legal person */ %>
													<c:set var="categoryIsDisplayed" value="false"/>
													<c:forEach items="${attrList}" var="attrItem">
														<c:if test="${!attrItem.required && attrItem.eidasLegalPersonAttr}">
															<c:if test="${categoryIsDisplayed=='false'}">
																<h3><fmt:message key="presentConsent.legal" bundle="${i18n_eng}"/>
																	<span><fmt:message key="presentConsent.person" bundle="${i18n_eng}"/></span>
																</h3>
																<c:set var="categoryIsDisplayed" value="true"/>
																<ul class="toogle-switch list-unstyled">
															</c:if>
															<li>
																<c:if test="${fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
																	<input id="consentSelector_${attrItem.name}" type="hidden" name="${attrItem.name}" value="${attrItem.name}"/>
																</c:if>
																<c:if test="${!fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
																	<p><fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/></p>
																	<input class="js-switch" id="consentSelector_${attrItem.name}" type="checkbox" name="${attrItem.name}" value="true"/>
																	<input id="__checkbox_consentSelector_${attrItem.name}" type="hidden" name="__checkbox_${attrItem.name}" value="true"/>
																</c:if>
															</li>
														</c:if>
													</c:forEach>
													<c:if test="${categoryIsDisplayed=='true'}"></ul></c:if>
												</div>
											</c:if>
											<% /** STORK */ %>
											<c:if test="${!eidasAttributes}">
												<div class="col-sm-6 one-column">
													<ul class="toogle-switch list-unstyled">
														<c:forEach items="${attrList}" var="attrItem">
                                                            <fmt:message var="displayAttr" key="${attrItem.name}.display" bundle="${i18n_eng}"/>
															<c:if test="${!attrItem.required}">
                                                                <c:if test="${fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
                                                                    <input id="consentSelector_${attrItem.name}" type="hidden" name="${attrItem.name}" value="${attrItem.name}"/>
                                                                </c:if>
                                                                <c:if test="${!fn:startsWith(fn:toLowerCase(displayAttr), 'false')}">
                                                                    <li class="attr_stork_li_slider2">
                                                                            <p><fmt:message key="${attrItem.name}" bundle="${i18n_eng}"/></p>
                                                                            <input class="js-switch" id="consentSelector_${attrItem.name}" type="checkbox" name="${attrItem.name}" value="true"/>
                                                                            <input id="__checkbox_consentSelector_${attrItem.name}" type="hidden" name="__checkbox_${attrItem.name}" value="true"/>
                                                                    </li>
                                                                </c:if>
															</c:if>
														</c:forEach>
													</ul>
												</div>
												<div id="noDataDiv_slider2" class="col-sm-6 one-column">
													<h3><fmt:message key="presentConsent.your" bundle="${i18n_eng}"/>
														<span><fmt:message key="presentConsent.serviceProvider" bundle="${i18n_eng}"/></span>
														<fmt:message key="presentConsent.doesntRequest" bundle="${i18n_eng}"/>
														<span><fmt:message key="presentConsent.optional" bundle="${i18n_eng}"/></span>
														<fmt:message key="presentConsent.information" bundle="${i18n_eng}"/>
													</h3>
												</div>
											</c:if>
										</div>
										<div id="checkbox_Confirmation_div2"class="checkbox checkbox-custom">
											<p class="information-message"><fmt:message key="presentConsent.deniedConfirmation" bundle="${i18n_eng}"/></p>
										</div>
										<p class="step-status"><fmt:message key="common.step" bundle="${i18n_eng}"/> <span>1</span> | 2</p>
										<p class="box-btn">
											<button type="submit" class="btn btn-next" id="buttonNextNoScript" name="buttonNextNoScript"><span>Next</span></button>
										</p>
									</div>
								</form>
								<form id="cancelForm2" name="cancelForm" method="post" action="${e:forHtml(redirectUrl)}">
									<input type="hidden" id="SAMLResponse" name="SAMLResponse" value="<c:out value='${e:forHtml(samlTokenFail)}'/>"/>
									<token:token/>
                                    <p class="box-btn">
                                        <button type="submit" class="btn btn-opposite" id="buttonCancelNoScript" name="buttonCancelNoScript"><span>Cancel</span></button>
                                    </p>
                                    <jsp:include page="footer-img.jsp"/>
                                </form>
							
							</div>
                        </span>
                    </noscript>
                </div>
            </div>
        </div>
    </div>
</main>
<jsp:include page="helpPages/modal_loa.jsp"/>
<jsp:include page="footerScripts.jsp"/>
<script type="text/javascript" src="js/presentConsent.js"></script>
<script type="text/javascript" src="js/autocompleteOff.js"></script>
</body>
</html>
