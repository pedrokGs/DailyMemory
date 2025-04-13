const express = require("express");
const app = express();
const connection = require("./database/database");
const { where } = require("sequelize");
const User = require("./database/User");
const Compromisso = require("./database/Compromisso");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

app.use(express.json());

connection
    .authenticate()
    .then(() => {
        console.log("Conexão bom BD feita com sucesso!")
    })
    .catch((msgErro) => {
        console.log(msgErro);
    })


    app.post("/cadastrarUser", async (req, res) => {
        try {
            const { nome, email, senha } = req.body;
    
            // Hash da senha
            const senhaHash = await bcrypt.hash(senha, 10); // 10 é o número de "salt rounds"
    
            const novoUsuario = await User.create({
                nome,
                email,
                senha: senhaHash, // Armazenando a senha hash no banco de dados
            });
    
            res.status(201).json({ message: "Usuário criado com sucesso!", usuario: novoUsuario });
        } catch (error) {
            console.error(error);
            res.status(500).json({ error: "Erro ao cadastrar usuário" });
        }
    });

app.post("/cadastrarCompromisso", (req, res) => {
        var titulo = req.body.titulo;
        var descricao = req.body.descricao;
        var data = req.body.data;

        Compromisso.create({
            titulo: titulo,
            descricao: descricao,
            data: data,
        }).then(() => {
            res.status(201).json({ message: "Compromisso criado com sucesso!" });
        }).catch((error) => {
            console.error(error);
            res.status(500).json({ error: "Erro ao cadastrar compromisso" });
        });
});

app.get("/compromissos", async (req, res) => {
    try {
        const compromissos = await Compromisso.findAll();
        res.status(200).json(compromissos);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Erro ao buscar compromissos" });
    }
});

app.put("/compromissos/:id", async (req, res) => {
    const { id } = req.params;
    const { titulo, descricao, data } = req.body;

    try {
        await Compromisso.update(
            { titulo, descricao, data },
            { where: { id } }
        );
        res.status(200).json({ message: "Compromisso atualizado com sucesso!" });
    } catch (error) {
        res.status(500).json({ error: "Erro ao atualizar compromisso" });
    }
});

app.delete("/compromissos/:id", async (req, res) => {
    const { id } = req.params;

    try {
        const resultado = await Compromisso.destroy({ where: { id } });

        if (resultado === 0) {
            return res.status(404).json({ error: "Compromisso não encontrado" });
        }

        res.status(200).json({ message: "Compromisso excluído com sucesso!" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Erro ao excluir compromisso" });
    }
});

app.post("/loginUser", async (req, res) => {
    const { email, senha } = req.body;

    try {
        const usuario = await User.findOne({ where: { email } });

        if (!usuario) {
            return res.status(404).json({ error: "Usuário não encontrado" });
        }

        const senhaValida = await bcrypt.compare(senha, usuario.senha);
        if (!senhaValida) {
            return res.status(401).json({ error: "Senha incorreta" });
        }

        const token = jwt.sign(
            { id: usuario.id, nome: usuario.nome, email: usuario.email },
            "seuSegredoAqui",
            { expiresIn: "1h" }
        );

        res.status(200).json({
            message: "Login bem-sucedido",
            token: token,
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Erro ao fazer login" });
    }
});

app.listen(4000, () => { console.log("App rodando!"); });