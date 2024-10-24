mod "azure" {
  title         = "Azure"
  description   = "Run pipelines to supercharge your Azure workflows using Flowpipe."
  color         = "#0089D6"
  documentation = file("./README.md")
  icon          = "/images/mods/turbot/azure.svg"
  categories    = ["library", "public cloud"]

  opengraph {
    title       = "Azure Mod for Flowpipe"
    description = "Run pipelines to supercharge your Azure workflows using Flowpipe."
    image       = "/images/mods/turbot/azure-social-graphic.png"
  }

  require {
    flowpipe {
      min_version = "1.0.0"
    }
  }
}
