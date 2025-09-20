<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['action']) || $data['action'] !== 'download_update') {
        echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
        exit;
    }

    $zipUrl = $data['zip_url'];
    
    // ✅ Extract to: /themes/
    $extractPath = realpath(__DIR__ . '/../') . '/'; // One level up from /templates/ to reach /themes/
    $tempZip = $extractPath . 'temp_theme.zip';

    $zipContent = file_get_contents($zipUrl);
    if (!$zipContent) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Could not download update from URL: ' . $zipUrl
        ]);
        exit;
    }

    file_put_contents($tempZip, $zipContent);

    $zip = new ZipArchive;
    if ($zip->open($tempZip) === TRUE) {
        $zip->extractTo($extractPath);
        $zip->close();
        unlink($tempZip);

        // ✅ Empty /themes/xngine/templates_compiled/
        $compiledDir = realpath(__DIR__ . '/../templates_compiled/');
        if ($compiledDir) {
            $files = glob($compiledDir . '/*');
            foreach ($files as $file) {
                if (is_file($file)) {
                    unlink($file);
                }
            }
        }

        echo json_encode([
            'status' => 'success',
            'message' => "✅ Theme updated successfully.<br>Extracted to: $extractPath<br>Cleared: templates_compiled/"
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Failed to extract the zip file.'
        ]);
    }

    exit;
}
