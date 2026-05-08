import pandas as pd
import os
import time
import json
from dotenv import load_dotenv, find_dotenv
import google.generativeai as genai

from google.api_core.exceptions import (
    ResourceExhausted,
    TooManyRequests,
    InternalServerError,
    ServiceUnavailable,
    Aborted
)

# load env
load_dotenv(find_dotenv())

API_KEY = os.getenv("GOOGLE_API_KEY")

if not API_KEY:
    raise ValueError("API Key not found!")

genai.configure(api_key=API_KEY)

# init model

model = genai.GenerativeModel(
    "gemini-3.1-flash-lite"
)

# load data
df = pd.read_csv("Game Thumbnail.csv")

# add columns
df["genre"] = ""
df["short_description"] = ""
df["player_mode"] = ""

# main 

def build_prompt(title):

    return f"""
You are a video game metadata assistant.

Game Title:
{title}

Task 1 - Genre Classification
Rules:
- Return ONLY one genre word
- Example:
Shooter
RPG
Strategy

Task 2 - Short Description
Rules:
- Maximum 30 words
- Concise and engaging
- No extra explanation

Task 3 - Player Mode
Rules:
- Return ONLY one:
Singleplayer
Multiplayer
Both

Return ONLY valid JSON format.

Example:
{{
    "genre": "Shooter",
    "short_description": "Fast-paced multiplayer shooter with tactical combat and competitive gameplay.",
    "player_mode": "Multiplayer"
}}
"""

# api 

def call_ai(prompt, retries=8):

    delay = 5

    for attempt in range(retries):

        try:
            response = model.generate_content(prompt)

            text = response.text.strip()

            text = text.replace("```json", "").replace("```", "").strip()

            data = json.loads(text)

            return {
                "genre": data.get("genre", "Unknown"),
                "short_description": data.get("short_description", "No description"),
                "player_mode": data.get("player_mode", "Unknown")
            }

        except json.JSONDecodeError:
            print("JSON parse error")
            return {
                "genre": "Unknown",
                "short_description": "Failed",
                "player_mode": "Unknown"
            }

        except (
            ResourceExhausted,
            TooManyRequests,
            InternalServerError,
            ServiceUnavailable,
            Aborted
        ) as e:

            print(f"Retry {attempt+1} API limit or temporary service issue: {e}")

            time.sleep(delay)
            delay = min(delay * 2, 120)

        except Exception as e:
            print(f"Unexpected Error: {e}")

            return {
                "genre": "Error",
                "short_description": "Error",
                "player_mode": "Error"
            }

    return {
        "genre": "Failed",
        "short_description": "Failed",
        "player_mode": "Failed"
    }

# loop 
for i, row in df.iterrows():

    title = row["game_title"]
    print(f"Processing {i+1}/{len(df)}: {title}", flush=True)

    result = call_ai(build_prompt(title))

    df.at[i, "genre"] = result["genre"]
    df.at[i, "short_description"] = result["short_description"]
    df.at[i, "player_mode"] = result["player_mode"]

    df.to_csv("enhanced_games_backup.csv", index=False)
    time.sleep(4)


output_file = "enhanced_games.csv"
df.to_csv(output_file, index=False)
print(f"Saved to {output_file}")
