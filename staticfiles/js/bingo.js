var grid = document.querySelector(".grid");
const items = [...document.querySelector(".grid").children];
const bingodiv = document.querySelector("#bingodiv");
let keysArr = [];
window.onload = () => {
  restart();
};

//all possible combination for bingo
const bingoItems = [
  [1, 2, 3, 4, 5],
  [6, 7, 8, 9, 10],
  [11, 12, 13, 14, 15],
  [16, 17, 18, 19, 20],
  [21, 22, 23, 24, 25],
  [1, 7, 13, 19, 25],
  [1, 6, 11, 16, 21],
  [2, 7, 12, 17, 22],
  [3, 8, 13, 18, 23],
  [4, 9, 14, 19, 24],
  [5, 10, 15, 20, 25],
  [5, 9, 13, 17, 21],
];

function GetRandomArray() {
  keysArr = [];
  for (let i = 1; i < 26; i++) {
    b = Math.ceil(Math.random() * 25);
    if (!keysArr.includes(b)) {
      keysArr.push(b);
    } else {
      i--;
    }
  }
}

const includesAll = (arr, values) => values.every((v) => arr.includes(v));

const bingoState = ["B", "I", "N", "G", "O"];

let bingoIndex = 0;

function fillGrid() {
  items.forEach((item, ind) => {
    item.innerHTML = keysArr[ind];
    item.dataset.innernum = keysArr[ind];

    item.addEventListener("click", (e) => {
      if (gamestate !== "ON") {
        return Swal.fire({
          icon: "error",
          title: "Game Over",
          html: "Game Finished! Please Restart To Play Again!",
          confirmButtonText: "OK",
          customClass: {
            popup: 'horror-alert-popup',
            title: 'horror-alert-title',
            htmlContainer: 'horror-alert-text',
            confirmButton: 'horror-alert-button'
          }
        });
      }
      // checkBingo function में turn check होगा
      checkBingo(item);
    });
  });
}

function restart() {
  GetRandomArray();
  fillGrid();
}

//when we click restart just refresh page
function refreshPage() {
  window.location.reload();
}

function checkBingo(item) {
  const dataid = item.dataset.id;
  const innernum = item.dataset.innernum;
  const dataint = parseInt(dataid);
  if (addmearr.includes(dataint)) {
    return Swal.fire({
      icon: "error",
      title: "Already Selected",
      html: "This number is already chosen",
      toast: true,
      position: "top-right",
      timer: 3000,
      showConfirmButton: false,
      customClass: {
        popup: 'horror-toast-popup'
      }
    });
  }
  // Turn check करें click करने से पहले
  if (!currPlayer || currPlayer !== loc_username) {
    return Swal.fire({
      icon: "error",
      title: "Not Your Turn!",
      html: `Current turn: ${currPlayer || 'Not set'}`,
      toast: true,
      position: "top-right",
      timer: 3000,
      showConfirmButton: false,
      customClass: {
        popup: 'horror-toast-popup'
      }
    });
  }
  addmearr.push(dataint);
  item.classList.add("clicked");
  ws.send(
    JSON.stringify({
      command: "clicked",
      dataset: innernum,
      dataid: dataid,
      user: loc_username,
    })
  );
  loopItemsAndCheck();
}

function loopItemsAndCheck() {
  for (const j of bingoItems) {
    if (includesAll(addmearr, j)) {
      for (let [ind, li] of j.entries()) {
        successGrid(ind, li);
      }

      const index = bingoItems.indexOf(j);
      if (index > -1) {
        bingoItems.splice(index, 1);
      }
      let span = document.createElement("span");
      span.classList.add("bingState");
      span.append(bingoState[bingoIndex]);
      bingodiv.append(span);
      bingoIndex += 1;
      if (bingoIndex === 5) {
        Swal.fire({
          title: loc_username,
          html: "You won the Game!",
          icon: "success",
          confirmButtonText: "OK",
          background: 'linear-gradient(135deg, rgba(20,15,10,0.98), rgba(40,25,15,0.98))',
          customClass: {
            popup: 'horror-alert-popup',
            title: 'horror-alert-title',
            htmlContainer: 'horror-alert-text',
            confirmButton: 'horror-alert-button'
          }
        });
        ws.send(
          JSON.stringify({
            command: "won",
            user: loc_username,
            bingoCount: bingoIndex,
            info: `${loc_username} won the Game`,
          })
        );
      }
    }
  }
}

function successGrid(ind, li) {
  setTimeout(() => {
    const doneBingoDiv = document.querySelector(`[data-id='${li}']`);
    doneBingoDiv.classList.remove("clicked");
    doneBingoDiv.classList.add("bingoSuccess");
  }, ind * 50);
}
