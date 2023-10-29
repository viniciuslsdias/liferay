import {Request, Response} from "express";

export async function healthcheck(request: Request, response: Response) {

	const healthcheck = {
		uptime: process.uptime(),
		message: 'OK',
		timestamp: Date.now()
	};
	try {
		response.send(healthcheck);
	} catch (e) {
		healthcheck.message = e;
		response.status(503).send();
	}
}