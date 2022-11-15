pragma solidity 0.8.7;

contract XYZ{
    struct Product {
        string item;
        string desc;
        uint productID;
        uint price;
        address payable seller;
        address payable buyer;
        bool offload;
        bool delivered;
    }
    
    uint counter = 1;
    Product[] public products;
    event registered(string item, uint productID, address seller);
    event bought(uint productID, address buyer);
    event delivered(uint productID);

    function registerProduct(string memory _item, string memory _desc, uint _price) public {
        require(_price > 0, "Price can't be less than 0");
        Product memory temp;
        temp.item = _item;
        temp.desc = _desc;
        temp.price = _price * 10**18;
        temp.seller = payable(msg.sender);
        temp.productID = counter;
        products.push(temp);
        counter++;
        emit registered(_item, temp.productID, msg.sender);
    }

    function buyProduct(uint _productID) payable public {
        require(_productID < counter, "No such product");
        require(products[_productID-1].offload == false, "Some other user ordered this product");
        require(products[_productID-1].price == msg.value, "The amount must be exact");
        require(products[_productID-1].seller != msg.sender, "Seller cannot buy his own product");
        products[_productID-1].buyer = payable(msg.sender);
        products[_productID-1].offload = true;
        emit bought(_productID, msg.sender);
    }

    function failed(uint _productID) payable public {
        require(_productID < counter, "No such product");
        require(products[_productID-1].buyer != payable(address(0)), "Product wasn't purchased");
        require(products[_productID-1].delivered == false, "Product was successfully delivered");
        require(products[_productID-1].seller == msg.sender, "Only seller can confirm failed transaction");
        products[_productID-1].offload = false;
        products[_productID-1].buyer.transfer(products[_productID-1].price);
        products[_productID-1].buyer = payable(address(0));
    }

    function delivery(uint _productID) public {
        require(_productID < counter, "No such product");
        require(products[_productID-1].offload == true, "The product isn't purchased");
        require(products[_productID-1].delivered == false, "The product is already delivered");
        require(products[_productID-1].buyer==msg.sender, "Only buyer can confirm delivery");
        products[_productID-1].delivered = true;
        products[_productID-1].seller.transfer(products[_productID-1].price);
        emit delivered(_productID);
    } 
}