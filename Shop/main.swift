//Создать класс Товар с параметрами имя, цена и штрих код.
//Создать 3 класса наследника от класса Товар:
//Напиток, Быстрые закуски, Шоколад, параметров нет.
//Создать класс Магазин, в котором есть  в параметре имя магазина и корзина для продуктов,
//функция добавления товара и функция распечатки чека в следующем виде:

//——Имя Магазина——
//Товары:
//Наименование:            Цена:
//1. Имя товара                его цена
//2. И т.д
//3. ……..
//
//Итого к оплате: общая сумма в сомах
//————————————
//Спасибо за покупку!
//

//Дополнительное задание:
//-Добавить удаление товара из корзины по штрих коду.
//-Добавить в аргумент добавления товара аргумент кол-во штук.
//Соответственно при вызове функции нужно указывать кол-во покупаемого товара
//и в корзину должно добавляться указанное кол-во одного и того же товара.
///

import Foundation

class Product {
    var name: String
    var price: Double
    var barcode: String
    
    init(name: String, price: Double, barcode: String) {
        self.name = name
        self.price = price
        self.barcode = barcode
    }
}

class Drink: Product {}

class FastFood: Product {}

class Chocolade: Product {}

class Shop {
    var name: String
    var availableProducts: [Product]
    var shoppingCart: [Product]
    
    init(name: String, availableProducts: [Product], shoppingCart: [Product] = []) {
        self.name = name
        self.availableProducts = availableProducts
        self.shoppingCart = shoppingCart
    }
    
    func addCart (product: Product, quantity: Int) {
        for i in 0..<quantity {
            shoppingCart.append(product)
        }
    }
    
    func removeForBarCode(barCode: String, quantity: Int) {
        
        var remainingQuantity = quantity
        
        shoppingCart = shoppingCart.filter { product in
            if product.barcode == barCode {
                if remainingQuantity > 0 {
                    remainingQuantity -= 1
                    return false
                } else {
                    return true
                }
            } else {
                return true
            }
        }
    }
    
    func printAvailableProducts() {
        print("\nСписок доступных товаров: ")
        for (index, product) in availableProducts.enumerated() {
            print("\(index + 1). \(product.name) - \(product.price) som (штрихкод: \(product.barcode))")
        }
    }
    
    func printShoppingCart() {
        if shoppingCart.isEmpty {
            print("Корзина пуста.")
        } else {
            print("\nТовары в корзине")
            for (index, product) in shoppingCart.enumerated() {
                print("\(index + 1). \(product.name) - \(product.price) som (штрихкод: \(product.barcode))")
            }
        }
    }
    
    func printReceipt() {
        print("\n------\(name)------")
        print("Товары:")
        print("Наименование:\t\tЦена:")
        var totalPrice = 0.0
        for (index, product) in shoppingCart.enumerated() {
            print("\(index + 1). \(product.name)\t\t\(product.price)")
            totalPrice += product.price
        }
        print("\nИтого к оплате: \(totalPrice) som")
        print("-----------------------")
        print("Спасибо за покупку!")
    }
    
    func getProductByIndex(index: Int) -> Product? {
        guard index >= 0 && index < availableProducts.count else {
            return nil
        }
        return availableProducts[index]
    }
    
    func getProductInCartBarcode(barcode: String) -> Product? {
        return shoppingCart.first {$0.barcode == barcode}
    }
}

let cola = Drink(name: "Cola", price: 50.0, barcode: "111")
let burger = Drink(name: "Burger", price: 120.0, barcode: "222")
let mars = Drink(name: "Mars", price: 30.0, barcode: "333")

let shop = Shop(name: "Глобус", availableProducts: [cola, burger, mars])

func readLine(promt: String) -> String? {
    print(promt, terminator: "")
    return readLine()
}

while true {
    print("\nМеню")
    print("1. Показать доступные товары")
    print("2. Добавить товар в корзину")
    print("3. Удалить товар из корзины (по штрихкоду и количеству)")
    print("4. Показать корзину")
    print("5 Печать чека")
    print("6. Выход")
    
    if let choice = readLine(promt: "Выберите действие (1-6): ") {
        switch choice {
        case "1": 
            shop.printAvailableProducts()
        case "2":
            var continueAdding = true
            
            while continueAdding {
                shop.printAvailableProducts()
                print("Введите номер товара для добавления в корзину (или '0' для выхода):")
                if let input = readLine() {
                    if input == "0" {
                        continueAdding = false
                        continue
                    }
                    if let index = Int(input), index > 0 {
                        guard let product = shop.getProductByIndex(index: index - 1) else {
                            print("Ошибка: товар с указанным номером не найден.")
                            continue
                        }
                        print("Введите количество товара:")
                        if let quantityInput = readLine(), let quantity = Int(quantityInput), quantity > 0 {
                            shop.addCart(product: product, quantity: quantity)
                            print("\(product.name) добавлен в корзину в количестве \(quantity) шт.")
                        } else {
                            print("Ошибка: введите корректное количество товара.")
                        }
                    } else {
                        print("Выход из добавления товара в корзину.")
                    }
                }
            }
            
        case "3":
            print("Введите штрихкод товара для удаления из корзины и количество:")
            if let input = readLine() {
                let componets = input.components(separatedBy: " ")
                guard componets.count == 2, let barcode = componets.first, let quantity = Int(componets.last ?? "") else {
                    print("Ошибка: неверный формат ввода.")
                    continue
                }
                
                if let removedProduct = shop.getProductInCartBarcode(barcode: barcode) {
                    shop.removeForBarCode(barCode: barcode, quantity: quantity)
                    print("\(removedProduct.name) с штрихкодом \(barcode) удален из корзины в количестве \(quantity) шт.")
                } else {
                    print("Товар с указанным штрихкодом не найден в корзине.")
                }
            } else {
                print("Ошибка: введите корректный штрихкод товара и количество.")
            }
            
        case "4":
            shop.printShoppingCart()
        case "5":
            shop.printReceipt()
        case "6":
            print("Завершение программы.")
            exit(0)
        default:
            print("Ошибка: выберите действие от 1 до 6.")
        }
    }
}
