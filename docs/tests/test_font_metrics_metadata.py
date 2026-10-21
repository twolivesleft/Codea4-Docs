"""Validate completion metadata for font measurement snapshots."""
import json
import unittest
from pathlib import Path


class FontMetricsMetadataTests(unittest.TestCase):
    def test_snapshot_fields_are_discoverable(self):
        path = Path(__file__).resolve().parents[1] / "build/luadoc/api/font.json"
        entries = json.loads(path.read_text())
        metrics = next(e for e in entries if e.get("kind") == "function")
        self.assertEqual(metrics["module"], "font")
        self.assertEqual(metrics["name"], "metrics")
        self.assertEqual(metrics["parameters"], [])
        self.assertEqual(metrics["returns"][0]["type"], "font.private.metrics")
        self.assertEqual(metrics["returns"][0]["displayType"], "table")
        fields = next(e for e in entries if e.get("kind") == "class")["members"]
        self.assertEqual({e["name"] for e in fields}, {
            "size", "ascent", "descent", "leading", "xHeight", "capHeight",
            "underlinePosition", "underlineThickness"
        })
        for field in fields:
            self.assertEqual(field["type"], "number")
            self.assertTrue(field["helptext"])
