import Bagel from '@bageldb/bagel-db';

const bagelOptions = {
	isServer: true, // ? short circuit when trying to use localstorage on server which doesn't exist
	enableDebug: true,
};

export const db = new Bagel(process.env?.BAGEL_TOKEN || '', bagelOptions);