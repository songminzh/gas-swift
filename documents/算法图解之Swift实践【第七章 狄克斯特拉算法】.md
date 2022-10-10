## 使用狄克斯特拉算法
为了解决在图中**找出最快路径**的问题，我们可以使用**狄克斯特拉算法**（Dijkstra's algorithm）。

### 实现步骤
1. 找出最便宜的节点，即可在最短时间内前往的节点。
2. 对于该节点的邻居，检查是否有前往它们的更短路径，如果有，就更新其开销。
3. 重复这个过程，直到对图中的每个节点都这样做了。
4. 计算最终路径。

## 相关术语 
* 权重（weight）：狄克斯特拉算法用于每条边都有关联数字的图，这些数字称为权重。
* 加权图（weighted graph）：带权重的图称为加权图。
* 非加权图（unweighted graph）：不带权重的图称为非加权图。
* 环：从一个节点出发，走一圈之后又回到这个节点的图称为环。

## 适用场景 
要计算非加权图中的最短路径，可使用广度优先搜索。
要计算加权图中的最短路径，可使用狄克斯特拉算法。
狄克斯特拉算法只适用于**有向无环图**（directed acyclic graph，DAG）。

## 负权边
在图中，可能出现边的权重为负数的情况，即经过这条边时，花销反而减少。
**如果图中有负权边，则不能使用狄克斯特拉算法**。
因为狄克斯特拉算法有一个前提：对于处理过的节点，没有前往该节点的更短路径。而负权边破坏了这一前提，是使用算法的前提条件不成立。
在包含负权边的图中，要找出最短路径，可使用另一种算法 —— 贝尔曼-福德算法（Bellman-Ford algorithm）。

## 实现
以下面的图为例。
![截屏2022-09-28 17.30.20](assets/%E6%88%AA%E5%B1%8F2022-09-28%2017.30.20.png)
要编写解决这个问题的代码，需要三个散列表。

![截屏2022-09-28 17.34.07](assets/%E6%88%AA%E5%B1%8F2022-09-28%2017.34.07.png)

随着算法的进行，你将不断更新散列表costs和parents。
首先需要实现这个图，由于需要同时存储邻居和前往邻居的开销，因此需要使用一个散列表嵌套另一个散列表。

```Swift
graph["start"] = {}
graph["start"]["a"] = 6
graph["start"]["b"] = 2
```

另外，仍需要一个散列表来存储每个节点的开销（指从起点出发前往该节点需要的时间）—— costs。
以及一个散列表存储父节点，用来更新最短路径 —— parents。
最后还需要一个数组用来记录处理过的节点，因为对于同一个节点，不需要多次处理 —— processed。

算法的整体流程图如下：

![截屏2022-09-28 17.41.53](assets/%E6%88%AA%E5%B1%8F2022-09-28%2017.41.53.png)

Swift代码实现如下：

```Swift
// 构建图
var graph: [String: [String: Int]] = [:]
graph["start"] = [:]
graph["start"]!["a"] = 6
graph["start"]!["b"] = 2

graph["a"] = [:]
graph["a"]!["fin"] = 1

graph["b"] = [:]
graph["b"]!["a"] = 3
graph["b"]!["fin"] = 5

graph["fin"] = [:] // 终点没有邻节点

print("graph:\(graph)")

let infinity = Int(MAXINTERP) // 无穷大

// 存储每个节点开销的字典
var costs: [String: Int] = [:]
costs["a"] = 6
costs["b"] = 2
costs["fin"] = infinity

var parents: [String: String] = [:]
parents["a"] = "start"
parents["b"] = "start"
parents["fin"] = ""

// 记录处理过的节点
var processed: [String] = []

func findLowestCostNode(_ costs: [String: Int]) -> String {
    var lowestCost = infinity
    var lowestCostNode = ""
    for (node, _) in costs {
        let cost = costs[node]!
        // 如果当前节点的开销更低且未处理过
        if cost < lowestCost, processed.contains(node) {
            lowestCost = cost
            lowestCostNode = node
        }
    }
    
    return lowestCostNode
}

func Dijkstra() {
    var node = findLowestCostNode(costs)
    let cost = costs[node]!
    let neightbors = graph[node] ?? [:]
    for (n, _) in neightbors {
        let newCost = cost + neightbors[n]!
        
        if costs[n]! > newCost {
            costs[n] = newCost // 更新改邻节点的开销
            parents[n] = node // 同时将该邻节点的父节点设置为当前节点
        }
    }
    
    processed.append(node)
    node = findLowestCostNode(costs)
    
    print("node:\(node)")
}

Dijkstra()

```

## 练习
7.1 在下面的各个图中，从起点到终点的最短路径的总权重分别是多少？
![截屏2022-09-29 15.09.59](assets/%E6%88%AA%E5%B1%8F2022-09-29%2015.09.59.png)


> A: 5 + 2 + 1 = 8
> 
> B: 10 + 20 + 30 = 60
> 
> C: 无法使用狄克斯特拉算法找出最短路径，因为存在负权边。

## 小结
* 广度优先搜索用于在非加权图中查找最短路径。
* 狄克斯特拉算法用于在加权图中查找最短路径。
* 仅当权重为正时狄克斯特拉算法才管用。
* 如果图中包含负权边，请使用贝尔曼-福德算法。

