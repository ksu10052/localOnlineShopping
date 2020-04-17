package com.juji.client.delivery.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.juji.client.delivery.dao.DeliveryDao;
import com.juji.client.delivery.vo.DeliveryVO;

@Service
@Transactional
public class DeliveryServiceImpl implements DeliveryService {

	@Autowired
	DeliveryDao dao;
	
	@Override
	public List<DeliveryVO> listDelivery(String id) {
		
		return dao.listDelivery(id);
	}

}
