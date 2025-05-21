//
// Created by Muazzam on 06/04/2025.
//

#pragma once

class I_CommunicationLayer {
public:
    virtual ~I_CommunicationLayer() = default;
    virtual void startCommunicationServices() = 0;
    virtual void stopCommunicationServices() = 0;
};

