//
//  RESTAPIHelper.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/09.
//

import Foundation

public struct RESTAPIHelper {
  
  public static func requestGet(
    withUrl url: URL,
    params: [String: Any]?,
    completion: @escaping ([String: Any]?) -> Void
  ) {
    var request = buildRequest(fromUrl: url, params: params)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    startURLSession(withRequest: request, completion: completion)
  }

  public static  func requestPost(
    withUrl url: URL,
    params: [String: Any?]?,
    completion: @escaping ([String: Any]?) -> Void
  ) {
    var request = buildRequest(fromUrl: url, params: params)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    startURLSession(withRequest: request, completion: completion)
  }

  public static  func requestPut(
    withUrl url: URL,
    params: [String: Any?]?,
    completion: @escaping ([String: Any]?) -> Void
  ) {
    var request = buildRequest(fromUrl: url, params: params)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    startURLSession(withRequest: request, completion: completion)
  }

  public static  func requestDelete(
    withUrl url: URL,
    params: [String: Any?]?,
    completion: @escaping ([String: Any]?) -> Void
  ) {
    var request = buildRequest(fromUrl: url, params: params)
    request.httpMethod = "DELETE"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    startURLSession(withRequest: request, completion: completion)
  }

  public static  func startURLSession(
    withRequest request: URLRequest,
    completion: @escaping ([String: Any]?) -> Void
  ) {
    print("===== Sending URL session with url = \(String(describing: request.url?.absoluteURL))")
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
        // check for fundamental networking error
        let errorMessage = error?.localizedDescription ?? "Unknown error"
        print("===== Request error", errorMessage)
        completion(["success": false, "error": errorMessage])
        return
      }

      guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
          print("===== Request statusCode should be 2xx, but is \(response.statusCode)")
          print("===== Request response = \(response)")
          completion(["success": false, "result": String(data: data, encoding: .utf8) ?? ""])
          return
      }

      do {
        let jsonResult = try JSONSerialization.jsonObject(
          with: data,
          options:.mutableContainers
        )
        completion(["success": true, "result": jsonResult])
      } catch {
        completion(["success": true])
      }
    }

    task.resume()
  }

  // MARK: - Private

  static func buildRequest(fromUrl url: URL, params: [String:Any?]?) -> URLRequest {
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    if let params = params {
      var queryItems: [URLQueryItem] = []
      for (key, value) in params {
        queryItems.append(URLQueryItem(name: key, value: "\(value ?? "null")"))
      }
      urlComponents.queryItems = queryItems
    }

    return URLRequest(url: urlComponents.url!)
  }
}
