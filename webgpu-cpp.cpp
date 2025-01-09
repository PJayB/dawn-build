#define WGPU_SHARED_LIBRARY
#define WGPU_IMPLEMENTATION
#define WEBGPU_CPP_IMPLEMENTATION
#include <webgpu/webgpu.hpp>

#ifdef WIN32
#include <Windows.h>
BOOL APIENTRY DllMain(HANDLE hModule, DWORD ulReasonForCall, LPVOID lpReserved)
{
    return TRUE;
}
#endif // WIN32
