/**
 * A stock market server used to insert and adjust stock price information
 *   Copyright (C) 2020 ginclene@miamioh.edu
 */
#include <boost/asio.hpp>
#include <iostream>
#include <string>
#include <sstream>
#include <thread>
#include <memory>
#include <unordered_map>
#include <mutex>
#include <iomanip>

// Setup a server socket to accept connections on the socket
using namespace boost::asio;
using namespace boost::asio::ip;

// Alias to an unordered_map that holds account number and balance.
using Market = std::unordered_map<std::string, double>;

// A garbage-collected container to hold client I/O stream in threads
using TcpStreamPtr = std::shared_ptr<tcp::iostream>;

// Class to hold unorderedmap of stocks and a stock mutex
class Stock {
public:
    Market stocks;
    std::mutex stockmutex;
};

std::string url_decode(std::string);

/**
 * Sends output to client as outlined
 * @param os the output stream
 * @param message the message to send to the client
 */
void sendMessage(std::ostream& os, const std::string& message) {
    os << "HTTP/1.1 200 OK\r\n"
            << "Server: StockServer\r\n"
            << "Content-Length: " << message.size() << "\r\n"
            << "Connection: Close\r\n"
            << "Content-Type: text/plain\r\n\r\n"
            << message;
}

/**
 * updates the price of a given stock
 * @param trans either an addition or subtraction to the current price
 * @param price the current price of the stock
 * @param ticker the stock identifer
 * @param stock the object holding our unorderedmap of stocks
 * @return message stating the price has been updated
 */
std::string updatePrice(const std::string& trans, double price,
        const std::string& ticker, Stock& stock) {
    if (trans == "down") {
        price = -price;
    } 
    stock.stocks[ticker] += price;
    return "Stock price updated";
}

/**
 * Creates a new stock if it does not already exist
 * @param ticker the stock identifer
 * @param stock the object holding the unorderedmap of stocks
 * @return message stating either the stock has been made or already exists
 */
std::string checkCreation(const std::string& ticker, Stock& stock) {
    std::lock_guard<std::mutex> guard(stock.stockmutex);
    if (stock.stocks.find(ticker) == stock.stocks.end()) {
        stock.stocks[ticker] = 0;
        return "Stock " + ticker + " created";
    }
    return "Stock " + ticker + " already exists";
}

/**
 * Checks the current status of a given stock i.e. the current price
 * @param ticker The stock identifier
 * @param stock The object holding the unordered map
 * @return the current price of the stock
 */
std::string status(const std::string& ticker, Stock& stock) {
    std::ostringstream os;
    os << "Stock " << ticker << ": $"
            <<std::fixed << std::setprecision(2) << stock.stocks[ticker];
    return os.str();
}

/**
 * processes the request given by client to determine response
 * @param ticker the stock identifier 
 * @param trans the action request being asked
 * @param price the associated value of a given stock
 * @param stock the object holding the unorderedmap of stocks
 * @return the resulting message based off of request type
 */
std::string process(const std::string& ticker, const std::string& trans,
        const double price, Stock& stock) {
    std::string message = "Invalid request";
    if (trans == "reset") {
        std::lock_guard<std::mutex> guard(stock.stockmutex);
        stock.stocks.clear();
        message = "All stocks reset";
    } else if (trans == "create") {
        message = checkCreation(ticker, stock);
    } else {
        std::lock_guard<std::mutex> guard(stock.stockmutex);
        if (stock.stocks.find(ticker) == stock.stocks.end()) {
            message == "Stock not found";
        } else {
            if (trans == "status") {
            message = status(ticker, stock);
        } else if ((trans == "up") || (trans == "down")) {
            message = updatePrice(trans, price, ticker, stock);
        }  
        }
    }
    return message;
}

/**
 * Reads in the request to be processed 
 * @param client A garbage container to hold client I/O stream in threads
 * @param stock the object in which stocks will be stored 
 */
void clientThr(TcpStreamPtr client, Stock& stock) {
    std::string line, request, ticker, trans;
    double price = 0;
    *client >> line >> request;
    while (std::getline(*client, line), line != "\r") {}
    request = url_decode(request);
    std::replace(request.begin(), request.end(), '&', ' ');
    std::replace(request.begin(), request.end(), '=', ' ');
    std::istringstream is(request);
    is >> line >> trans >> line >> ticker >> line >> price;
    std::string result = process(ticker, trans, price, stock);
    sendMessage(*client, result);
}

/**
 * Top-level method to run a custom HTTP server to process bank
 * transaction requests using multiple threads. Each request should
 * be processed using a separate detached thread. This method just loops 
 * for-ever.
 *
 * @param server The boost::tcp::acceptor object to be used to accept
 * connections from various clients.
 */
void runServer(tcp::acceptor& server) {
    // Implement this method to meet the requirements of the
    // homework. See earlier labs on using detached threads with
    // web-server for examples.

    // Needless to say first you should create stubs for the various 
    // operations, write comments, and then implement the methods.
    //
    // First get the base case operational. Submit it via CODE for
    // extra testing. Then you can work on the multithreading case.
    Stock stock;
    while (true) {
        TcpStreamPtr client = std::make_shared<tcp::iostream>();
        server.accept(*client->rdbuf());
        std::thread thr(clientThr, client, std::ref(stock));
        thr.detach();
    }
}

//-------------------------------------------------------------------
//  DO  NOT   MODIFY  CODE  BELOW  THIS  LINE
//-------------------------------------------------------------------

/** Convenience method to decode HTML/URL encoded strings.

    This method must be used to decode query string parameters
    supplied along with GET request.  This method converts URL encoded
    entities in the from %nn (where 'n' is a hexadecimal digit) to
    corresponding ASCII characters.

    \param[in] str The string to be decoded.  If the string does not
    have any URL encoded characters then this original string is
    returned.  So it is always safe to call this method!

    \return The decoded string.
*/
std::string url_decode(std::string str) {
    // Decode entities in the from "%xx"
    size_t pos = 0;
    while ((pos = str.find_first_of("%+", pos)) != std::string::npos) {
        switch (str.at(pos)) {
            case '+': str.replace(pos, 1, " ");
            break;
            case '%': {
                std::string hex = str.substr(pos + 1, 2);
                char ascii = std::stoi(hex, nullptr, 16);
                str.replace(pos, 3, 1, ascii);
            }
        }
        pos++;
    }
    return str;
}

// Helper method for testing.
void checkRunClient(const std::string& port);

/*
 * The main method that performs the basic task of accepting
 * connections from the user and processing each request using
 * multiple threads.
 */
int main(int argc, char** argv) {
    // Setup the port number for use by the server
    const int port = (argc > 1 ? std::stoi(argv[1]) : 0);
    io_service service;
    // Create end point.  If port is zero a random port will be set
    tcp::endpoint myEndpoint(tcp::v4(), port);
    tcp::acceptor server(service, myEndpoint);  // create a server socket
    // Print information where the server is operating.    
    std::cout << "Listening for commands on port "
              << server.local_endpoint().port() << std::endl;
    // Check run tester client.
#ifdef TEST_CLIENT
    checkRunClient(argv[1]);
#endif

    // Run the server on the specified acceptor
    runServer(server);
    
    // All done.
    return 0;
}

// End of source code

