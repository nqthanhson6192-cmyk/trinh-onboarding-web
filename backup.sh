#!/bin/bash
# ------------------------------------------------------------------
# 🛡️ TRÌNH CÀ PHÊ - SCRIPT SAO LƯU DỮ LIỆU TỰ ĐỘNG (LIGHTWEIGHT BACKUP)
# ------------------------------------------------------------------
# Script này sẽ tự động nén toàn bộ ghi chú Obsidian, mã nguồn dự án 
# và toàn bộ lịch sử chat với trợ lý AI (Antigravity/Gemini) thành 1 file ZIP.
# Các thư mục rác, cache nặng (node_modules, .next, web video) sẽ bị loại bỏ 
# để tối ưu hóa dung lượng (giảm từ 20GB+ xuống chỉ còn khoảng ~300MB!).
# ------------------------------------------------------------------

# Thiết lập đường dẫn nguồn
WORKSPACE_DIR="/Users/thanhson/Documents/AI Note"
GEMINI_DIR="/Users/thanhson/.gemini/antigravity"

# Thiết lập nơi lưu trữ file backup (Mặc định là Desktop để dễ tìm)
BACKUP_DEST="/Users/thanhson/Desktop"
DATE_STR=$(date +%Y-%m-%d_%H-%M-%S)
ZIP_FILE_NAME="Backup_AI_Note_Gemini_${DATE_STR}.zip"
TEMP_DIR="/Users/thanhson/.gemini/antigravity/scratch/backup_temp_${DATE_STR}"

echo "=========================================================="
echo "🛡️  BẮT ĐẦU QUÁ TRÌNH SAO LƯU DỮ LIỆU AN TOÀN..."
echo "=========================================================="
echo ""

# Tạo thư mục tạm thời
mkdir -p "$TEMP_DIR"

# 1. Sao lưu Workspace (AI Note)
echo "📦 Bước 1: Chuẩn bị sao lưu thư mục ghi chú & dự án..."
echo "📍 Nguồn: $WORKSPACE_DIR"
echo "🔄 Đang nén các tệp dự án (đã bỏ qua node_modules, cache và file cài đặt CLI)..."

# Tạo file zip tạm thời cho Workspace
# Sử dụng zip với tuỳ chọn exclude chính xác
cd "/Users/thanhson/Documents"
zip -r -q "$TEMP_DIR/AI_Note_Backup.zip" "AI Note" \
    -x "AI Note/*/node_modules/*" \
    -x "AI Note/*/.next/*" \
    -x "AI Note/*/.git/*" \
    -x "AI Note/*.tar.gz" \
    -x "AI Note/*.tgz" \
    -x "AI Note/*/scratch/node-v*" \
    -x "AI Note/*/scratch/node.tar.gz"

echo "✅ Đã nén xong Workspace."
echo ""

# 2. Sao lưu Lịch sử chat & Cấu hình Antigravity (Gemini)
echo "📦 Bước 2: Chuẩn bị sao lưu lịch sử trò chuyện & cấu hình AI..."
echo "📍 Nguồn: $GEMINI_DIR"
echo "🔄 Đang nén lịch sử chat (đã bỏ qua các video/ảnh chụp màn hình duyệt web nặng)..."

# Tạo file zip tạm thời cho Gemini
cd "/Users/thanhson/.gemini"
zip -r -q "$TEMP_DIR/Gemini_Backup.zip" "antigravity" \
    -x "antigravity/browser_recordings/*" \
    -x "antigravity/brain/*/workspace/*" \
    -x "antigravity/brain/**/*.png" \
    -x "antigravity/brain/**/*.webp" \
    -x "antigravity/brain/**/*.mp4" \
    -x "antigravity/scratch/*"

echo "✅ Đã nén xong Lịch sử Chat."
echo ""

# 3. Gộp thành file ZIP cuối cùng
echo "📦 Bước 3: Đang đóng gói thành tệp tin sao lưu duy nhất..."
cd "$TEMP_DIR"
zip -q "$BACKUP_DEST/$ZIP_FILE_NAME" AI_Note_Backup.zip Gemini_Backup.zip

# Dọn dẹp thư mục tạm
rm -rf "$TEMP_DIR"

echo ""
echo "=========================================================="
echo "🎉 SAO LƯU THÀNH CÔNG RỰC RỠ!"
echo "=========================================================="
echo "📍 File sao lưu được lưu tại: $BACKUP_DEST/$ZIP_FILE_NAME"
echo "📊 Dung lượng file backup:"
du -h "$BACKUP_DEST/$ZIP_FILE_NAME"
echo "=========================================================="
echo "💡 Gợi ý: Hãy sao chép file .zip này lên Google Drive,"
echo "   OneDrive, USB hoặc ổ cứng di động để đảm bảo an toàn tuyệt đối!"
echo "=========================================================="
