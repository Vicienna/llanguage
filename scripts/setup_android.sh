#!/usr/bin/env bash
set -euo pipefail

flutter create --platforms android --project-name llanguage .
rm -f test/widget_test.dart

BUILD_FILE=android/app/build.gradle.kts

python3 << 'PYEOF'
with open('android/app/build.gradle.kts') as f:
    content = f.read()

# Add desugaring to compileOptions if not present
if 'isCoreLibraryDesugaringEnabled' not in content:
    import re
    content = re.sub(
        r'(targetCompatibility\s*=\s*JavaVersion\.\w+)',
        r'\1\n        isCoreLibraryDesugaringEnabled = true',
        content
    )

# Add desugar_jdk_libs dependency if missing
if 'desugar_jdk_libs' not in content:
    if 'dependencies {' in content:
        content = content.replace(
            'dependencies {',
            'dependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")'
        )
    else:
        content += '\ndependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")\n}\n'

with open('android/app/build.gradle.kts', 'w') as f:
    f.write(content)
PYEOF

echo "Android setup complete"
