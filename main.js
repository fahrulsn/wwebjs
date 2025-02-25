const { Client } = require("whatsapp-web.js");
const qrcode = require("qrcode-terminal");
const axios = require("axios");
require("dotenv").config();

const client = new Client();

client.on("ready", () => {
  console.log("Client is ready!");
});

client.on("qr", (qr) => {
  qrcode.generate(qr, { small: true });
});

let isOtw = false;

client.on("message_create", async (message) => {
  try {
    const messageText = message.body.toLowerCase();

    // Memastikan bahwa pesan sudah siap sebelum menangani
    if (!message.fromMe) {
      if (isOtw) {
        message.reply(
          "Sedang dalam perjalanan, akan segera membalas setelah tiba. :)"
        );
        return;
      }
    }

    // Jika bukan dalam mode perjalanan, lakukan tindakan biasa
    if (messageText === "!ping") {
      message.reply("pong");
    }

    // Tangani perubahan mode
    if (messageText === "!otw") {
      isOtw = true;
      message.reply("Mode OTW telah diaktifkan.");
    } else if (messageText === "!normal") {
      isOtw = false;
      message.reply("Mode Normal telah diaktifkan.");
    }

    // Jika pesan diawali dengan #ai, teruskan ke API AI
    if (messageText.startsWith("#ai")) {
      const aiQuery = message.body.slice(4).trim();
      if (!aiQuery) {
        message.reply("Silakan masukkan pertanyaan setelah #ai");
        return;
      }

      try {
        const response = await axios.post(
          process.env.API_URL,
          {
            model: process.env.L_MODEL,
            messages: [{ role: "user", content: aiQuery }],
            include_reasoning: true,
          },
          {
            headers: { Authorization: `Bearer ${process.env.API_TOKEN}` },
          }
        );
        const aiResponse = response.data?.choices?.[0]?.message?.content ?? "";
        if (aiResponse) {
          message.reply(aiResponse);
        } else {
          message.reply("Maaf, tidak dapat memperoleh jawaban.");
        }
      } catch (error) {
        console.error("Error saat menghubungi API AI:", error);
        message.reply("Terjadi kesalahan saat memproses permintaan.");
      }
    }
  } catch (error) {
    console.error("Error saat membalas pesan:", error);
  }
});

client.initialize();
