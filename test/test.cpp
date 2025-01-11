#define WEBGPU_CPP_IMPLEMENTATION
#include <webgpu/webgpu.hpp>
#include <iostream>

int main() {
    wgpu::InstanceDescriptor desc = {};
    wgpu::Instance instance = wgpu::createInstance(desc);
    if (instance) {
        instance.release();
        std::cout << "Success." << std::endl;
        return 0;
    }
    else {
        std::cout << "Failed." << std::endl;
        return 1;
    }
}
