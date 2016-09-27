/* The Computer Language Benchmarks Game
 http://benchmarksgame.alioth.debian.org/
 contributed by Sergo Beruashvili
 parallelized by Daniel Muellenborn
 */

import Dispatch

indirect enum BinaryTree {
   case node(left: BinaryTree, right: BinaryTree, data: Int)
   case empty
   
   func check() -> Int {
      
      switch self {
      case let .node(left, right, data):
         return data + left.check() - right.check()
         
      case .empty:
         return 0
      }
      
   }
}

func bottomUpTree(_ item: Int, _ depth: Int) -> BinaryTree {
   if depth > 0 {
      return BinaryTree.node(left: bottomUpTree(2 * item - 1, depth - 1),
                             right: bottomUpTree(2 * item, depth - 1),
                             data: item)
   }
   return BinaryTree.empty
}

let n: Int = 20 // Int(CommandLine.arguments[1])!
let minDepth = 4
let maxDepth = n
let stretchDepth = n + 1

print("stretch tree of depth \(stretchDepth)\t check: \(bottomUpTree(0,stretchDepth).check())")

let longLivedTree = bottomUpTree(0,maxDepth)
let queue = DispatchQueue.global(qos: .default)

for depth in stride(from:minDepth, to: maxDepth+1, by: 2) {
   let iterations = 1 << (maxDepth - depth + minDepth)
   var check = 0
   DispatchQueue.concurrentPerform(iterations: iterations) { i in
      check += bottomUpTree(i,depth).check() + bottomUpTree(-i,depth).check()
   }
   print("\(iterations*2)\t trees of depth \(depth)\t check: \(check)")
}

print("long lived tree of depth \(maxDepth)\t check: \(longLivedTree.check())")
