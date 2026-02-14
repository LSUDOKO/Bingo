const infodiv = document.getElementById("infodiv");
const user_num = document.getElementById("user_num");
const userTurn = document.getElementById("userTurn");
const sidebar = document.getElementById("sidebar");
const chatInput = document.getElementById("chat-input");
let lastStep = 0;

// Automatically detect WebSocket URL based on current page location
// This allows playing from different PCs on the same network
function getWebSocketURL() {
  const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
  const hostname = window.location.hostname;
  const port = window.location.port || (protocol === 'wss:' ? '443' : '8000');
  
  // For localhost, use 127.0.0.1, otherwise use the actual hostname
  const wsHost = hostname === 'localhost' ? '127.0.0.1' : hostname;
  
  return `${protocol}//${wsHost}:${port}/ws/clicked${window.location.pathname}`;
}

const urls = getWebSocketURL();

// Manual override (uncomment and set if needed):
// const urls = "ws://192.168.1.100:8000/ws/clicked" + window.location.pathname; // Replace with server IP

// Production URL (uncomment for production):
// const urls = "wss://bingoboi.herokuapp.com/ws/clicked" + window.location.pathname;
let gamestate = "ON";
const ws = new ReconnectingWebSocket(urls);
const addmearr = [];
const loc_username = localStorage.getItem("username");

let allPlayers = [];
let total_player;
let playerTrack = 0;
let currPlayer;

window.onbeforeunload = function (event) {
 if(gamestate !== "ON") return;
  return "Do you really want to refresh?"
};

ws.onopen = function (e) {
  ws.send(
    JSON.stringify({
      command: "joined",
      info: `${loc_username} just Joined `,
      user: loc_username,
    })
  );
};
function notForMe(data) {
  return data.user !== loc_username;
}

ws.onmessage = function (e) {
  const data = JSON.parse(e.data);
  const command = data.command;

  if (command === "joined") {
    allPlayers = data.all_players;
    total_player = data.users_count;
    // Ensure playerTrack is within bounds
    if (playerTrack >= total_player) {
      playerTrack = 0;
    }
    // Ensure allPlayers array is not empty
    if (allPlayers && allPlayers.length > 0) {
      currPlayer = allPlayers[playerTrack];
      userTurn.textContent =
        currPlayer === loc_username ? "Your " : `${currPlayer}'s`;
    }
    user_num.textContent = data.users_count;
    if (notForMe(data)) {
      infodiv.innerHTML += `
      <div class="side-text">
      <p style="font-size:12px;">${data.info}</p>
      </div>
      `;
    }
    infodiv.scrollTop = infodiv.scrollHeight;
  }
  if (command === "clicked") {
    getLastStep(data.dataset);
    const clickedDiv = document.querySelector(
      `[data-innernum='${data.dataset}']`
    );

    // Turn बदलें - हर valid click के बाद
    checkTurn();
    
    if (notForMe(data)) {
      // दूसरे player का click है
      const myDataSetId = parseInt(clickedDiv.dataset.id);
      if (!addmearr.includes(myDataSetId)) {
        addmearr.push(myDataSetId);
        loopItemsAndCheck();
      }
    }
    clickedDiv.classList.add("clicked");
  }

  if (command === "won") {
    gamestate = "OFF";
    if (notForMe(data)) {
      Swal.fire({
        title: "You Lost",
        html: data.info,
        icon: "error",
        confirmButtonText: "OK",
        customClass: {
          popup: 'horror-alert-popup',
          title: 'horror-alert-title',
          htmlContainer: 'horror-alert-text',
          confirmButton: 'horror-alert-button'
        }
      });
    }
  }

  if (command === "chat") {
    infodiv.innerHTML += `<div class="side-text">
        <p >${data.chat}
        <span class="float-right"> - ${data.user}</span>
        </p>
     </div>
    `;
    infodiv.scrollTop = infodiv.scrollHeight;
  }
};
function checkTurn() {
  if (total_player > 0 && allPlayers && allPlayers.length > 0) {
    playerTrack === total_player - 1 ? (playerTrack = 0) : playerTrack++;
    // Ensure playerTrack is within bounds
    if (playerTrack >= allPlayers.length) {
      playerTrack = 0;
    }
    currPlayer = allPlayers[playerTrack];
    userTurn.textContent =
      currPlayer === loc_username ? "Your " : `${currPlayer}'s`;
  }
}

chatInput.addEventListener("keyup", (e) => {
  if (e.key === 13 || e.key === "Enter") {
    if (!chatInput.value.trim()) {
      return Swal.fire({
        icon: "error",
        title: "Empty Message",
        html: "Your message cannot be empty!",
        toast: true,
        position: "top-right",
        timer: 3000,
        showConfirmButton: false,
        customClass: {
          popup: 'horror-toast-popup'
        }
      });
    }
    ws.send(
      JSON.stringify({
        user: loc_username,
        chat: chatInput.value,
        command: "chat",
      })
    );
    chatInput.value = "";
  }
});

function getLastStep(data) {
  const lastStepDiv = document.getElementById("lastStepDiv");
  lastStepDiv.innerHTML = `<span>Last Step : <span class="prevStep">${data}</span></span>`;
}
