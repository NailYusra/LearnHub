<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\FirestoreService;
use App\Services\FirebaseTokenService;

class ProdiController extends Controller
{
    protected FirestoreService $prodiService, $facultyService;

    public function __construct()
    {
        $this->prodiService = new FirestoreService('prodi', app(FirebaseTokenService::class));
        $this->facultyService = new FirestoreService('faculties', app(FirebaseTokenService::class));
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'faculty_id' => 'required|string',
            'nama' => 'required|string',
        ]);

        // validasi faculty_id
        $facultyList = $this->facultyService->getAllDocuments(); 

        $isFacultyIdValid = collect($facultyList)->contains(function ($item) use ($data) {
            return isset($item['faculty_id']) && $item['faculty_id'] === $data['faculty_id'];
        });

        if (!$isFacultyIdValid) {
            return response()->json(['message' => 'faculty_id tidak ditemukan di database'], 422);
        }

        // 1. Simpan dokumen tanpa faculty_id
        $result = $this->prodiService->createDocument([
            'nama' => $data['nama'],
            'faculty_id' => $data['faculty_id']
        ]);

        // 2. Ambil ID dokumen dari response Firestore
        $docName = $result['name'];
        $parts = explode('/', $docName);
        $prodiId = end($parts);

        // 3. Ambil data dokumen lama
        $oldData = $this->prodiService->getDocumentById('prodi', $prodiId);

        // 4. Extract nilai string dari oldData, atau kosongkan jika tidak ada
        $oldDataPlain = [];
        foreach ($oldData ?? [] as $key => $value) {
            // Karena di getDocumentById kamu ambil 'fields' langsung, setiap field ada tipe stringValue
            $oldDataPlain[$key] = $value['stringValue'] ?? null;
        }

        // 5. Gabungkan data lama dengan faculty_id baru
        $updatedData = array_merge($oldDataPlain, ['prodi_id' => $prodiId]);

        // 6. Update dokumen dengan data lengkap (nama + faculty_id)
        $this->prodiService->updateDocument($prodiId, $updatedData);

        // 7. Gabungkan data untuk dikembalikan ke response
        $data = array_merge($oldDataPlain, ['prodi_id' => $prodiId]);

        return response()->json([
            'message' => 'Prodi berhasil ditambahkan',
            'data' => $data
        ], 201);

    }

    public function index()
    {
        $result = $this->prodiService->getDocuments();

        return response()->json($result);
    }

    public function update(Request $request, string $prodi_id) {
        try {
            $data = $request->validate([
                'faculty_id' => 'nullable|string',
                'nama' => 'nullable|string',
            ]);
        } catch (\Illuminate\Validation\ValidationException $th) {
            return $th->validator->errors();
        }

        // validasi id prodi
        $oldData = $this->prodiService->getDocumentById('prodi', $prodi_id);

        if (!$oldData) {
            return response()->json(['message' => 'prodi tidak ditemukan'], 404);
        }

        // validasi id fakultas baru, kalau ada
        if (isset($data['faculty_id'])) {
            $facultyList = $this->facultyService->getAllDocuments();

            $isFacultyValid = collect($facultyList)->contains(function ($item) use ($data) {
                return isset($item['faculty_id']) && $item['faculty_id'] === $data['faculty_id'];
            });

            if (!$isFacultyValid) {
                return response()->json(['message' => 'fakultas id tidak ada di database'], 422);
            }
        }

        // validasi nama prodi, ga boleh ada nama yang sama
        if (isset($data['nama'])) {
            $prodiList = $this->prodiService->getAllDocuments();

            $isprodiValid = collect($prodiList)->contains(function ($item) use ($data) {
                return isset($item['nama']) && $item['nama'] === $data['nama'];
            });

            if ($isprodiValid) {
                return response()->json(['message' => 'nama sudah ada di database'], 422);
            }
        }

        // Ambil nilai asli dari dokumen Firestore
        $oldDataPlain = [];
        foreach ($oldData as $key => $value) {
            $oldDataPlain[$key] = $value['stringValue'] ?? null;
        }

        foreach (['faculty_id', 'nama'] as $field) {
            if (isset($data[$field])) {
                $oldDataPlain[$field] = $data[$field];
            }
        }

        // Pastikan user_id tetap disimpan
        $oldDataPlain['prodi_id'] = $prodi_id;

        // Update dokumen di Firestore
        $this->prodiService->updateDocument($prodi_id, $oldDataPlain);

        return response()->json([
            'message' => 'prodi berhasil diupdate',
            'data' => $oldDataPlain,
        ]);
    }

    public function destroy(string $prodi_id) {
        $oldData = $this->prodiService->getDocumentById('prodi', $prodi_id);

        if (!$oldData) {
            return response()->json(['message' => 'prodi id tidak ditemukan'], 404);
        }

        $courseService = new FirestoreService('course', app(\App\Services\FirebaseTokenService::class));
        $courses = $courseService->getDocuments();

        // Filter dokumen yang memiliki prodi_id yang cocok, lalu hapus
        foreach ($courses as $item) {
            if (isset($item['prodi_id']) && $item['prodi_id'] === $prodi_id) {
                app(\App\Http\Controllers\Api\CourseController::class)->destroy($item['id']);
            }
        }

        $userService = new FirestoreService('users', app(\App\Services\FirebaseTokenService::class));
        $users = $userService->getDocuments();

        //filter dokum user yang punya prodi_id, lalu ganti prodi_id dengan null
        foreach ($users as $item) {
            if (isset($item['prodi_id']) && $item['prodi_id'] === $prodi_id && isset($item['id'])) {
                // Ambil semua isi dokumen user
                $fullDoc = $userService->getDocumentById('users', $item['id']);
                
                // Ubah ke format flat array
                $plain = [];
                foreach ($fullDoc as $key => $val) {
                    $plain[$key] = $val[array_key_first($val)] ?? null;
                }

                // Set prodi_id jadi null
                $plain['prodi_id'] = null;

                // Kirim ulang seluruh isi dokumen (overwrite semua field, tapi aman)
                $userService->updateDocument($item['id'], $plain);
            }
        }

        $this->prodiService->deleteDocument($prodi_id);
        return response()->json([
            'message' => 'prodi berhasil dihapus'
        ], 200);
    }
}
