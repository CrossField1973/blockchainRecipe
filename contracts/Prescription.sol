pragma solidity ^0.8.4;

contract PrescriptionToken {
    address owner;

    mapping(string => Prescription) prescriptionsIndex;

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
    function balanceOf(string memory _owner) external view returns (uint256[] memory) {
    }

    // Per norm
    function ownerOf(string memory _tokenId) external view returns (string memory) {
    }

    function isOwnerOfContract() external  returns (bool) {
        if(msg.sender == owner) {
            return true;
        } else {
            return false;
        }
    }

    // Verify that account belongs to verified physician
    function verifyPhysician(string memory _user) external returns (bool) {
        require(msg.sender == owner);

        physiciansIndex[_user] = true;

        if(physiciansIndex[_user] == true) {
            return true;
        } else {
            return false;
        }
    }

    // Verify that account belongs to verified pharmacy
    function verifyPharmacy(string memory _user) external returns (bool) {
        require(msg.sender == owner);

        pharmaciesIndex[_user] = true;

        if(pharmaciesIndex[_user] == true) {
            return true;
        } else {
            return false;
        }
    }

    // Verify that account belongs to verified healthInsuranceCompany
    function verifyHealthInsuranceCompany(string memory _user) external returns (bool) {
        require(msg.sender == owner);

        healthInsuranceCompaniesIndex[_user] = true;

        if(healthInsuranceCompaniesIndex[_user] == true) {
            return true;
        } else {
            return false;
        }
    }

    function affiliateOf(string memory _tokenId) external view returns (string memory, string memory, string memory, string memory) {
        Prescription memory tmpPrescription = prescriptionsIndex[_tokenId];
        return(tmpPrescription.prescriberAddress, tmpPrescription.receiverAddress, tmpPrescription.pharmacyAddress, tmpPrescription.healthInsuranceCompanyAddress);
    }

    // Per norm
    function transferFrom(string memory _from, string memory _to, string memory _tokenId) external payable {
        //require(msg.sender == prescriptionsIndex[_tokenId].ownerAddress);

        if(pharmaciesIndex[_to] == true) {
            prescriptionsIndex[_tokenId].ownerAddress = _to;
            prescriptionsIndex[_tokenId].pharmacyAddress = _to;
        } else if (pharmaciesIndex[_from] == true && healthInsuranceCompaniesIndex[_to] == true) {
            prescriptionsIndex[_tokenId].ownerAddress = _to;
            prescriptionsIndex[_tokenId].healthInsuranceCompanyAddress = _to;
        }
    }
    
    // Rezept erstellen
    function mint(string memory _from, string memory _to, string memory _tokenId, string memory _drugName, string memory _drugForm, string memory _drugQuantity, string memory _prescriptionColor) external {
        require(physiciansIndex[_from] == true);
        require(bytes(prescriptionsIndex[_tokenId].tokenId).length != 0);
        
        Prescription memory tmpPrescription = Prescription({
            tokenId:_tokenId, 
            ownerAddress:_to, 
            prescriberAddress:_from, 
            receiverAddress:_to, 
            pharmacyAddress:"0",
            healthInsuranceCompanyAddress:"0",
            drugName:_drugName, 
            drugForm:_drugForm, 
            drugQuantity:_drugQuantity, 
            prescriptionDate:block.timestamp, 
            prescriptionColor:_prescriptionColor
        });
        
        prescriptionsIndex[_tokenId] = tmpPrescription;
    }

    // Gibt Informationen über das verschiebene Medikaments zurück
    function drugdataOf(string memory _tokenId) external view returns (string memory drugName, string memory drugForm, string memory drugQuantity) {
        Prescription memory tmpPrescription = prescriptionsIndex[_tokenId];
        return(tmpPrescription.drugName, tmpPrescription.drugForm, tmpPrescription.drugQuantity);
    }

    // Gibt Informationen über das Rezept zurück
    function prescriptiondataOf(string memory _tokenId) external view returns (uint prescriptionDate, string memory prescriptionColor) {
        Prescription memory tmpPrescription = prescriptionsIndex[_tokenId];
        return(tmpPrescription.prescriptionDate, tmpPrescription.prescriptionColor);
    }
}