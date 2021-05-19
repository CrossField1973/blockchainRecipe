pragma solidity ^0.8.4;

contract PrescriptionToken {
    address owner;

    mapping(uint256 => Prescription) prescriptionsIndex;

    mapping(address => bool) patientsIndex;
    mapping(address => bool) physiciansIndex;
    mapping(address => bool) pharmaciesIndex;
    mapping(address => bool) healthInsuranceCompaniesIndex;

    struct Prescription {

        // Contractically unique id of the token
        uint256 tokenId;

        // Addresses linked with contract
        address ownerAddress;
        address prescriberAddress;
        address receiverAddress;
        address pharmacyAddress;
        address healthInsuranceCompanyAddress;

        // Drug information
        string drugName;
        string drugForm; // Pill, tablet, drops or else
        string drugQuantity;

        // Prescription information
        uint prescriptionDate;
        string prescriptionColor;
    }

    // Per norm
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    constructor() {
        owner = msg.sender;
    }

    // Per norm
    function balanceOf(address _owner) external view returns (uint256[] memory) {

    }

    // Per norm
    function ownerOf(uint256 _tokenId) external view returns (address) {

    }

    // Verify that account belongs to verified physician
    function verifyPhysician(address _user) external returns (bool) {
        require(msg.sender == owner);

        physiciansIndex[_user] = true;

        if(physiciansIndex[_user] == true) {
            return true;
        } else {
            return false;
        }
    }

    // Verify that account belongs to verified pharmacy
    function verifyPharmacy(address _user) external returns (bool) {
        require(msg.sender == owner);

        pharmaciesIndex[_user] = true;

        if(pharmaciesIndex[_user] == true) {
            return true;
        } else {
            return false;
        }
    }

    // Verify that account belongs to verified healthInsuranceCompany
    function verifyHealthInsuranceCompany(address _user) external returns (bool) {
        require(msg.sender == owner);

        healthInsuranceCompaniesIndex[_user] = true;

        if(healthInsuranceCompaniesIndex[_user] == true) {
            return true;
        } else {
            return false;
        }
    }

    function affiliateOf(uint256 _tokenId) external view returns (address, address, address, address) {
        Prescription memory tmpPrescription = prescriptionsIndex[_tokenId];
        return(tmpPrescription.prescriberAddress, tmpPrescription.receiverAddress, tmpPrescription.pharmacyAddress, tmpPrescription.healthInsuranceCompanyAddress);
    }

    function terminate(uint256 _tokenId) external returns (bool) {
        // If insuranceCompanyAddress == ownerAddress -> delete Token

        // Else return false
    }

    // Per norm
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(msg.sender == prescriptionsIndex[_tokenId].ownerAddress);

        if(patientsIndex[_from] && pharmaciesIndex[_to] == true) {
            prescriptionsIndex[_tokenId].ownerAddress = _to;
            prescriptionsIndex[_tokenId].pharmacyAddress = _to;
        } else if (pharmaciesIndex[_from] == true && healthInsuranceCompaniesIndex[_to] == true) {
            prescriptionsIndex[_tokenId].ownerAddress = _to;
            prescriptionsIndex[_tokenId].healthInsuranceCompanyAddress = _to;
        }
    }
    

    function mint(address _from, address _to, uint256 _tokenId, string memory _drugName, string memory _drugForm, string memory _drugQuantity, string memory _prescriptionColor) external {
        require(physiciansIndex[_from] == true);
        require(patientsIndex[_to] == true);
        require(prescriptionsIndex[_tokenId].tokenId != 0);
        
        uint256 tmpId = 0;
        Prescription memory tmpPrescription = Prescription({
            tokenId:tmpId, 
            ownerAddress:_to, 
            prescriberAddress:_from, 
            receiverAddress:_to, 
            pharmacyAddress:address(0),
            healthInsuranceCompanyAddress:address(0),
            drugName:_drugName, 
            drugForm:_drugForm, 
            drugQuantity:_drugQuantity, 
            prescriptionDate:block.timestamp, 
            prescriptionColor:_prescriptionColor
        });
        
        prescriptionsIndex[tmpId] = tmpPrescription;
    }

    function drugdataOf(uint256 _tokenId) external view returns (string memory drugName, string memory drugForm, string memory drugQuantity) {
        Prescription memory tmpPrescription = prescriptionsIndex[_tokenId];
        return(tmpPrescription.drugName, tmpPrescription.drugForm, tmpPrescription.drugQuantity);
    }

    function prescriptiondataOf(uint256 _tokenId) external view returns (uint prescriptionDate, string memory prescriptionColor) {
        Prescription memory tmpPrescription = prescriptionsIndex[_tokenId];
        return(tmpPrescription.prescriptionDate, tmpPrescription.prescriptionColor);
    }
}

// To do id when minting