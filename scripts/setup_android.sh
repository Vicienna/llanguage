#!/usr/bin/env bash
set -euo pipefail

flutter create --platforms android --project-name llanguage .
rm -f test/widget_test.dart

BUILD_FILE=android/app/build.gradle.kts

python3 << 'PYEOF'
with open('android/app/build.gradle.kts') as f:
    content = f.read()

if 'isCoreLibraryDesugaringEnabled' not in content:
    content = content.replace(
        'targetCompatibility = JavaVersion.VERSION_11',
        'targetCompatibility = JavaVersion.VERSION_11\n        isCoreLibraryDesugaringEnabled = true'
    )

if 'desugar_jdk_libs' not in content:
    content = content.replace(
        'dependencies {',
        'dependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")'
    )

with open('android/app/build.gradle.kts', 'w') as f:
    f.write(content)
PYEOF

echo "Android setup complete"
