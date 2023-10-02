terraform {
  backend "s3" {
    bucket         = "three-tier-arch" 
    key            = "terraform.tfstate"        
    region         = "us-east-1"                
    encrypt        = true                       
    }
}

