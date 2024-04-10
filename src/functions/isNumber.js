function isNumber(numero) {
    const regex = /^[0-9]+$/;
    return regex.test(numero);
}

module.exports = isNumber;