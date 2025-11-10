//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract StudentDB{
    struct Student{
        string name;
        uint256 rollno;
        string stuclass;
    }

    Student[] private Students;

    function addStudent(string memory name,uint256 rollno,string memory stuclass) public{
        Students.push(Student(name,rollno,stuclass));
    }

    function getStudentByID(uint256 _id) public view returns(string memory name, uint256 rollno, string memory stuclass) {
    require(_id < Students.length, "Student does not exist in Database");
    return (Students[_id].name, Students[_id].rollno, Students[_id].stuclass);
    }

    function TotalStudents() public view returns(uint256){
        return Students.length;
    }
    
}