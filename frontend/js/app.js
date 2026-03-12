async function checkBalance() {
    const number = document.getElementById('accountNumber').value;
    if (!number) return alert("Entrez un numéro de compte");

    try {
        const res = await fetch(`http://backend:8080/api/accounts/${number}`);
        if (res.ok) {
            const data = await res.json();
            document.getElementById('balanceResult').innerHTML = 
                `Solde du compte ${number} : <strong>${data.solde} €</strong>`;
        } else {
            document.getElementById('balanceResult').innerHTML = "Compte non trouvé";
        }
    } catch (err) {
        document.getElementById('balanceResult').innerHTML = "Erreur réseau";
    }
}
