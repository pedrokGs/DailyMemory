const Sequelize = require ("sequelize");
const connection = require("./database");

const User = connection.define('users',{
    nome:{
        type: Sequelize.TEXT,
        allowNull: false
    },
    email:{
        type: Sequelize.TEXT,
        allowNull: false
    },
    senha:{
        type: Sequelize.TEXT,
        allowNull: false
    },
})

User.sync({force: false});

module.exports = User;