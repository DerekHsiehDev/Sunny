

import Foundation

struct WorldCities : Codable, Identifiable, Hashable {
   
    

    let city : String?

    let country : String?
  
    let id : Int?
   

    enum CodingKeys: String, CodingKey {

        case city = "city"
     
        case country = "country"
        
        
        case id = "id"
  
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }

}
