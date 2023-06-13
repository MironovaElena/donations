// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DonationContract {
    address payable public immutable owner; // Адрес владельца контракта (нельзя изменить)
    mapping(address => uint) public donations; // Маппинг для хранения сумм пожертвований для каждого адреса
    uint public totalDonations; // Общая сумма пожертвований

    event DonationReceived(address indexed donor, uint amount); // Событие для отслеживания внесенных пожертвований

    constructor() {
        owner = payable(msg.sender); // Установка адреса владельца контракта при создании
    }

    /**
     * Внести пожертвование.
     */
    function donate() external payable {
        require(msg.value > 0, "Please send some ETH for donation."); // Проверка наличия пожертвования
        donations[msg.sender] += msg.value; // Увеличение суммы пожертвования для соответствующего адреса
        totalDonations += msg.value; // Увеличение общей суммы пожертвований
        emit DonationReceived(msg.sender, msg.value); // Вызов события DonationReceived
    }

    /**
     * Получить сумму пожертвования для указанного адреса.
     * @param donor Адрес пожертвователя.
     * @return Сумма пожертвования.
     */
    function getDonation(address donor) external view returns (uint) {
        return donations[donor]; // Возврат суммы пожертвования для указанного адреса
    }

    /**
     * Вывести накопленные пожертвования на адрес владельца контракта.
     */
    function withdrawDonations() external {
        uint amount = address(this).balance; // Получение текущего баланса контракта
        require(amount > 0, "There are no donations to withdraw."); // Проверка наличия пожертвований для вывода
        totalDonations = 0; // Обнуление общей суммы пожертвований
        owner.transfer(amount); // Перевод суммы пожертвований на адрес владельца
    }
}
