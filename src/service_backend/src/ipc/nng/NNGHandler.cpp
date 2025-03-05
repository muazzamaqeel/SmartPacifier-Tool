    //
    // Created by muazz on 02/03/2025.
    //

    #include "NNGHandler.h"

    #include <iostream>

    NNGHandler::NNGHandler() {
        // Initialize NNG resources if needed.
    }

    NNGHandler::~NNGHandler() {
        // Clean up NNG resources if needed.
    }

    void NNGHandler::send_message(const std::string& message) {
        std::cout << "NNGHandler: sending message: " << message << std::endl;
    }
