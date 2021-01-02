

import Foundation

struct WorldCities : Codable, Identifiable, Hashable {
   
    

    let city : String?

    let country : String?
  
    let id : Int?
    
    let lat: Double?
    
    let lng: Double?
   

    enum CodingKeys: String, CodingKey {

        case city = "city"
     
        case country = "country"
        
        
        case id = "id"
        
        case lat = "lat"
        
        case lng = "lng"
  
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lng = try values.decodeIfPresent(Double.self, forKey: .lng)
    }

}
