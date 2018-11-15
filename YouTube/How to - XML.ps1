#Demonstrate ConvertTo-XML with InputObject
$strXml="C:\Test\xml\Test.xml"
$obj=New-Object -TypeName PSObject -Property @{"Jobtitle"="PowerShell Admin";"Department"="IT";"Name"="Heiko Horn"}
$xml=ConvertTo-Xml -InputObject $obj -As Document
$xml.Save($strXml)
Get-Content $strXml
#Demonstrate ConvertTo-XML with NoTypeInformation
$xml=ConvertTo-Xml -InputObject $obj -NoTypeInformation
$xml.Save($strXml)
Get-Content $strXml
ii $strXml

#Demonstrate selecting node information
$xml.Objects.Object.Property.Name
$xml=ConvertTo-Xml -InputObject $obj -As Document
$xml.Objects.Object.Property.Type
$xml.Objects.Object.Property.InnerText
$xml.Objects.Object.Property.'#text'

#Case sensitive
$xml.SelectNodes("Objects/Object/Property")
$xml.SelectNodes("Objects/Object/Property[@Name=""Jobtitle""]")

#Demonstrate ConvertTo-XML with Pipeline
$xml=New-Object -TypeName xml
$xml=Get-Process A* | ConvertTo-Xml -Depth 1
$xml.Save($strXml)
ii $strXml
$xml.Objects.Object.Property.Name
$xml.SelectNodes("Objects/Object/Property[@Name=""Description"" and @Type=""System.String""]")

#Demonstrate Export-Clixml
$strXml="C:\Test\xml\sample.xml"
"This is a test" | Export-Clixml -Path $strXml
Get-Content $strXml
Get-Date | Export-Clixml $strXml
Get-Content $strXml

#Demonstrate Import-Clixml
Import-Clixml $strXml

#Demonstarate creating XML file
$strXml="c:\test\xml\config.xml"

# Create root node
$xml=New-Object -TypeName XML
$xmlRoot=$xml.CreateElement("Config")
$xml.appendChild($xmlRoot)

# Add a Attribute for root node
$xmlRoot.SetAttribute("Description","Config file for testing")
$xml.Config.Description

#Create child node and set attribute
$xmlL1=$xmlRoot.AppendChild($xml.CreateElement("System"))
$xmlL1.SetAttribute("Description","Document Management")

#Create child of child node and set attribute and text
$xmlL2=$xmlL1.AppendChild($xml.CreateElement("Document"))
$xmlL2.SetAttribute("authorFirstName","First1")
$xmlL2.SetAttribute("authorSurname","Author1")
$xmlL2.SetAttribute("date",$(get-date))
$xmlL2.SetAttribute("description","Document 1")
$xmlL2.SetAttribute("index","3")
$xmlL2.InnerText="C:\temp\doc0001.txt"
# Save File
$xml.Save($strXml)
ii $strXml
$xml.Config.System.Document.description

#Demonstarate removing nodes form xml using RemoveChild
$strXml="c:\test\xml\config1.xml"
$xml=New-Object -TypeName xml
$xml.Load($strXml)
$xml.config.system.document.authorSurname
$nodes = $xml.selectNodes("//document[@authorSurname=""Author5""]")
Foreach ($item in $nodes)
{ 
    $item.ParentNode.RemoveChild($item)
}
$xml.config.System.Document.authorSurname

#Demonstarate replacing a node form xml using ReplaceChild
$strXml="c:\test\xml\config1.xml"
$xml=New-Object -TypeName xml
$xml.Load($strXml)
$oldNode=$xml.SelectSingleNode("//document[last()]")
$oldNode
$newNode=$xml.CreateElement("document")
$newNode.SetAttribute("authorFirstName","Heiko")
$xml.config.System.ReplaceChild($newNode,$oldNode)
$xml.SelectsingleNode("//document[last()]")

#Demonstarate removing nodes form xml using RemoveAll
$strXml="c:\test\xml\config.xml"
$xml.ChildNodes.RemoveAll()
$xml.Save($strXml)
ii $strXml

#Demonstarate getting content using XPath Expressions
$strXml="c:\test\xml\config1.xml"
Get-Content -Path $strXml
$xml=New-Object -TypeName XML
$xml.Load($strXml)

$xml.SelectSingleNode("//document[3]")
$xml.SelectSingleNode("//document[last()-1]")
$xml.SelectSingleNode("//document[3]").GetAttribute("authorFirstName")

$xml.SelectNodes("//document[@index > 4]")
$xml.SelectNodes("//document[contains(@authorSurname,""Aut"")]")
$xml.SelectNodes("//document[starts-with(@date,""201302"")]")

#Demonstarate getting content using Select-Xml
$xml | Select-Xml -XPath "//document" | %{ $_.Node.InnerText } 
