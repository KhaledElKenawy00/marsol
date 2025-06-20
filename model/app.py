from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import numpy as np
from ultralytics import YOLO
import base64
import os
import logging

app = Flask(__name__)
CORS(app, resources={r"/detect": {"origins": "*"}})

# إعداد التسجيل
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

# التأكد من وجود نماذج YOLO
arabic_model_path = r"D:\best_ASL.pt"  # تأكدي من تحديث المسار إذا لزم الأمر
english_model_path = r"D:\best.pt"  # تأserver.pyكدي من تحديث المسار إذا لزم الأمر

if not os.path.exists(arabic_model_path):
    logging.error(f"Arabic YOLO model not found at {arabic_model_path}")
    raise FileNotFoundError(f"Arabic YOLO model not found at {arabic_model_path}")
if not os.path.exists(english_model_path):
    logging.error(f"English YOLO model not found at {english_model_path}")
    raise FileNotFoundError(f"English YOLO model not found at {english_model_path}")

# تحميل النماذج مع تحديد نوع المهمة
logging.info("Loading YOLO models...")
yolo_model_arabic = YOLO(arabic_model_path, task='detect')
yolo_model_english = YOLO(english_model_path, task='detect')
logging.info("YOLO models loaded successfully")

# قواميس الحروف
yolo_arabic_index = {
    0: 'ع', 1: 'ال', 2: 'ا', 3: 'ب', 4: 'د', 5: 'ظ', 6: 'ض', 7: 'ف', 8: 'ق', 9: 'غ', 10: 'ه',
    11: 'ح', 12: 'ج', 13: 'ك', 14: 'خ', 15: ' ', 16: 'ل', 17: 'م', 18: 'ن', 19: 'ر', 20: 'ص',
    21: 'س', 22: 'ش', 23: 'ت', 24: 'ط', 25: 'ث', 26: 'ذ', 27: 'و', 28: 'ي', 29: 'ز'
}

yolo_english_index = {
    0: 'A', 1: 'B', 2: 'C', 3: 'D', 4: 'E', 5: 'F', 6: 'G', 7: 'H', 8: 'I', 9: 'J',
    10: 'K', 11: 'L', 12: 'M', 13: 'N', 14: 'O', 15: 'P', 16: 'Q', 17: 'R', 18: 'S',
    19: 'T', 20: 'U', 21: 'V', 22: 'W', 23: 'X', 24: 'Y', 25: 'Z'
}

@app.route('/detect', methods=['POST'])
def detect():
    try:
        logging.info("Received detection request")
        # التحقق من وجود ملف الصورة
        if 'file' not in request.files:
            logging.error("No file uploaded")
            return jsonify({"error": "No file uploaded"}), 400

        file = request.files['file']
        # قراءة الصورة
        image = cv2.imdecode(np.frombuffer(file.read(), np.uint8), cv2.IMREAD_COLOR)
        if image is None:
            logging.error("Invalid image file")
            return jsonify({"error": "Invalid image file"}), 400

        # تحجيم الصورة لتقليل وقت المعالجة
        max_size = 320
        h, w = image.shape[:2]
        if max(h, w) > max_size:
            scale = max_size / max(h, w)
            image = cv2.resize(image, (int(w * scale), int(h * scale)))

        # الحصول على اللغة
        language = request.form.get('language', 'arabic').lower()
        yolo_model = yolo_model_arabic if language == 'arabic' else yolo_model_english
        yolo_index = yolo_arabic_index if language == 'arabic' else yolo_english_index

        # إجراء التنبؤ باستخدام YOLO
        logging.info(f"Predicting with {language} model...")
        results = yolo_model.predict(image, device='cpu', conf=0.3, iou=0.5, imgsz=320)
        detected_letters = []

        # معالجة النتائج
        if len(results[0].boxes.xyxy) > 0:
            boxes = results[0].boxes.xyxy
            class_ids = [int(i) for i in results[0].boxes.cls]
            confidence = [float(i) for i in results[0].boxes.conf]

            for box, conf, id in zip(boxes, confidence, class_ids):
                if id not in yolo_index or conf < 0.3:
                    logging.debug(f"Skipping detection: class_id={id}, confidence={conf}")
                    continue

                x1, y1, x2, y2 = map(int, box)
                cv2.rectangle(image, (x1, y1), (x2, y2), (0, 255, 0), 2)
                cv2.putText(image, f"{yolo_index[id]} ({conf:.2f})", (x1, y1 - 10),
                           cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)
                detected_letters.append(yolo_index[id])
                logging.info(f"Detected letter: {yolo_index[id]} (confidence={conf:.2f})")

        else:
            logging.info("No detections in this frame")

        # تحويل الصورة إلى base64
        _, img_encoded = cv2.imencode('.jpg', image, [int(cv2.IMWRITE_JPEG_QUALITY), 80])
        img_base64 = base64.b64encode(img_encoded).decode('utf-8')

        logging.info(f"Returning {len(detected_letters)} detected letters")
        return jsonify({
            "detected_letters": detected_letters,
            "formatted_sentence": ''.join(detected_letters),
            "image_with_boxes": img_base64
        })

    except Exception as e:
        logging.error(f"Error in /detect: {str(e)}", exc_info=True)
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    logging.info("Starting Flask server...")
    app.run(host='0.0.0.0', port=5000, debug=True)