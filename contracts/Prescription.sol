pragma solidity ^0.8.4;

contract PrescriptionToken {
    address owner;

    mapping(string => Prescription) prescriptionsIndex;

    mapping(string => bool) patientsIndex;
    mapping(string => bool) physiciansIndex;
    mapping(string => bool) pharmaciesIndex;
    mapping(string => bool) healthInsuranceCompaniesIndex;

    struct Prescription {

        // Contractically unique id of the token
        string tokenId;

        // Addresses linked with contract
        string ownerAddress;
        string prescriberAddress;
        string receiverAddress;
        string pharmacyAddress;
        string healthInsuranceCompanyAddress;

        // Drug information
        string drugName;
        string drugForm; // Pill, tablet, drops or else
        string drugQuantity;

        // Prescription information
        uint prescriptionDate;
        string prescriptionColor;
    }

    // Per norm
    event Transfer(string indexed _from, string indexed _to, uint256 indexed _tokenId);

    constructor() {
        owner = msg.sender;
    }

    // Per norm
    function balanceOf(string _owner) external view returns (uint256[] memory) {

    }

    // Per norm
    function ownerOf(string memory _tokenId) external view returns (address) {

    }

    // Verify that account belongs to verified physician
    function verifyPhysician(string _user) external returns (bool) {
        require(msg.sender == owner);

        physiciansIndex[_user] = true;

        if(physiciansIndex[_user] == true) {
            return true;
        } else {
            return false;
        }
    }

    // Verify that account belongs to verified pharmacy
    function verifyPharmacy(string _user) external returns (bool) {
        require(msg.sender == owner);

        pharmaciesIndex[_user] = true;

        if(pharmaciesIndex[_user] == true) {
            return true;
        } else {
            return false;
        }
    }

    // Verify that account belongs to verified healthInsuranceCompany
    function verifyHealthInsuranceCompany(string _user) external returns (bool) {
        require(msg.sender == owner);

        healthInsuranceCompaniesIndex[_user] = true;

        if(healthInsuranceCompaniesIndex[_user] == true) {
            return true;
        } else {
            return false;
        }
    }

    function affiliateOf(string memory _tokenId) external view returns (address, address, address, address) {
        Prescription memory tmpPrescription = prescriptionsIndex[_tokenId];
        return(tmpPrescription.prescriberAddress, tmpPrescription.receiverAddress, tmpPrescription.pharmacyAddress, tmpPrescription.healthInsuranceCompanyAddress);
    }

    function terminate(string memory) external returns (bool) {
        // If insuranceCompanystring == ownerstring -> delete Token

        // Else return false
    }

    // Per norm
    function transferFrom(string _from, string _to, string memory _tokenId) external payable {
        require(msg.sender == prescriptionsIndex[_tokenId].ownerAddress);

        if(patientsIndex[_from] && pharmaciesIndex[_to] == true) {
            prescriptionsIndex[_tokenId].ownerstring = _to;
            prescriptionsIndex[_tokenId].pharmacystring = _to;
        } else if (pharmaciesIndex[_from] == true && healthInsuranceCompaniesIndex[_to] == true) {
            prescriptionsIndex[_tokenId].ownerstring = _to;
            prescriptionsIndex[_tokenId].healthInsuranceCompanystring = _to;
        }
    }
    
    // Rezept erstellen
    function mint(string _from, string _to, string memory _tokenId, string memory _drugName, string memory _drugForm, string memory _drugQuantity, string memory _prescriptionColor) external {
        require(physiciansIndex[_from] == true);
        require(patientsIndex[_to] == true);
        require(bytes(prescriptionsIndex[_tokenId].tokenId).length != 0);
        
        Prescription memory tmpPrescription = Prescription({
            tokenId:_tokenId, 
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
        
        prescriptionsIndex[_tokenId] = tmpPrescription;
    }

    // Rezepte holen 
    function drugdataOf(string memory _tokenId) external view returns (string memory drugName, string memory drugForm, string memory drugQuantity) {
        Prescription memory tmpPrescription = prescriptionsIndex[_tokenId];
        return(tmpPrescription.drugName, tmpPrescription.drugForm, tmpPrescription.drugQuantity);
    }

    // Rezepte holen (gibt Farbe und Datum wieder)
    function prescriptiondataOf(string memory _tokenId) external view returns (uint prescriptionDate, string memory prescriptionColor) {
        Prescription memory tmpPrescription = prescriptionsIndex[_tokenId];
        return(tmpPrescription.prescriptionDate, tmpPrescription.prescriptionColor);
    }
}

// To do id when minting