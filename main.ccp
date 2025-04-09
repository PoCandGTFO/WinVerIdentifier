#include <windows.h>
#include <VersionHelpers.h>
#include <cstdio>

OSVERSIONINFOEX GetRealWindowsVersion()
{
	typedef NTSTATUS(NTAPI* RtlGetVersionFunction)(PRTL_OSVERSIONINFOW);

	OSVERSIONINFOEX result;
	ZeroMemory(&result, sizeof(OSVERSIONINFOEX));
	result.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);

	const HMODULE ntdll = GetModuleHandleW(L"ntdll.dll");
	if (ntdll) {
		const auto pRtlGetVersion = reinterpret_cast<RtlGetVersionFunction>(GetProcAddress(ntdll, "RtlGetVersion"));

		if (pRtlGetVersion) {
			pRtlGetVersion(reinterpret_cast<PRTL_OSVERSIONINFOW>(&result));
		}
	}

	return result;
}

int main()
{
	OSVERSIONINFOEX version = GetRealWindowsVersion();
	printf("Windows version: %lu.%lu (Build %lu)\n",
		version.dwMajorVersion,
		version.dwMinorVersion,
		version.dwBuildNumber);

	return 0;
}
