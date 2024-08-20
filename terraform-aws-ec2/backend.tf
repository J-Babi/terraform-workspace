terraform { 
  cloud { 
    
    organization = "babis-jul" 

    workspaces { 
      name = "aws-msr-cast-dev" 
    } 
  } 
}
