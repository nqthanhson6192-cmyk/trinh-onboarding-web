#!/bin/bash
# 🚀 Trình Cà Phê Onboarding - macOS GUI GitHub Push Helper

# Di chuyển đến thư mục làm việc
cd "$(dirname "$0")"

# Lấy Username qua Finder AppleScript dialog
USER_NAME=$(osascript <<EOF
tell application "Finder"
    activate
    set theResult to display dialog "Nhập GitHub Username của bạn:" default answer "" with title "GitHub Upload Helper"
    return text returned of theResult
end tell
EOF
)

if [ -z "$USER_NAME" ]; then
  osascript -e 'tell application "Finder" to display alert "Lỗi" message "Bạn chưa nhập Username!"' 2>/dev/null
  exit 1
fi

# Lấy Token qua Finder AppleScript dialog
USER_TOKEN=$(osascript <<EOF
tell application "Finder"
    activate
    set theResult to display dialog "Nhập GitHub Personal Access Token (mã ghp_...) của bạn:" default answer "" with title "GitHub Upload Helper" with hidden answer
    return text returned of theResult
end tell
EOF
)

if [ -z "$USER_TOKEN" ]; then
  osascript -e 'tell application "Finder" to display alert "Lỗi" message "Bạn chưa nhập Token!"' 2>/dev/null
  exit 1
fi

echo "🔄 Đang tiến hành đẩy mã nguồn lên GitHub cho tài khoản ${USER_NAME}..."

# Thiết lập Git và đẩy code lên bằng cách ghép credentials vào URL
git remote remove origin 2>/dev/null
git remote add origin "https://${USER_NAME}:${USER_TOKEN}@github.com/trinhcaphe/trinh-onboarding-web.git"
git branch -M main

# Thực hiện push
git push -u origin main

if [ $? -eq 0 ]; then
  echo "✅ Đã đẩy mã nguồn lên GitHub hoàn tất!"
  osascript -e 'tell application "Finder" to display alert "Thành công!" message "Đã đẩy mã nguồn lên GitHub hoàn tất!"' 2>/dev/null
  
  # Khôi phục remote sạch không lộ token trong cấu hình local
  git remote remove origin
  git remote add origin "https://github.com/trinhcaphe/trinh-onboarding-web.git"
else
  echo "❌ Thất bại: Không thể đẩy code lên GitHub."
  osascript -e 'tell application "Finder" to display alert "Thất bại" message "Không thể đẩy code lên GitHub. Vui lòng kiểm tra lại Username hoặc mã Token!"' 2>/dev/null
  
  git remote remove origin
  git remote add origin "https://github.com/trinhcaphe/trinh-onboarding-web.git"
fi
