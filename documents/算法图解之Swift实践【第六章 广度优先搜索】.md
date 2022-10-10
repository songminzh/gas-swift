> 广度优先搜索（breadth-first search，BFS）是一种图算法。
> 
> 
## 图简介
图模拟一组连接。
图有节点（node）和边（edge）组成。
边包含有向边和无向边。
一个节点可能与众多的节点直接相连，直接相连的节点被称为邻节点。在一个图中，可以有许多节点和边。

## 广度优先搜索
解决最短路径问题的算法被称为广度优先搜索。
1. 使用图来建立问题模型。
2. 使用广度优先搜索解决问题。

广度优先搜索是一种用于图的查找算法，可帮助回答两类问题。
* 第一类问题：从节点A出发，有前往节点B的路径吗？
* 第二类问题：从节点A出发，前往节点B的哪条路径最短？

对于第一类问题，路径是否存在，广度优先搜索的方式是：
1. 创建包含节点A的邻节点的列表。
2. 检查这些邻节点是否为节点B，若为节点B，则搜索完成。
3. 若不为节点B，则将该节点其余节点加入到列表中，继续搜索其余节点。
**这就是广度优先搜索算法。**

## 队列
为了将节点按顺序添加，需要使用数据结构，那就是队列（queue）。
队列只支持两种操作：**入队**和**出队**。
队列类似于栈，不能随机地访问队列中的元素。
但与栈后进先出（Last In First Out，LIFO）不同的是，队列是一种**先进先出**（First In First Out，FIFO）的数据结构。

## 实现图
节点与相邻节点的有向连接用散列表来表示。
![截屏2022-09-26 17.30.35](assets/%E6%88%AA%E5%B1%8F2022-09-26%2017.30.35.png)

图不过是一系列的节点和边，以上图的映射关系可以用散列表表示。

```Swift
var graph: [String: [String]] = [:]
graph["you"] = ["alice", "bob", "claire"]
graph["bob"] = ["anuj", "peggy"]
graph["alice"] = ["peggy"]
graph["claire"] = ["thom", "jonny"]
graph["anuj"] = []
graph["peggy"] = []
graph["thom"] = []
graph["jonny"] = []
```

`you`这个节点被映射到了一个数组，因此graph["you"]是一个数组，包含了you的全部相邻节点。
同时，在定义图的时候，定义的先后顺序不重要。
上图中的图为有向图（directed graph），其中的关系是单向的。

## 实现算法
所谓广度优先搜索，就是从图中的某个节点出发，寻找紧邻的、尚未访问的节点，找到多少就访问多少，然后分别从找到的这些节点出发，继续寻找紧邻的、尚未访问的节点，直到找到目标节点或存放节点的队列被清空。

1. 创建一个队列，用于存储要检查的节点。
2. 从队列中弹出一个节点。
3. 检查这个节点是否为目标节点。
4. 如果是，则找到目标节点。如果不是，则将这个节点的所有邻居节点加入队列中。
5. 若此时队列为空，则目标节点不存在。
6. 重复步骤2-5，直到找到目标节点或队列为空。

**实现队列**

```Swift
struct Queue<T> {
    // 基于数组
    fileprivate var list = Array<T>()
    // 属性，队列是否为空
    var isEmpty: Bool {
        return list.isEmpty
    }
    
    // 入列
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    // 出列
    public mutating func dequeue() -> T? {
        if list.isEmpty == false {
            let first = list.first
            list.remove(at: 0)
            return first
        } else {
            return nil
        }
    }
    
    // peek 查看队列的第一个元素
    public mutating func peek() -> T? {
        return list.first
    }
}
```

**判断是否为目标节点**

```Swift
func isSeller(_ persons: [String]) -> Bool {
    for person in persons {
        if person == "jonny" {
            return true
        }
    }
    
    return false
}
```

**搜索是否存在目标节点**

```Swift
func search(_ name: String) -> Bool {
    // 创建队列
    var search_queue = Queue<[String]>()
    let item = graph[name]!
    
    search_queue.enqueue(item)
    var searched: [[String]] = [] // 记录已搜索节点，避免进入死循环
    
    // 搜索
    while search_queue.isEmpty { // 搜索列表不为空，继续循环
        let person = search_queue.dequeue()!
        if !searched.contains(person) { // 判断当前节点是否已搜索
            if isSeller(person) { // 找到目标节点，返回`true`
                return true
            } else { // 不是目标节点
                search_queue.enqueue(person) // 将该节点的所有邻节点都入队
                searched.append(person) // 标记该节点已搜索
            }
        }
    }
    
    return false // 搜索列表为空，循环结束，没有找到目标节点
}
```

## 树
从某种程度上说，这种列表是有序的。如果任务A依赖于任务B，在列表中任务A就必须在任务B后面。这被称为**拓扑排序**，使用它可根据图创建一个有序列表。假设你正在规划一场婚礼，并有一个很大的图，其中充斥着需要做的事情，但却不知道要从哪里开始。这时就可使用拓扑排序来创建一个有序的任务列表。
假设你有一个家谱。
![截屏2022-09-27 09.04.24](assets/%E6%88%AA%E5%B1%8F2022-09-27%2009.04.24.png)
这是一个图，因为它由节点（人）和边组成。其中的边从一个节点指向其父母，但所有的边都往下指。在家谱中，往上指的边不合情理！因为你父亲不可能是你祖父的父亲！
![截屏2022-09-27 09.05.18](assets/%E6%88%AA%E5%B1%8F2022-09-27%2009.05.18.png)
这种图被称为**树**。树是一种特殊的图，其中没有往后指的边。
树里的每一个节点有一个值和一个包含所有子节点的列表。从图的观点来看，树也可视为一个拥有N 个节点和N-1 条边的一个有向无环图。

## 练习
对于下面的每个图，使用广度优先搜索算法来找出答案。
6.1 找出从起点到终点的最短路径的长度。
![截屏2022-09-26 16.56.38](assets/%E6%88%AA%E5%B1%8F2022-09-26%2016.56.38.png)

> 最短路径的长度为2。

6.2 找出从cab到bat的最短路径的长度。
![截屏2022-09-26 16.58.51](assets/%E6%88%AA%E5%B1%8F2022-09-26%2016.58.51.png)

> 最短路径的长度为2。

下面的小图说明了我早晨起床后要做的事情。
![题图](assets/%E6%88%AA%E5%B1%8F2022-09-26%2016.53.25.png)


该图指出，我不能没刷牙就吃早餐，因此“吃早餐”依赖于“刷牙”。
另一方面，洗澡不依赖于刷牙，因为我可以先洗澡再刷牙。根据这个图，可创建一个列表，指出我需要按什么顺序完成早晨起床后要做的事情：
(1) 起床
(2) 洗澡
(3) 刷牙
(4) 吃早餐
请注意，“洗澡”可随便移动，因此下面的列表也可行：
(1) 起床
(2) 刷牙
(3) 洗澡
(4) 吃早

6.3 请问下面的三个列表哪些可行、哪些不可行？
![题图6.3](assets/%E6%88%AA%E5%B1%8F2022-09-26%2016.55.18.png)
A：不可行，吃早餐依赖于刷牙，因此3不能再4前面。
B：可行，符合图的顺序。
C：不可行，洗澡依赖于起床，因此1不能再2前面。

6.4 下面是一个更大的图，请根据它创建一个可行的列表。
![截屏2022-09-27 09.04.03](assets/%E6%88%AA%E5%B1%8F2022-09-27%2009.04.03.png)

> 1.起床 2.锻炼 3.洗澡 4.穿衣服 5.刷牙 6.吃早餐 7.打包午餐

6.5 请问下面哪个图也是树？
![截屏2022-09-27 09.09.54](assets/%E6%88%AA%E5%B1%8F2022-09-27%2009.09.54.png)
> A是树，B不是树，C是树
> 
> A和C没有往后指的边，因此是树；B有向后指的边，因此不是树。

## 小结

* 广度优先搜索指出是否有从A到B的路径。
* 如果有，广度优先搜索将找出最短路径。
* 面临类似于寻找最短路径的问题时，可尝试使用图来建立模型，再使用广度优先搜索来解决问题。
* 有向图中的边为箭头，箭头的方向指定了关系的方向，例如，rama→adit表示rama欠adit钱。
* 无向图中的边不带箭头，其中的关系是双向的，例如，ross - rachel表示“ross与rachel约会，而rachel也与ross约会”。
* 队列是先进先出（FIFO）的。
* 栈是后进先出（LIFO）的。
* 你需要按加入顺序检查搜索列表中的人，否则找到的就不是最短路径，因此搜索列表必须是队列。
* 对于检查过的人，务必不要再去检查，否则可能导致无限循环。

## 拓展与应用

[LeetCode 104. 二叉树的最大深度](https://leetcode.cn/problems/maximum-depth-of-binary-tree/)

给定一个二叉树，找出其最大深度。
二叉树的深度为根节点到最远叶子节点的最长路径上的节点数。

说明: 叶子节点是指没有子节点的节点。

示例：
给定二叉树 [3,9,20,null,null,15,7]，

    3
   / \
  9  20
    /  \
   15   7
返回它的最大深度 3 。

首先构建二叉树
```Swift
public class TreeNode {
     public var val: Int
     public var left: TreeNode?
     public var right: TreeNode?
     public init() { self.val = 0; self.left = nil; self.right = nil; }
     public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
     public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
         self.val = val
         self.left = left
         self.right = right
     }
}
```
运用BFS求最大深度：
1. 将根节点入队
2. 当队列不为空时，对每一层的节点进行入列与出列操作，每遍历一层，深度+1，当队列为空时结束循环，返回最终计算得到的深度。

```Swift
func maxDepth(_ root: TreeNode?) -> Int {
    if root == nil {
        return 0
    }
    
    var queue: [TreeNode] = [root!]
    var depth = 0
    
    while !queue.isEmpty {
        for _ in 0..<queue.count {
            let node = queue.removeFirst()
            if node.left != nil {
                queue.append(node.left!)
            }
            if node.right != nil {
                queue.append(node.right!)
            }
        }
        
        depth += 1
    }
    
    return depth
}
```