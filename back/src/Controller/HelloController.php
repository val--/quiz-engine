<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;

class HelloController extends AbstractController
{
    #[Route('/api/hello', name: 'app_hello')]
    public function index(): JsonResponse
    {
        return new JsonResponse([
            'message' => 'Nothing to see here yet.',
        ]);
    }
}
