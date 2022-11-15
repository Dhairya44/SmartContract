# SmartContract

#Developed BY: 
#Khushil Kataria - 2020A7PS2086H
#Rahil Sanghavi - 2020A7PS2052H
#Pulkit Agrawal - 2020A7PS2072H
#Dhairya Agrawal - 2020A7PS0130H

This project is a smart contract that sends the amount to xyz.com only when the item has been delivered to the user, and off-loading of the item starts only when the user has paid the amount of the item to the smart contract which is deployed on the blockchain.


## Data Structures

A struct has been used to encompass the details of each product.

Attributes of each product:

        string item - Name of the item
        string desc; - Description of the item
        uint productID - ID of the product
        uint price - Price of the product
        address payable seller - Address of the seller
        address payable buyer - Address of the buyer
        bool offload - Boolean value indicating whether the product has been offloaded
        bool delivered - Boolean value indicating whether the product has been delivered

## Global Variables
uint counter - keeps track of the number of the products available in the products array.
Product[] public products - Dynamic array, used by the sellers to add the product. 

## Functions
### registerProduct(string memory _item, string memory _desc, uint _price):
	Constraints - Price of the product should be greater than 0.
	Functionalities - Sets the item, desc, productID, price and seller fields of a product, and adds instance of that product to a list of products. 

### buyProduct(uint _productID) - 
	Constraints - productID should be valid; specifically, it should be less than the total number of registered products. Offload field of the product should be false, indicating that the product has not yet been sold to another buyer. The price of the product should match the amount that the buyer will send to the smart contract. Address of the seller should not match the address of the buyer.
    Functionalites - The user can buy the product using the product ID. It checks whether the product is available now or not, seller not buying his own product and offloading of the product. Sets the buyer address to the address of the caller and the boolean field offload to true.

### delivery(uint _productID):
    Constraints - productID should be valid; specifically, it should be less than the total number of registered products. Offload field of the product should be true, indicating that the product has been dispatched. Delivered field of the product should be false, indicating that the product has not already been delivered yet. Address of the buyer should match the address of the user initiating the delivered function for that product.
    Functionalities - Sets the bool delivered to true and transfers the amount to the seller’s account since the product has been delivered.

### failed(uint _productID):
    Constraints - productID should be valid; specifically, it should be less than the total number of registered products. Delivered field of the product should be false, indicating that the delivery of that product has failed. Address of the seller should match the address of the user initiating the failed function.
    Functionalities - Sets the bool deliver to false, refunds the amount to the buyer since the delivery failed, and resets the buyer address of that product to 0.