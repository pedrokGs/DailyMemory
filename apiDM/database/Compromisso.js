const Sequelize = require ("sequelize");
const connection = require("./database");

const Compromisso = connection.define('compromissos',{
    titulo:{
        type: Sequelize.TEXT,
        allowNull: false
    },
    descricao:{
        type: Sequelize.TEXT,
        allowNull: false
    },
    data:{
        type: Sequelize.DATE,
        allowNull: false
    },
})

Compromisso.sync({force: false});

module.exports = Compromisso;