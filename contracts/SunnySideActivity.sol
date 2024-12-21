// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./interface/ISunnySideActivity.sol";

contract SunnySideActivity is
    Initializable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable,
    ISunnySideActivity
{
    using ECDSA for bytes32;
    /* ==========================================================
     * Constants
     * ==========================================================
     */

    uint256 public constant REFERRER_REWARD_POINTS = 100;
    uint256 public constant REFERRED_REWARD_POINTS = 50;
    uint256 public constant DAILY_LOGIN_POINTS = 5;
    uint256 public constant CHEST_COOLDOWN = 45 minutes;

    enum Activity {
        None,
        ReferralBonus,
        DailyLogin,
        Fishing,
        OpenChest
    }

    struct User {
        bool whitelisted; // Is user whitelisted
        bool referred; // Has the user been referred
        address referrer; // Address of the referrer
        uint256 totalPoints; // Total accumulated points
        uint256 dailyQuestPoints; // Points earned through daily quests
        uint256 activityPoints; // Points earned through activities
        uint256 lastLogin; // Last login timestamp
        uint256 lastActionTime; // Last activity timestamp (e.g., fishing or chest opening)
    }

    struct Fish {
        string fishName;
        uint256 rate;
        uint256 rewardPoint;
    }

    mapping(address => User) public users;
    mapping(address => uint256) public referralCounts;
    mapping(uint256 => string) public activityNames;

    Fish[] public fishList;

    /* ==========================================================
     * Modifier
     * ==========================================================
     */

    modifier onlyWhitelisted(address user) {
        require(users[user].whitelisted, "User not whitelisted");
        _;
    }

    /* ==========================================================
     * Errors
     * ==========================================================
     */

    error UserNotWhitelisted();
    error UserAlreadyWhitelisted();
    error AlreadyReferred();
    error CannotReferSelf();
    error ReferrerNotWhitelisted();
    error AlreadyLoggedInToday();
    error CooldownActive();

    constructor() {
        activityNames[uint256(Activity.None)] = "None";
        activityNames[uint256(Activity.ReferralBonus)] = "Referral Bonus";
        activityNames[uint256(Activity.DailyLogin)] = "Daily Login";
        activityNames[uint256(Activity.Fishing)] = "Fishing";
        activityNames[uint256(Activity.OpenChest)] = "Open Chest";
    }

    function initialize(address _owner) public initializer {
        __Ownable_init(_owner);
        __Pausable_init();
        __ReentrancyGuard_init();

        activityNames[uint256(Activity.None)] = "None";
        activityNames[uint256(Activity.ReferralBonus)] = "Referral Bonus";
        activityNames[uint256(Activity.DailyLogin)] = "Daily Login";
        activityNames[uint256(Activity.Fishing)] = "Fishing";
        activityNames[uint256(Activity.OpenChest)] = "Open Chest";
    }

    /* ==========================================================
     * SET
     * ==========================================================
     */

    function addToWhitelist(address user) external onlyOwner whenNotPaused {
        if (users[user].whitelisted) revert UserAlreadyWhitelisted();

        users[user].whitelisted = true;
        emit WhitelistAdded(user, true);
    }

    function joinWithReferral(
        address user,
        address referrer
    ) external onlyOwner whenNotPaused {
        // Check if the user is already whitelisted
        require(user != address(0), "Invalid Address");
        if (users[user].whitelisted) revert UserAlreadyWhitelisted();

        // Mark the user as whitelisted
        users[user].whitelisted = true;

        if (user == referrer) revert("Cannot refer self");
        if (users[user].referred) revert("Already referred");
        if (!users[referrer].whitelisted) revert("Referrer not whitelisted");

        // Apply referral rewards
        users[user].referred = true;
        users[user].referrer = referrer;

        users[referrer].totalPoints += REFERRER_REWARD_POINTS;
        users[user].totalPoints += REFERRED_REWARD_POINTS;
        referralCounts[referrer]++;

        emit ReferralCompleted(referrer, user);
        emit PointsAdded(
            user,
            activityNames[uint256(Activity.ReferralBonus)],
            REFERRED_REWARD_POINTS
        );
        emit PointsAdded(
            referrer,
            activityNames[uint256(Activity.ReferralBonus)],
            REFERRER_REWARD_POINTS
        );

        emit WhitelistAdded(user, true);
    }

    function dailyLogin(
        address user
    ) external onlyWhitelisted(user) onlyOwner whenNotPaused {
        if (block.timestamp <= users[user].lastLogin + 1 days)
            revert AlreadyLoggedInToday();

        uint256 pointsEarned = DAILY_LOGIN_POINTS;
        users[user].dailyQuestPoints += pointsEarned;
        users[user].totalPoints += pointsEarned;
        users[user].lastLogin = block.timestamp;

        emit DailyLogin(user, pointsEarned);
        emit PointsAdded(
            user,
            activityNames[uint256(Activity.DailyLogin)],
            pointsEarned
        );
    }

    function addListFish(
        string calldata fishName,
        uint256 rate,
        uint256 rewardPoint
    ) external onlyOwner {
        fishList.push(Fish(fishName, rate, rewardPoint));
    }

    function updateListFish(
        uint256 fishIndex,
        string calldata fishName,
        uint256 rate,
        uint256 rewardPoint
    ) external onlyOwner {
        require(fishIndex < fishList.length, "Invalid fish index");
        fishList[fishIndex] = Fish(fishName, rate, rewardPoint);
    }

    function catchFish(
        address user,
        string calldata fishName
    ) external onlyWhitelisted(user) onlyOwner whenNotPaused {
        bool fishFound = false;
        uint256 rewardPoint = 0;
        for (uint256 i = 0; i < fishList.length; i++) {
            if (
                keccak256(abi.encodePacked(fishList[i].fishName)) ==
                keccak256(abi.encodePacked(fishName))
            ) {
                fishFound = true;
                rewardPoint = fishList[i].rewardPoint;
                break;
            }
        }
        require(fishFound, "Fish not found");

        users[user].activityPoints += rewardPoint;
        users[user].totalPoints += rewardPoint;
        users[user].lastActionTime = block.timestamp;

        emit FishCatched(user, fishName, rewardPoint);
    }

    function addPoints(
        address user,
        Activity activity,
        uint256 points
    ) external onlyWhitelisted(user) onlyOwner whenNotPaused {
        users[user].activityPoints += points;
        users[user].totalPoints += points;
        users[user].lastActionTime = block.timestamp;

        emit PointsAdded(user, activityNames[uint256(activity)], points);
    }
    /* ==========================================================
     * GET
     * ==========================================================
     */

    function isWhitelisted(address user) external view returns (bool) {
        return users[user].whitelisted;
    }

    function isReferred(address user) external view returns (bool) {
        return users[user].referred;
    }

    function getUserPoints(address user) external view returns (uint256) {
        return users[user].totalPoints;
    }

    function getDailyQuestPoints(address user) external view returns (uint256) {
        return users[user].dailyQuestPoints;
    }

    function getActivityPoints(address user) external view returns (uint256) {
        return users[user].activityPoints;
    }

    function getActivityName(
        Activity activity
    ) external view returns (string memory) {
        return activityNames[uint256(activity)];
    }
}
