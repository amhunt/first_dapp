pragma solidity ^0.4.4;
contract FirstDapp {

  address DappAdmin;

  mapping ( bytes32 => imageWithTimestamp) notarizedImages; // SHA256 maps to image
  bytes32[] imagesByNotaryHash; // all images, for iteration

  mapping ( address => User ) Users; // eth address to user
  address[] usersByAddress; // all users, for iteration

  struct imageWithTimestamp {
    string imageURL;
    uint timestamp;
  }

  struct User {
    string handle;
    bytes32 city;
    bytes32 state;
    bytes32 country;
    bytes32[] myImages;
  }

  function registerNewUser(string handle, bytes32 city, bytes32 state, bytes32 country) returns (bool success) {
    address thisNewAddress = msg.sender;
    if(bytes(Users[thisNewAddress].handle).length == 0 && bytes(handle).length != 0){
      Users[thisNewAddress].handle = handle;
      Users[thisNewAddress].city = city;
      Users[thisNewAddress].state = state;
      Users[thisNewAddress].country = country;
      usersByAddress.push(thisNewAddress);
      return true;
    } else {
      return false;
    }
  }

  function addImageToUser(string imageURL, bytes32 SHA256Hash) returns (bool success) {
    address thisNewAddress = msg.sender;
    if(bytes(Users[thisNewAddress].handle).length == 0){
      if(bytes(imageURL).length != 0) {
        if(bytes(notarizedImages[SHA256Hash].imageURL).length == 0) {
          imagesByNotaryHash.push(SHA256Hash);
        }
        notarizedImages[SHA256Hash].imageURL = imageURL;
        notarizedImages[SHA256Hash].timestamp = block.timestamp;
        Users[thisNewAddress].myImages.push(SHA256Hash);
        return true;
      } else {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  function getUsers() constant returns (address[]) { return usersByAddress; }

  function getUser(address userAddress) constant returns (string,bytes32,bytes32,bytes32,bytes32[]) {
    return (Users[userAddress].handle,Users[userAddress].city,Users[userAddress].state,Users[userAddress].country,Users[userAddress].myImages);
  }

  function getAllImages() constant returns (bytes32[]) { return imagesByNotaryHash; }

  function getUserImages(address userAddress) constant returns (bytes32[]) { return Users[userAddress].myImages; }

  function getImage(bytes32 SHA256Hash) constant returns (string,uint) {
    return (notarizedImages[SHA256Hash].imageURL,notarizedImages[SHA256Hash].timestamp);
  }

}
