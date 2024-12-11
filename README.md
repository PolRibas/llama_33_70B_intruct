# Llama-3.3-70B-Instruct Service

This repository contains a Dockerized FastAPI service that provides an HTTP API to interact with Meta's **Llama-3.3-70B-Instruct** model hosted on Hugging Face. The service allows you to generate text based on user inputs through a simple API endpoint.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [1. Clone the Repository](#1-clone-the-repository)
  - [2. Obtain Hugging Face API Token](#2-obtain-hugging-face-api-token)
  - [3. Create Environment Variables](#3-create-environment-variables)
  - [4. Verify Requirements](#4-verify-requirements)
- [Docker Setup](#docker-setup)
  - [1. Build the Docker Image](#1-build-the-docker-image)
  - [2. Run the Docker Container](#2-run-the-docker-container)
- [](#usage)
  - [API Endpoint](#api-endpoint)
  - [Example Request](#example-request)
  - [Example Response](#example-response)
- [Security Considerations](#security-considerations)
- [License](#license)
- [Acknowledgements](#acknowledgements)
- [Contact](#contact)

## Features

- **Text Generation API**: Generate text responses using the Llama-3.3-70B-Instruct model.
- **Dockerized Environment**: Simplifies setup and deployment using Docker.
- **Caching Mechanism**: Utilizes a mounted volume to cache model files, reducing download times and saving disk space.
- **Environment Variable Configuration**: Securely manage sensitive information like API tokens using environment variables.
- **Multilingual Support**: Supports 8 languages including English, German, French, Italian, Portuguese, Hindi, Spanish, and Thai.
- **Extended Context Window**: Handles context lengths up to 128k tokens for more comprehensive text generation.

## Prerequisites

1. **Access to the Model**:
   - Ensure you have access to the [meta-llama/Llama-3.3-70B-Instruct](https://huggingface.co/meta-llama/Llama-3.3-70B-Instruct) model on Hugging Face. This is a gated (private) repository.

2. **Hugging Face API Token**:
   - Obtain a personal access token from your Hugging Face account.
   - Navigate to [Hugging Face Tokens](https://huggingface.co/settings/tokens) to create a new token with the necessary permissions.

3. **Docker**:
   - Install Docker on your machine. You can download it from [Docker Desktop](https://www.docker.com/products/docker-desktop).

4. **Git**:
   - Ensure Git is installed to clone the repository.

## Installation

### 1. Clone the Repository

Clone the repository to your local machine and navigate into it:

```bash
git clone https://github.com/your_username/llama_33_70B_instruct_service.git
cd llama_33_70B_instruct_service
```

### 2. Obtain Hugging Face API Token

- Log in to your [Hugging Face account](https://huggingface.co/).
- Navigate to [API Tokens](https://huggingface.co/settings/tokens).
- Click on "New token" and generate a token with at least `read` access.

### 3. Create Environment Variables

Create a `.env` file in the root directory of the project with the following content:

```env
HUGGINGFACE_API_KEY=your_hugging_face_api_token_here
```

**Important:** Ensure that the `.env` file is added to `.gitignore` to prevent accidental exposure of your API token.

### 4. Verify Requirements

Ensure your `requirements.txt` includes the necessary dependencies:

```txt
numpy<2
fastapi
uvicorn[standard]
transformers>=4.43.0
safetensors
torch==2.0.1+cpu -f https://download.pytorch.org/whl/cpu/torch_stable.html
python-dotenv
accelerate>=0.26.0
```

## Docker Setup

### 1. Build the Docker Image

Run the following command to build the Docker image:

```bash
sudo docker build -t my-llama-service:latest .
```

**Note:** Depending on your Docker installation, you might not need to use `sudo`. To run Docker commands without `sudo`, add your user to the Docker group:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### 2. Run the Docker Container

Use the provided `run.sh` script to build and run the Docker container with the necessary volume mappings.

#### `run.sh` Script

Create a `run.sh` file with the following content:

```bash
#!/usr/bin/env bash

# Get the current directory
CURRENT_DIR=$(pwd)

# Define the cache directory relative to the current directory
CACHE_DIR="$CURRENT_DIR/llama_cache"

# Create the cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Build the Docker image
docker build -t my-llama-service:latest .

# Run the Docker container with the volume mounted
docker run -it --rm -p 8002:8002 \
  -v "$CACHE_DIR":/root/.cache/huggingface/hub \
  --env-file .env \
  my-llama-service:latest
```

#### Make the Script Executable

```bash
chmod +x run.sh
```

#### Execute the Script

```bash
./run.sh
```

This script performs the following actions:

1. **Builds the Docker image** named `my-llama-service:latest` using the provided `Dockerfile`.
2. **Creates a `llama_cache` directory** in the current folder to store Hugging Face cache files.
3. **Runs the Docker container**, mounting the `llama_cache` directory to `/root/.cache/huggingface/hub` inside the container.
4. **Exposes the service** on port `8002`.

## Usage

Once the service is running, you can interact with it by sending POST requests to the `/generate` endpoint.

### API Endpoint

- **URL:** `http://localhost:8002/generate`
- **Method:** `POST`
- **Content-Type:** `application/json`
- **Request Body:**
  - `messages`: An array of message objects containing `role` and `content`.
  - `max_new_tokens`: (Optional) Maximum number of tokens to generate. Defaults to `256`.

### Example Request

```bash
curl -X POST http://localhost:8002/generate \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "You are a pirate chatbot who always responds in pirate speak!"},
      {"role": "user", "content": "Who are you?"}
    ],
    "max_new_tokens": 100
  }'
```

### Example Response

```json
{
  "generated_text": "Arrr! I be yer trusty pirate chatbot, here to assist ye on the high seas. What can I do fer ye today?"
}
```

## Security Considerations

- **Protect Your API Token:** Do not expose your `.env` file or API token in public repositories. Ensure that `.env` is listed in `.gitignore` to prevent accidental commits.
  
- **Docker Permissions:** Running Docker commands with `sudo` is common but consider configuring Docker to run without `sudo` for convenience and security.

- **Data Privacy:** Ensure that any data processed by the service complies with relevant data privacy laws and guidelines.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgements

- [Hugging Face](https://huggingface.co/) for providing the Llama models and the Transformers library.
- [FastAPI](https://fastapi.tiangolo.com/) for the web framework.
- [Docker](https://www.docker.com/) for containerization.

## Contact

For any questions or support, please open an issue in the repository or contact the maintainer at [polribasrovira@gmail.com](mailto:polribasrovira@gmail.com).
