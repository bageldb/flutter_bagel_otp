

require('dotenv').config();
import express from 'express';
import cors from 'cors';
import { db } from './bageldb';

const app = express();
app.use(express.json());
app.use(cors(
	{
		origin: '*',
	}
));

app
	.post(
		'/updateUserPassword',
		async (req, res) => {
			console.log('req.body', req);

			const { emailOrPhone, password } = req.body;

			await db
				.users()
				.updatePassword(
					emailOrPhone,
					password
				)

			res.send({ status: 'ok' })
		}
	)

const PORT = process.env.PORT || 80
app.listen(
	PORT,
	() => console.log(`Working on port ${PORT}`)
);

