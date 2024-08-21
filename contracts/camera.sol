// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FailoverCameraSystem {
    address public owner;
    
    enum CameraStatus { Down, Up }
    
    struct Camera {
        CameraStatus status;
        uint256 timestamp;
    }
    
    mapping(uint256 => Camera) public cameras;
    uint256 public primaryCameraId;
    uint256 public secondaryCameraId;
    
    event CameraStatusUpdated(uint256 cameraId, CameraStatus status);
    event TimestampSynchronized(uint256 fromCameraId, uint256 toCameraId, uint256 timestamp);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the Admin");
        _;
    }
    
    constructor(uint256 _primaryCameraId, uint256 _secondaryCameraId) {
        owner = msg.sender;
        primaryCameraId = _primaryCameraId;
        secondaryCameraId = _secondaryCameraId;
        
        cameras[primaryCameraId] = Camera(CameraStatus.Up, block.timestamp);
        cameras[secondaryCameraId] = Camera(CameraStatus.Up, block.timestamp);
    }
    
    function updateCameraStatus(uint256 cameraId, CameraStatus status) public onlyOwner {
        require(cameraId == primaryCameraId || cameraId == secondaryCameraId, "Invalid camera ID");
        
        cameras[cameraId].status = status;
        if (status == CameraStatus.Up) {
            synchronizeTimestamps(cameraId);
        }
        
        emit CameraStatusUpdated(cameraId, status);
    }
    
    function synchronizeTimestamps(uint256 cameraId) internal {
        uint256 otherCameraId = (cameraId == primaryCameraId) ? secondaryCameraId : primaryCameraId;
        
        if (cameras[otherCameraId].status == CameraStatus.Up) {
            cameras[cameraId].timestamp = cameras[otherCameraId].timestamp;
            emit TimestampSynchronized(otherCameraId, cameraId, cameras[otherCameraId].timestamp);
        } else {
            cameras[cameraId].timestamp = block.timestamp;
        }
    }
    
    function getCameraStatus(uint256 cameraId) public view returns (CameraStatus, uint256) {
        require(cameraId == primaryCameraId || cameraId == secondaryCameraId, "Invalid camera ID");
        return (cameras[cameraId].status, cameras[cameraId].timestamp);
    }
}