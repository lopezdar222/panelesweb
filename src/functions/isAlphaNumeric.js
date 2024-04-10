function isAlphaNumeric(str) {
    let regex = /^[a-zA-Z0-9]+$/;
    if (str.length < 4 || str.length > 16) {
        return false;
    } else {
        return regex.test(str);
    }
}

module.exports = isAlphaNumeric;