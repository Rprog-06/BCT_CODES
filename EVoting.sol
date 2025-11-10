
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract StudentDatabase {

    // The address of the person who deployed the contract.
    address public owner;

    /**
     * @dev Defines the data structure for a single student.
     * 'struct' is a complex data type that groups variables.
     */
    struct Student {
        uint studentId;
        string name;
        uint age;
    }

    /**
     * @dev A dynamic array to store multiple 'Student' structs.
     * 'students[]' can grow in size as new students are added.
     */
    Student[] public students;

    // A mapping to quickly find a student's index in the array by their ID.
    mapping(uint => uint) private studentIdToIndex;

    // Event to log when a new student is added.
    event StudentAdded(uint indexed studentId, string name, uint age);
    
    // Event to log payments received via the fallback function.
    event PaymentReceived(address from, uint amount);

    /**
     * @dev The constructor runs once when the contract is deployed.
     * It sets the contract's owner.
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev A modifier to restrict function access to the owner only.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    /**
     * @dev Adds a new student to the 'students' array.
     * This is a state-changing operation and will cost gas.
     * @param _studentId The unique ID for the student.
     * @param _name The name of the student.
     * @param _age The age of the student.
     */
    function addStudent(uint _studentId, string memory _name, uint _age) public onlyOwner {
        // We will store the index as array_length + 1 to distinguish from default 0
        require(studentIdToIndex[_studentId] == 0, "Student with this ID already exists.");

        students.push(Student(_studentId, _name, _age));
        studentIdToIndex[_studentId] = students.length; // Store index + 1
        
        emit StudentAdded(_studentId, _name, _age);
    }

    /**
     * @dev Retrieves a student's details by their ID.
     * This is a 'view' function and does not cost gas to call.
     * @param _studentId The ID of the student to retrieve.
     * @return The student's ID, name, and age.
     */
    function getStudent(uint _studentId) public view returns (uint, string memory, uint) {
        require(studentIdToIndex[_studentId] != 0, "Student not found.");
        
        uint index = studentIdToIndex[_studentId] - 1; // Convert back to 0-based index
        Student memory student = students[index];
        return (student.studentId, student.name, student.age);
    }

    /**
     * @dev Returns the total number of students in the database.
     */
    function getStudentCount() public view returns (uint) {
        return students.length;
    }
    
    /**
     * @dev Fallback function.
     * This function is executed if someone sends Ether to the contract
     * without specifying a function to call, or if the function name does not exist.
     * It's marked 'payable' to receive Ether.
     */
    fallback() external payable {
        // You can add logic here, like logging the payment.
        emit PaymentReceived(msg.sender, msg.value);
    }
    
    /**
     * @dev Receive function (optional but good practice with fallback).
     * This is called for plain Ether transfers (msg.data is empty).
     */
    receive() external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }
}