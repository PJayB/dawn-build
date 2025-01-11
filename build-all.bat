cmake -S . -B build/mt -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
cmake -S . -B build/mt_dll -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL
cmake -S . -B build/mtd -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug
cmake -S . -B build/mtd_dll -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebugDLL

cmake --build build/mt
cmake --build build/mt_dll
cmake --build build/mtd
cmake --build build/mtd_dll

cmake --install build/mt --prefix install
cmake --install build/mt_dll --prefix install
cmake --install build/mtd --prefix install
cmake --install build/mtd_dll --prefix install
