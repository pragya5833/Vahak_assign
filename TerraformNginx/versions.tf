terraform{
    required_version= "0.12.16"
    backend "s3"{
        bucket = "tfstatevahak"
        key = "nginx"
        region = "ap-south-1"
    }
}