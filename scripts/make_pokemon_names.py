"""PokeAPI 데이터로 앱에 넣을 포켓몬 이름 목록(번호, 영어, 한국어)을 만든다.

usage: python3 scripts/make_pokemon_names.py [csv 경로] > Pokedex/Data/pokemon-names.json
  csv 경로를 빼면 PokeAPI 저장소의 pokemon_species_names.csv 를 내려받는다.
"""
import csv
import io
import json
import sys
import urllib.request

URL = "https://raw.githubusercontent.com/PokeAPI/pokeapi/master/data/v2/csv/pokemon_species_names.csv"
KOREAN, ENGLISH = "3", "9"
MAX_ID = 1025


def main():
    if len(sys.argv) > 1:
        text = open(sys.argv[1], encoding="utf-8").read()
    else:
        text = urllib.request.urlopen(URL).read().decode("utf-8")

    names = {}
    for row in csv.DictReader(io.StringIO(text)):
        if row["local_language_id"] in (KOREAN, ENGLISH):
            names.setdefault(int(row["pokemon_species_id"]), {})[row["local_language_id"]] = row["name"]

    entries = [
        {"id": id, "name": names[id][ENGLISH], "koreanName": names[id][KOREAN]}
        for id in range(1, MAX_ID + 1)
    ]
    lines = [json.dumps(entry, ensure_ascii=False) for entry in entries]
    print("[\n" + ",\n".join(lines) + "\n]")


if __name__ == "__main__":
    main()
