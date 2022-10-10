import UIKit
import CoreFoundation
import Foundation

/*: # 二分法
 */

func binarySearch(_ list: [Int], item: Int) -> Int {
    // 定义low和high用于跟踪要在其中查找的列表范围，初始值low为第一个元素下标，high为最后一个元素下标
    var low = 0
    var high = list.count - 1
    
    while low <= high { // 开启循环，条件：当范围的低位不大于高位（范围没有缩小到只包含一个元素）
        let mid = (low + high) / 2 //检查位于中间（二分之一处）的元素
        let guess = list[mid] // 检查中间元素
        
        if guess == item { return mid } // 找到了
        
        if guess > item { // 大了
            high = mid - 1
        } else { // 小了
            low = mid + 1
        }
    }
    
    return -1 // 列表中没有指定的元素
}

let list = [1,4,5,6,8,9]
binarySearch(list, item: 0)


/*: # 选择排序
 ## 数组 & 链表
 * 计算机内存犹如一大堆抽屉。
 * 需要存储多个元素时，可使用数组或链表。
 * 数组的元素都在一起。
 * 链表的元素是分开的，其中每个元素都存储了下一个元素的地址。
 * 数组的读取速度很快。
 * 链表的插入和删除速度很快。
 * 在同一个数组中，所有元素的类型都必须相同（都为int、double等）。
 */

func findSmallest(_ arr: [Int]) -> Int {
    var smallest = arr[0]
    for i in 0..<arr.count {
        let n = arr[i]
        if n < smallest {
            smallest = n
        }
    }
    
    return smallest
}

func selectionSort(_ arr: [Int]) -> [Int] {
    var varArr = arr
    var res: [Int] = [Int]()
    for _ in 0..<arr.count {
        let smallest = findSmallest(varArr)
        if let index = varArr.firstIndex(of: smallest) {
            varArr.remove(at: index)
        }
        res.append(smallest)
    }
    
    return res
}


selectionSort([5,3,6,3,10,2,6,9])

/*:
 # 递归&栈

 * 递归指的是调用自己的函数。
 * 每个递归函数都有两个条件：基线条件和递归条件。
 * 栈有两种操作：压入和弹出。
 * 所有函数调用都进入调用栈。
 * 调用栈可能很长，这将占用大量的内存。
 
 */

// 递归求和
func sum(_ arr: [Int], _ l: Int) -> Int {
    return l == 0 ? 0 : sum(arr, l - 1) + arr[l - 1]
}

var arr = [5,3,6]
sum(arr, arr.count)

func getItemCount(_ arr: [Int]) -> Int {
    var varArr = arr
    if arr.isEmpty {
        return 0
    }
    varArr.removeFirst()
    return 1 + getItemCount(varArr)
}

let lisst = [5,6,7,8,9]
getItemCount(lisst)


// 递归求最值
func findMax(_ arr: [Int]) -> Int {
    let arr = arr
    let length = arr.count
    let temp = arr[0]
    
    return findMax(arr, length, temp)
}

func findMax(_ arr: [Int], _ l: Int, _ temp: Int) -> Int {
    var res = temp
    
    if l <= 0 {
        return res
    } else {
        res = arr[l] > res ? arr[l] : res
        return findMax(arr, l - 1, res)
    }
}

arr = [4,5,6,7,8,1,3]
findSmallest(arr)

/*:
 # 快速排序
 分治（D&C）
 基线条件 & 归纳条件
 
 * D&C将问题逐步分解。使用D&C处理列表时，基线条件很可能是空数组或只包含一个元素的数组。
 * 实现快速排序时，请随机地选择用作基准值的元素。快速排序的平均运行时间为O(n log n)。
 * 大O表示法中的常量有时候事关重大，这就是快速排序比合并排序快的原因所在。
 * 比较简单查找和二分查找时，常量几乎无关紧要，因为列表很长时，O(log n)的速度比O(n)快得多。
 */
func quickSort(_ arr: [Int]) -> [Int] {
    if arr.count < 2 {
        return arr
    }
    
    let pivot = arr[0]
    var leftArr: [Int] = []
    var rightArr: [Int] = []
    
    for i in 1..<arr.count {
        if arr[i] < pivot {
            leftArr.append(arr[i])
        } else {
            rightArr.append(arr[i])
        }
    }
    
    return quickSort(leftArr) + [pivot] + quickSort(rightArr)
}

let arr2 = [2,7,8,1,7,1,0,9,4,8,1,4]
let res = quickSort(arr2)

func reverseWords(_ s: String) -> String {
    let arr = s.components(separatedBy: " ")
    var resStr = ""
    for str in arr.reversed() {
        if !resStr.isEmpty && !str.isEmpty {
            resStr += " "
        }
        if !str.isEmpty {
            resStr += str
        }
    }
    
    return resStr
}

reverseWords("Today is a nice day")


/*:
 # 散列表（Hash table）
 是关键码值(Key value)而直接进行访问的数据结构。
 
 ### 散列表应用
 * 模拟映射关系；
 * 防止重复；
 * 缓存/记住数据，以免服务器再通过处理来生成它们。
 */

func romanToInt(_ s: String) -> Int {
    let dic: [Character: Int] = ["I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000]
    var num = 0
    
    for (index, char) in s.enumerated() {
        let value = dic[char]
        if value == nil {
            fatalError("不是罗马字符 \(char)")
        }
        
        if index + 1 < s.count {
            if let next = dic[s[s.index(s.startIndex, offsetBy: index + 1)] as Character] {
                if next > value! {
                    num -= value!
                } else {
                    num += value!
                }
            } else {
                fatalError("不是罗马字符")
            }
        } else {
            num += value!
        }
    }
    return num
}


/*:
 广度优先搜索
 ## 图简介
 图模拟一组连接
 图有节点（node）和边（edge）组成。
 
 ## 广度优先搜索（BFS：Breadth-First Search）
 解决最短路径问题的算法被称为广度优先搜索
 1. 使用图来建立问题模型
 2. 使用广度优先搜索解决问题
 
 广度优先搜索是一种用于图的查找算法，可帮助回答两类问题。
 第一类问题：从节点A出发，有前往节点B的路径吗？
 第二类问题：从节点A出发，前往节点B的哪条路径最短？
 
 */

// 实现队列
struct Queue<Element> {
    // 先进先出原则
    fileprivate var list = Array<Element>()
    var isEmpty: Bool {
        return list.isEmpty
    }
    
    // 长度
    var size: Int {
        return list.count
    }
    
    // 入列
    mutating func enqueue(_ element: Element) {
        list.append(element)
    }
    
    // 出列
    mutating func dequeue() -> Element? {
        if list.isEmpty == false {
            let first = list.first
            list.remove(at: 0)
            return first
        } else {
            return nil
        }
    }
    
    // peek 查看队列的第一个元素
    public mutating func peek() -> Element? {
        return list.first
    }
}

// 构建图
var graph1: [String: [String]] = [:]
graph1["you"] = ["alice", "bob", "claire"]
graph1["bob"] = ["anuj", "peggy"]
graph1["alice"] = ["peggy"]
graph1["claire"] = ["thom", "jonny"]
graph1["anuj"] = []
graph1["peggy"] = []
graph1["thom"] = []
graph1["jonny"] = []

func search(_ name: String) -> Bool {
    // 创建队列
    var search_queue = Queue<[String]>()
    let item = graph1[name]!
    
    search_queue.enqueue(item)
    var searched: [[String]] = []
    
    // 搜索
    while search_queue.isEmpty {
        let person = search_queue.dequeue()!
        if !searched.contains(person) {
            if isSeller(person) {
                return true
            } else {
                search_queue.enqueue(person)
                searched.append(person)
            }
        }
    }
    
    return false
}

func isSeller(_ persons: [String]) -> Bool {
    for person in persons {
        if person == "jonny" {
            return true
        }
    }
    
    return false
}





/*:
 # 狄克斯特拉算法(Dijkstra's algorithm)
 
 要计算非加权图中的最短路径，可使用广度优先搜索。
 要计算加权图中的最短路径，可使用狄克斯特拉算法。
 狄克斯特拉算法只适用于有向无环图（directed acyclic graph，DAG）。
*/



/*:
 # 贪婪算法
 */

// 使用集合来创建所有要覆盖的州
var statesNeeded: Set<String> = ["mt", "wa", "or", "id", "nv", "ut", "ca", "az"]

var stations: [String: Set<String>] = [:]
stations["kone"] = ["id", "nv", "ut"]
stations["ktwo"] = ["wa", "id", "mt"]
stations["kthree"] = ["or", "nv", "ca"]
stations["kfour"] = ["nv", "ut"]
stations["kfive"] = ["ca", "az"]

func greedy(_ statesNeeded: Set<String>) -> Set<String> {
    var varStates = statesNeeded
    var res: Set<String> = []

    while varStates.count > 0 {
        var bestState = ""
        var stateCovered: Set<String> = []
        
        for (station, states) in stations {
            let covered = varStates.intersection(states)
            if covered.count  > stateCovered.count {
                bestState = station
                stateCovered = covered
            }
        }
        
        for sc in stateCovered {
            varStates.remove(sc)
        }
        
        res.insert(bestState)
    }
    
    return res
}

greedy(statesNeeded)

/*:
 1. 先使用一个数组统计每个字符出现的次数。
 2. 再循环这个数组，判断每个字符出现的次数的奇偶。如果为偶数，则回文串的长度就是该字符出现的次数；如果为奇数，则回文串的长度就是该字符出现的次数再减一。
 3. 判断是否有剩余的字符串还剩下一次，则可将这个字符串插入到回文串的中间位置，这样总的结果需再加一。
 */

func longestPalindrome(_ s: String) -> Int {
    if s.count == 0 {
        return 0
    }
    
    // 如果题目给出的只是英文字母的话，最好开一个数组而不是哈希表。
    // 因为数组比哈希表更加单纯、简单。
    // 这一小部分代码就是先将字符串 s 转换成字符，然后统计每个字符所出现的次数
    var freqs: [Int] = Array(repeating: 0, count: 128)
    
    for c in s.utf8CString {
        let i = Int(c)
        if i != 0 {
            freqs[i] += 1
        }
    }
    
    var res = 0 // 用于保存最后的结果，进行返回
    var odd = 0 // 用于统计是否有最后落单的那个字符
    for freq in freqs {
        // 如果某个字符出现的次数为偶数次，则回文串的长度就是该字符出现的次数。
        // 如果某个字符出现的次数为奇数次，则回文串的长度就是该字符出现的次数再减一。
        res += (freq % 2 == 0) ? freq : (freq - 1)
        
        if freq % 2 == 1 {
            // 如果某个字符最后还剩下 1 次，则将这个字符插入到回文串的中间位置
            odd = 1
        }
    }
    
    res += odd
    return res
}

let str = "aahajkldah"

longestPalindrome(str)

/*:
 # 动态规划
 最长公共子序列
 */
func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
    let m = text1.count
    let n = text2.count
    
    var res = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: m + 1)

    var text1Arr = text1.utf8CString
    var text2Arr = text2.utf8CString
    text1Arr.removeLast()
    text2Arr.removeLast()
    
    for i in 1...m {
        for j in 1...n{
            if text1Arr[i - 1] == text2Arr[j - 1] {
                res[i][j] = res[i-1][j-1] + 1
            } else {
                res[i][j] = max(res[i-1][j], res[i][j-1])
            }
        }
    }
    
    print("res:\(res)")
    
    return res[m][n]
}

longestCommonSubsequence("saa", "fada")

/*:
 ## 爬楼梯问题
 有一座高度是n级台阶的楼梯，从下往上走，每跨一步只能向上1级或者2级台阶。
 要求用程序来求出一共有多少种走法。
 问题建模
 边界：f(1) = 1, f(2) = 2
 最优子结构：f(10) = f(9) + f(8)
 状态转移方程：f(n) = f(n - 1) + f(n - 2)
 
 */
func getClimbingWays(_ n: Int) -> Int {
    if n < 0 {
        return 0
    }
    
    if n == 1 {
        return 1
    }
    
    if n == 2 {
        return 2
    }
    
    var a = 1
    var b = 2
    var res = 0
    
    for _ in 3...n {
        res = a + b
        a = b
        b = res
    }
    
    return res
}


