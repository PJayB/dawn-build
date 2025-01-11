#include <webgpu/webgpu.h>

#ifdef WIN32
#include <Windows.h>
BOOL APIENTRY DllMain(HANDLE hModule, DWORD ulReasonForCall, LPVOID lpReserved)
{
    return TRUE;
}
#endif // WIN32
