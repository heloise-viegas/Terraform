resource "aws_eks_cluster" "demo-eks-cluster" {
  name = "demo-eks-cluster"

  role_arn = aws_iam_role.cluster-role.arn
  version  = "1.31"

  vpc_config {
    subnet_ids =concat(
      aws_subnet.public[*].id,
      aws_subnet.private[*].id
    )
    
    # [
    #   "subnet-01955f31b9b5ddf38",
    #   "subnet-072a519a536546941",
    #   "subnet-08599f42d573a3772",
    # ]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "cluster-role" {
  name = "demo-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-role.name
}