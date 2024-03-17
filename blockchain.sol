// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;


contract Ownership{
    address public ManufacturerAdd;
    address public newOwner;

    event TransferOwnership(address indexed _from, address indexed _to);

    constructor() public{
        ManufacturerAdd= msg.sender;
    }
    
    function changeOwner( address _to) public{
        require(msg.sender == ManufacturerAdd, 'Only owner of the contract can execute it');
        newOwner = _to;
    }

    function acceptOwner() public{
        require(msg.sender == newOwner, 'Only new assigned owner can call it');
        emit TransferOwnership (ManufacturerAdd, newOwner);
        ManufacturerAdd = newOwner;
        newOwner = address(0);
    }

}

contract ownershipDetails{
    address payable RawmaterialAdd;
    address payable ManufacturerAdd;
    address payable WarehouseAdd;
    address payable RetailerAdd;
    address payable PharmacistAdd;
    address payable EnduserAdd;
    string productName;
    uint productId;
    uint productCost;
    string materials;
    uint materialid;
    uint materialprice;
    
    enum State5{Noaction,Purchase,confirmPurchase,DeliveryConfirm}
    enum State{Noaction,Purchase,confirmPurchase,DeliveryConfirm}
    enum State1{Noaction,Purchase,confirmPurchase,DeliveryConfirm}
    enum State2{Noaction,Purchase,confirmPurchase,DeliveryConfirm}
    enum State3{Noaction,Purchase,confirmPurchase,DeliveryConfirm}
    State5 public a_stateRaw;
    State public b_stateMan;
    State1 public c_stateWar;
    State2 public d_stateRet;
    State3 public e_statePhar;

    mapping(address => uint256) balances;
    constructor(address _ManufacturerAdd, address _WarehouseAdd,address _RetailerAdd,address _PharmacistAdd,address _EnduserAdd) payable public{
        RawmaterialAdd =payable(msg.sender);
        ManufacturerAdd =payable(_ManufacturerAdd);
        WarehouseAdd = payable(_WarehouseAdd);
        RetailerAdd = payable(_RetailerAdd);
        PharmacistAdd = payable(_PharmacistAdd);
        EnduserAdd = payable(_EnduserAdd);
    }
    error InvalidState();

    modifier instate5(State5 a_stateRaw_)
    {
      if(a_stateRaw!=a_stateRaw_)
      {
    revert InvalidState();
      }
    _;
    }

    modifier instate(State b_stateMan_)
    {
      if(b_stateMan!=b_stateMan_)
      {
    revert InvalidState();
      }
    _;
    }
    

    modifier instate1(State1 c_stateWar_)
    {
      if(c_stateWar!=c_stateWar_)
      {
    revert InvalidState();
      }
    _;
    }

    modifier instate2(State2 d_stateRet_)
    {
      if(d_stateRet!=d_stateRet_)
      {
    revert InvalidState();
      }
    _;
    }

    modifier instate3(State3 e_statePhar_)
    {
      if(e_statePhar!=e_statePhar_)
      {
    revert InvalidState();
      }
    _;
    }
    event Transferproduct(address indexed _from, address indexed _to);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    struct Rawmaterials{
        string materials;
        uint materialid;
        uint256 materialprice;
        address materialOwner;
    }
    Rawmaterials[] RawmaterialProd;

    struct ManufacturerMaterials{
        string materials;
        uint materialid;
        uint256 materialprice;
        address materialOwner;
    }
    ManufacturerMaterials[] ManufacturerMat;

    struct products{
        string Pname;
        uint prodid;
        uint256 Price;
        address Owner;
    }
    products[] ManufacturerPro;
    struct WarehousOwner{
        string Pname1;
        uint prodid1;
        uint256 Price1;
        address Owner1;
    }
    WarehousOwner[] WarehousePro;

    struct Retailers{
        string Pname;
        uint prodid;
        uint256 Price;
        address Owner;
    }
    Retailers[] RetailersPro;
    struct Pharmacists{
        string Pname;
        uint prodid;
        uint256 Price;
        address Owner;
    }
    Pharmacists[] Pharmacistpro;
    struct Endusers{
        string Pname;
        uint prodid;
        uint256 Price;
        address Owner;
    }
    Endusers[] Enduserspro;
    function a_AddRawMaterials(string memory _materials, uint _materialid, uint _materialprice) public {
        require(msg.sender == RawmaterialAdd, 'Only Rawmaterialowner of the contract can execute it');
        materials = _materials;
        materialid = _materialid;
        materialprice = _materialprice;
        RawmaterialProd.push(Rawmaterials(_materials, _materialid, _materialprice, msg.sender));
    }

    function a_RawmaterialPro() external view returns(Rawmaterials[] memory) {
        return RawmaterialProd;
    }

    function a_Manufacturer_Purchase_RawMat(uint _materialid) public instate5(State5.Noaction){
        require(materialid==_materialid, 'Product is not available!!!!');
        require(msg.sender==ManufacturerAdd, 'Only Manufacturer can purchase raw materials');
        a_stateRaw=State5.Purchase;
    }

    function a_Manufacturer_PurchaseConfirm_RawMaterial(uint _materialid) public instate5(State5.Purchase){
        require(msg.sender==RawmaterialAdd, 'Only Raw material owner can call it');
        a_stateRaw=State5.confirmPurchase;   
    }

    function a_Manufacturer_ReceiveConfirmRawMaterial(uint _materialid) payable public instate5(State5.confirmPurchase) returns (uint){
        
        require(msg.sender==ManufacturerAdd, 'Only Manufacturer can call it');
        emit Transferproduct(RawmaterialAdd, ManufacturerAdd);
        ManufacturerMat.push(ManufacturerMaterials(materials, materialid, materialprice, ManufacturerAdd));
        RawmaterialProd.pop();

        uint materialcost = materialprice*10**18;
        bool sent=RawmaterialAdd.send(msg.value);
        require(msg.value==materialcost, 'Isuficiant balance');
        require(sent, "Trans is failed");
        
        emit Transfer(msg.sender, RawmaterialAdd, materialcost);
        a_stateRaw = State5.DeliveryConfirm;
        
    }
     function b__ManufacturerRawmaterial() external view returns(ManufacturerMaterials[] memory) {
        return ManufacturerMat;
    }


    function b_AddOwnerProducts(string memory _Pname, uint _prodid, uint _Price) public {
        require(msg.sender == ManufacturerAdd, 'Only owner of the contract can execute it');
        productName = _Pname;
        productId =_prodid;
        productCost = _Price;
        ManufacturerPro.push(products(_Pname, _prodid, _Price, msg.sender));
    }

    function b1_ManufacturerProducts() external view returns(products[] memory) {
        return ManufacturerPro;
    }

    function b_warehouse_ownerb_Purchase(uint _prodid) public instate(State.Noaction){
        require(productId==_prodid, 'Product is not available!!!!');
        require(msg.sender==WarehouseAdd, 'Only new assigned owner can call it');
        b_stateMan=State.Purchase;
    }

    function b_warehousaen_owner_PurchaseConfirm(uint _prodid) public instate(State.Purchase){
        require(msg.sender==ManufacturerAdd, 'Only ManufacturerAdd can call it');
        b_stateMan=State.confirmPurchase;   
    }

    receive() external payable{}
    function b_warehouse_owner_ReceiveConfirm(uint _prodid) payable public instate(State.confirmPurchase) returns (uint){
        
        require(msg.sender==WarehouseAdd, 'Only new assigned owner can call it');
        emit Transferproduct(ManufacturerAdd, WarehouseAdd);
        WarehousePro.push(WarehousOwner(productName, productId, productCost, WarehouseAdd));
        ManufacturerPro.pop();
        uint productPrice = productCost*10**18;
        bool sent=ManufacturerAdd.send(msg.value);
        require(msg.value==productPrice, 'Isuficiant balance');
        require(sent, "Trans is failed");
        
        emit Transfer(msg.sender, ManufacturerAdd, productPrice);
        b_stateMan=State.DeliveryConfirm;
        
    }
    
    function c_WarehousseProducts() external view returns(WarehousOwner[] memory) {
        return WarehousePro;
    }

    function c_Retailer_Purchase(uint _prodid) public instate1(State1.Noaction){
        require(productId==_prodid, 'Product is not available!!!!');
        require(msg.sender==RetailerAdd, 'Only Retailers can call it');
        c_stateWar=State1.Purchase;
    }
    function c_Retailer_PurchaseConfirm(uint _prodid) public instate1(State1.Purchase){
        require(msg.sender==WarehouseAdd, 'Only WarehouseAdd can call it');
        c_stateWar=State1.confirmPurchase;   
    }

    
    function c_Retailer_ReceiveConfirm(uint _prodid) payable public instate1(State1.confirmPurchase) returns (uint){
        
        require(msg.sender==RetailerAdd, 'Only new assigned owner can call it');
        emit Transferproduct(WarehouseAdd, RetailerAdd);
        RetailersPro.push(Retailers(productName, productId, productCost, RetailerAdd));
        WarehousePro.pop();

        uint productPrice = productCost*10**18;
        bool sent=WarehouseAdd.send(msg.value);
        require(msg.value==productPrice, 'Isuficiant balance');
        require(sent, "Trans is failed");
        
        emit Transfer(msg.sender, WarehouseAdd, productPrice);
        c_stateWar=State1.DeliveryConfirm;
        
    }
      
    function d_Retailerproduct() external view returns(Retailers[] memory) {
        return RetailersPro;
    }


   function d_pharmacist_Purchase(uint _prodid) public instate2(State2.Noaction){
        require(productId==_prodid, 'Product is not available!!!!');
        require(msg.sender==PharmacistAdd, 'Only new assigned owner can call it');
        d_stateRet=State2.Purchase;
    }

    function d_pharmacist_PurchaseConfirm(uint _prodid) public instate2(State2.Purchase){
        require(msg.sender==RetailerAdd, 'Only RetailerAdd can call it');
        d_stateRet=State2.confirmPurchase;   
    }

    
    function d_pharmacist_ReceiveConfirm(uint _prodid) payable public instate2(State2.confirmPurchase) returns (uint){
        
        require(msg.sender==PharmacistAdd, 'Only new assigned owner can call it');
        emit Transferproduct(RetailerAdd, PharmacistAdd);
        Pharmacistpro.push(Pharmacists(productName, productId, productCost, PharmacistAdd));
        RetailersPro.pop();

        uint productPrice = productCost*10**18;
        bool sent=RetailerAdd.send(msg.value);
        require(msg.value==productPrice, 'Isuficiant balance');
        require(sent, "Trans is failed");
        
        emit Transfer(msg.sender, RetailerAdd, productPrice);
        d_stateRet=State2.DeliveryConfirm;
        
    }
    
    function e_Pharmaproduct() external view returns(Pharmacists[] memory) {
        return Pharmacistpro;
    }
    function e_Endusers_Purchase(uint _prodid) public instate3(State3.Noaction){
        require(productId==_prodid, 'Product is not available!!!!');
        require(msg.sender==EnduserAdd, 'Only new assigned owner can call it');
        e_statePhar=State3.Purchase;
    }

    function e_Endusers_PurchaseConfirm(uint _prodid) public instate3(State3.Purchase){
        require(msg.sender==PharmacistAdd, 'Only PharmacistAdd can call it');
        e_statePhar=State3.confirmPurchase;   
    }


    function e_Endusers_ReceiveConfirm(uint _prodid) payable public instate3(State3.confirmPurchase) returns (uint){
        
        require(msg.sender==EnduserAdd, 'Only new assigned owner can call it');
        emit Transferproduct(PharmacistAdd, EnduserAdd);
        Enduserspro.push(Endusers(productName, productId, productCost, EnduserAdd));
       Pharmacistpro.pop();
       uint productPrice = productCost*10**18;
        bool sent=PharmacistAdd.send(msg.value);
        require(msg.value==productPrice, 'Isuficiant balance');
        require(sent, "Trans is failed");
        
        emit Transfer(msg.sender, PharmacistAdd, productPrice);
        e_statePhar=State3.DeliveryConfirm;
        
    }
    
    function f_Enduserproduct() external view returns(Endusers[] memory) {
        return Enduserspro;
    }

}