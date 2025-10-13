// SPDX-License-Identifier: MIT
// pragma solidity >=0.4.22 <0.9.0;
pragma solidity ^0.8.0;

contract EHR{
    struct Doctor{
        string name;
        uint age;
        string gender;
        address[] allowedpatientList;

    }

    struct Patient{
        string name;
        uint age;
        string gender;
        address[] alloweddoctorList;
        HealthNote[] records;
    }
    struct HealthNote{
        string diagnosis;
        string information;
        uint256 time;
        address doctor;
    }



    address [] public DoctorList;
    address [] public PatientList;
    
    mapping (address => Patient) public patient;
    mapping (address => Doctor) public doctor;

    function Register(string memory name, uint age, string memory gender, uint selection) public {
        if (selection == 0){
            Patient storage newpatient = patient[msg.sender];
            newpatient.name = name;
            newpatient.age = age;
            newpatient.gender = gender;
            PatientList.push(msg.sender);
        }
        else {
            Doctor storage newdoctor = doctor[msg.sender];
            newdoctor.name = name;
            newdoctor.age = age;
            newdoctor.gender = gender;
            DoctorList.push(msg.sender);
        }
        
    }

    function getPatientsfromDoctor() public view returns (address[] memory){
        return doctor[msg.sender].allowedpatientList;
    }
    function getpatientInfor(address _patient) public view returns(string memory, string memory, uint){
        Patient storage pa = patient[_patient];
        return (pa.name, pa.gender, pa.age);
    }

    function getdoctorInfor(address _doctor) public view returns(string memory, string memory, uint){
        Doctor storage d = doctor[_doctor];
        return (d.name, d.gender, d.age);
    }

    function getdoctors() public view returns (address[] memory){
        return DoctorList;
    }

    function getpatients() public view returns (address[] memory){
        return PatientList;
    }

    function getAlloweddoctor(address _patient) public view returns (address[] memory){
        return patient[_patient].alloweddoctorList;

    }

    function getAllowedpatient(address _doctor) public view returns (address[] memory){
        return doctor[_doctor].allowedpatientList;

    }

    function grantDoctorAccess(address Addressdoctor) public{
        patient[msg.sender].alloweddoctorList.push(Addressdoctor);
        doctor[Addressdoctor].allowedpatientList.push(msg.sender);

    }

    function revokeDoctorAccess(address Addressdoctor) public{
        address[] storage doctors = patient[msg.sender].alloweddoctorList;
        for (uint index =0; index <doctors.length; index ++){
            if (doctors[index] == Addressdoctor){
                doctors[index] = doctors[doctors.length -1];
                doctors.pop();
                break;
            }
        }

        address[] storage patients = doctor[Addressdoctor].allowedpatientList;
        for (uint index =0; index < patients.length; index ++){
            if (patients[index] == msg.sender){
                patients[index] = patients[patients.length -1];
                patients.pop();
                break;
            }
        }
    }

    function addEHR(address _patient, string memory _diagnosis, string memory _information) public{
        HealthNote memory newHN = HealthNote ({diagnosis: _diagnosis, information: _information, time: block.timestamp, doctor: msg.sender});
        patient[_patient].records.push(newHN);
        
        address [] storage doctors = patient[_patient].alloweddoctorList;
        for (uint index =0; index <doctors.length; index ++){
            if (doctors[index] == msg.sender){
                doctors[index] = doctors[doctors.length -1];
                doctors.pop();
                break;
            }
        }
        address[] storage patients = doctor[msg.sender].allowedpatientList;
        for (uint index =0; index < patients.length; index ++){
            if (patients[index] == _patient){
                patients[index] = patients[patients.length -1];
                patients.pop();
                break;
            }
        }
    }

    function getEHR(address _patient) public view returns (HealthNote[] memory){
        return patient[_patient].records;
    }
}